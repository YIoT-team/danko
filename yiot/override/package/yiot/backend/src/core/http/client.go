package http

import (
	"bytes"
	"io/ioutil"
	"net"
	"net/http"
	"time"

	"yiot_api/core/breaker"
	"yiot_api/core/errors"
	"yiot_api/core/log"
)

//
// ClientProvider is and interface for http client wrapper.
//
type ClientProvider interface {
	//
	// Do executes the HTTP request and returns response body.
	//
	Do(*ClientRequest) (*ClientResponse, error)
}

const (
	//
	// DefaultMaxIdleConnections controls the maximum number of idle (keep-alive)
	// connections across all hosts. Zero means no limit.
	//
	DefaultMaxIdleConnections = 2048

	//
	// DefaultMaxIdleConnectionsPerHost if non-zero, controls the maximum idle
	// (keep-alive) connections to keep per-host.
	//
	DefaultMaxIdleConnectionsPerHost = 2048

	//
	// DefaultIdleConnectionTimeout is the maximum amount of time an idle
	// (keep-alive) connection will remain idle before closing
	// itself.
	//
	DefaultIdleConnectionTimeout = 60 * time.Second

	//
	// DefaultRetryCount total count of retry.
	//
	DefaultRetryCount = 4

	//
	// DefaultRetryDelay the default delay between tries.
	//
	DefaultRetryDelay = 20 * time.Millisecond

	//
	// DefaultClientTimeout the default request timeout.
	//
	DefaultClientTimeout = 5 * time.Second
)

//
// ClientRequest stores basic info about http request which need to be sent.
//
type ClientRequest struct {
	Method string
	Route  string
	Header map[string][]string
	Body   []byte
}

//
// ClientResponse type is an alias for http.Response type.
//
type ClientResponse struct {
	StatusCode int
	Header     map[string][]string
	Body       []byte
}

//
// Client is a basic http client wrapper over standard golang http client.
//
type Client struct {
	httpClient          http.Client
	logger              log.Logger
	maxIdleConns        int
	retryCount          int
	maxIdleConnsPerHost int
	clientTimeout       time.Duration
	retryDelay          time.Duration
	idleConnTimeout     time.Duration
	breakerSetting      *breaker.Settings
}

//
// NewClient returns Client object with http call timeout configured.
//
func NewClient(log log.Logger, options ...func(*Client)) (*Client, error) {

	breakerSetting, ok := breaker.GetCircuitSettings()[breaker.CommandCoreHTTPClient]
	if !ok {
		return nil, errors.New(
			"circuit breaker %s command was not initialized for a HTTP client", breaker.CommandCoreHTTPClient,
		)
	}

	c := Client{
		logger:              log,
		clientTimeout:       DefaultClientTimeout,
		breakerSetting:      breakerSetting,
		maxIdleConns:        DefaultMaxIdleConnections,
		retryCount:          DefaultRetryCount,
		maxIdleConnsPerHost: DefaultMaxIdleConnectionsPerHost,
		retryDelay:          DefaultRetryDelay,
		idleConnTimeout:     DefaultIdleConnectionTimeout,
	}

	for _, option := range options {
		option(&c)
	}

	c.httpClient = http.Client{
		Timeout: c.clientTimeout,
		Transport: &http.Transport{
			MaxIdleConns:        c.maxIdleConns,
			IdleConnTimeout:     c.idleConnTimeout,
			MaxIdleConnsPerHost: c.maxIdleConnsPerHost,
		},
	}

	return &c, nil
}

//
// Do executes the HTTP request and returns response body.
//
func (c Client) Do(req *ClientRequest) (*ClientResponse, error) {

	resp, err := c.retry(req)
	if err != nil {
		return nil, errors.WithMessage(err, "can't get response")
	}

	if resp != nil {
		defer resp.Body.Close()
	}

	respBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, errors.WithMessage(err, "can't read response body: %v", resp.Body)
	}

	return &ClientResponse{
		StatusCode: resp.StatusCode,
		Header:     resp.Header,
		Body:       respBody,
	}, nil
}

//
// retry makes retries for requests which has been timed out or has 500 status code in response.
//
func (c Client) retry(req *ClientRequest) (*http.Response, error) {

	for try := 1; ; try++ {

		r, err := newRequest(req.Method, req.Route, req.Body, req.Header)
		if err != nil {
			return nil, errors.WithMessage(err, "can't create request for: %v", req.Body)
		}

		resp, err := c.do(r)
		if !isResponseRetriable(resp, err) {
			return resp, err
		}

		if err != nil {
			c.logger.Error(errors.WithMessage(
				err,
				"cant get response from the service %s. parameters: method %s, request %v, try count %d, timeout %s",
				req.Route,
				req.Method,
				string(req.Body),
				try,
				c.breakerSetting.Timeout,
			).Error())
		}

		// Do not sleep when retries amount reached limit
		if try == c.retryCount {
			break
		}

		time.Sleep(c.retryDelay)
	}

	return nil, errors.New(
		"retry limit has reached for the service: %s. parameters: method %s, request %v",
		req.Route,
		req.Method,
		string(req.Body),
	)
}

//
// do sends the HTTP request.
//
func (c Client) do(r *http.Request) (*http.Response, error) {

	response := &http.Response{}
	if err := breaker.Do(breaker.CommandCoreHTTPClient, func() (err error) {
		response, err = c.httpClient.Do(r)

		return err
	}, nil); err != nil {
		if _, ok := err.(breaker.CircuitError); ok {
			return nil, errors.WithMessage(
				err, "hystrix error has occurred for command: %s", breaker.CommandCoreHTTPClient,
			)
		}

		return nil, err
	}

	return response, nil
}

//
// Timeout sets the HTTP Client timeout option.
//
func Timeout(o time.Duration) func(*Client) {
	return func(c *Client) {
		c.clientTimeout = o
	}
}

//
// RetryDelay sets the HTTP Client RetryDelay option.
//
func RetryDelay(o time.Duration) func(*Client) {
	return func(c *Client) {
		c.retryDelay = o
	}
}

//
// RetryCount sets the HTTP Client RetryCount option.
//
func RetryCount(o int) func(*Client) {
	return func(c *Client) {
		c.retryCount = o
	}
}

//
// IdleConnectionTimeout sets the HTTP Client IdleConnectionTimeout option.
//
func IdleConnectionTimeout(o time.Duration) func(*Client) {
	return func(c *Client) {
		c.idleConnTimeout = o
	}
}

//
// MaxIdleConnectionsPerHost sets the HTTP Client MaxIdleConnectionsPerHost option.
//
func MaxIdleConnectionsPerHost(o int) func(*Client) {
	return func(c *Client) {
		c.maxIdleConnsPerHost = o
	}
}

//
// MaxIdleConnections sets the HTTP Client MaxIdleConnections option.
//
func MaxIdleConnections(o int) func(*Client) {
	return func(c *Client) {
		c.maxIdleConns = o
	}
}

//
// isResponseRetriable checks that response is not Retriable.
//
func isResponseRetriable(resp *http.Response, err error) bool {

	if err != nil {
		if err = errors.Cause(err, (*breaker.CircuitError)(nil)); err != nil {
			if err == breaker.ErrTimeout {
				return true
			}
		}

		if netErr, ok := err.(net.Error); ok {
			return netErr.Timeout()
		}
	}

	if resp != nil {
		return resp.StatusCode >= http.StatusInternalServerError
	}

	return false
}

//
// newRequest is a function helper which creates request and sets headers for http.Request
//
func newRequest(m, r string, b []byte, h map[string][]string) (*http.Request, error) {

	req, err := http.NewRequest(m, r, bytes.NewReader(b))
	if err != nil {
		return nil, err
	}

	req.Header = h

	return req, nil
}
