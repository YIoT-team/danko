package http

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus/promhttp"

	"yiot_api/core/errors"
	"yiot_api/core/http/health"
	"yiot_api/core/http/metrics"
	"yiot_api/core/http/pprof"
	"yiot_api/core/http/response"
	"yiot_api/core/log"
)

//
// RouterProvider provides an interface to work with Application Router.
//
type RouterProvider interface {

	//
	// GetMuxRouter returns the Request handler.
	//
	GetMuxRouter() *mux.Router

	//
	// HandlerResponse returns the Response handler.
	//
	HandleResponse(http.ResponseWriter, *http.Request, Handler)

	//
	// Get function add to router rule to handle specified route only by http Get method.
	//
	Get(string, Handler)

	//
	// Post function add to router rule to handle specified route only by http Post method.
	//
	Post(string, Handler)

	//
	// Put function add to router rule to handle specified route only by http Put method.
	//
	Put(string, Handler)

	//
	// Patch function add to router rule to handle specified route only by http Patch method.
	//
	Patch(string, Handler)

	//
	// Options function add to router rule to handle specified route only by http Options method.
	//
	Options(string, Handler)

	//
	// Delete function add to router rule to handle specified route only by http Delete method.
	//
	Delete(string, Handler)

	//
	// Trace function add to router rule to handle specified route only by http Trace method.
	//
	Trace(string, Handler)

	//
	// Handle function allows you to accept all types of requests to specified route.
	//
	Handle(string, HandlerFunc)
}

//
// Router is a Application router.
//
type Router struct {
	logger               log.Logger
	router               *mux.Router
	pprofAuthToken       string
	unhandledErrorMetric metrics.Counter
	requestLatencyMetric metrics.SummaryVec
	responseStatusMetric metrics.CounterVec
	healthDependencyList []health.Provider
}

//
// NewRouter returns a new Router instance.
//
func NewRouter(logger log.Logger, metricPrefix string, options ...func(*Router)) *Router {

	r := Router{
		logger:               logger,
		router:               mux.NewRouter(),
		unhandledErrorMetric: metrics.NewServiceUnhandledError(metricPrefix),
		requestLatencyMetric: metrics.NewServiceRequestLatency(metricPrefix),
		responseStatusMetric: metrics.NewServiceResponseStatus(metricPrefix),
		healthDependencyList: []health.Provider{},
	}

	for _, option := range options {
		option(&r)
	}

	r.initializeServiceRouteList()

	return &r
}

//
// GetMuxRouter returns the Request handler.
//
func (r *Router) GetMuxRouter() *mux.Router {

	return r.router
}

//
// HandleResponse handles the response.
//
func (r *Router) HandleResponse(w http.ResponseWriter, req *http.Request, h Handler) {

	// Calculate request latency metric.
	if route, ok := req.Context().Value(ContextRouteKey).(string); ok && route != "" {
		begin := time.Now()
		defer func() {
			r.requestLatencyMetric.WithLabelValues(
				req.Method, route,
			).Observe(time.Since(begin).Seconds())
		}()
	}

	resp, err := h(req)
	if err != nil {
		httpError := errors.Cause(err, (*errors.HTTPError)(nil))
		if httpError == nil {
			r.processUnhandledError(w, req, err)
			return
		}

		r.processServiceError(w, req, err)
		return
	}

	data, err := resp.GetData()
	if err != nil {
		r.processDataError(w, req, errors.WithMessage(err, "data serialization error"))
		return
	}

	// Make response post processing.
	if pp := resp.GetPostProcessor(); pp != nil {
		if err := pp.Process(); err != nil {
			r.processDataError(w, req, errors.WithMessage(err, "data post processing error"))
			return
		}
	}

	// Send response headers.
	r.writeResponse(w, req, resp.GetStatus(), data, resp.GetHeaders())
}

//
// processDataError makes processing of the error occurred
// because of data serialization or data post processing.
//
func (r *Router) processDataError(w http.ResponseWriter, req *http.Request, err error) {

	r.logger.Error("%+v", err)

	r.writeResponse(w, req, http.StatusInternalServerError, nil, http.Header{})
}

//
// processServiceError makes processing of the error that occurred
// in case of validation or any other service error.
//
func (r *Router) processServiceError(w http.ResponseWriter, req *http.Request, err error) {

	httpError := errors.Cause(err, (*errors.HTTPError)(nil)).(errors.HTTPError)
	if httpError.GetStatus() >= http.StatusInternalServerError {
		r.logger.Error("HTTP 5xx error happened: %v", err)
	} else {
		r.logger.Debug("%v", err)
	}

	r.writeResponse(
		w,
		req,
		httpError.GetStatus(),
		[]byte(httpError.Error()),
		http.Header{
			"Content-Type": []string{httpError.GetContentType()},
		},
	)
}

//
// processUnhandledError makes processing of the unhandled service error.
//
func (r *Router) processUnhandledError(w http.ResponseWriter, req *http.Request, err error) {

	r.logger.Error("internal unhandled error: %+v", err)
	r.unhandledErrorMetric.Inc()

	r.writeResponse(w, req, http.StatusInternalServerError, nil, http.Header{})
}

//
// writeResponse writes data to the connection.
//
func (r *Router) writeResponse(
	writer http.ResponseWriter,
	req *http.Request,
	status int,
	data []byte,
	headers http.Header,
) {

	defer func() {
		if route, ok := req.Context().Value(ContextRouteKey).(string); ok && route != "" {
			r.responseStatusMetric.WithLabelValues(
				req.Method,
				fmt.Sprintf("%s", route),
				fmt.Sprintf("%d", status),
			).Inc()
		}
	}()

	// write request headers.
	for name, value := range headers {
		writer.Header().Set(name, strings.Join(value, " "))
	}

	// write HTTP status code.
	writer.WriteHeader(status)

	// write response data.
	if data != nil {
		_, err := writer.Write(data)
		if err != nil {
			r.logger.Error("data writing error: %+v", err)
		}
	}
}

//
// handle internal wrapper for original Gorilla MUX Handle method but with some internal filtering.
//
func (r *Router) handle(route string, h Handler, methods ...string) {

	wrappedHandler := http.HandlerFunc(
		func(w http.ResponseWriter, req *http.Request) {
			r.HandleResponse(w, req.WithContext(
				context.WithValue(req.Context(), ContextRouteKey, route),
			), h)
		},
	)

	//
	// Apply back compatibility for trailing slashes for some surprise cases.
	//
	r.router.Handle(route, wrappedHandler).Methods(methods...)
	r.router.Handle(func() string {
		if strings.HasSuffix(route, "/") {
			return strings.TrimRight(route, "/")
		}

		return route + "/"

	}(), wrappedHandler).Methods(methods...)
}

//
// initializeServiceRouteList makes setup of standard service endpoints,
// like: /_service/info,
// 		 /_service/status
// 		 /_service/metrics.
//
func (r *Router) initializeServiceRouteList() {

	r.Get(RouteServiceStatus, func(req *http.Request) (response.Provider, error) {
		return response.NewResponse(nil, http.StatusOK), nil
	})

	r.Get(RouteServiceInfo, func(req *http.Request) (response.Provider, error) {

		status := http.StatusOK
		dependencies := make(map[string]*health.Data, len(r.healthDependencyList))
		for _, dependency := range r.healthDependencyList {
			h, err := dependency.GetHealth()
			if err != nil {
				r.logger.Error("service health check error: %+v", err)
			}

			if h.GetStatus() != http.StatusOK {
				status = h.GetStatus()
			}

			dependencies[h.GetName()] = h
		}

		return response.NewResponse(
			health.NewServiceInfoResponse(health.NewBuildInfo(), dependencies), status,
		), nil

	})

	r.GetMuxRouter().Handle(RouteServiceMetrics, promhttp.Handler()).Methods(MethodGet)
}

//
// Get function add to router rule to handle specified route only by http Get method.
//
func (r *Router) Get(path string, h Handler) {
	r.handle(path, h, MethodGet)
}

//
// Post function add to router rule to handle specified route only by http Post method.
//
func (r *Router) Post(path string, h Handler) {
	r.handle(path, h, MethodPost)
}

//
// Put function add to router rule to handle specified route only by http Put method.
//
func (r *Router) Put(path string, h Handler) {
	r.handle(path, h, MethodPut)
}

//
// Patch function add to router rule to handle specified route only by http Patch method.
//
func (r *Router) Patch(path string, h Handler) {
	r.handle(path, h, MethodPatch)
}

//
// Options function add to router rule to handle specified route only by http Options method.
//
func (r *Router) Options(path string, h Handler) {
	r.handle(path, h, MethodOptions)
}

//
// Delete function add to router rule to handle specified route only by http Delete method.
//
func (r *Router) Delete(path string, h Handler) {
	r.handle(path, h, MethodDelete)
}

//
// Trace function add to router rule to handle specified route only by http Trace method.
//
func (r *Router) Trace(path string, h Handler) {
	r.handle(path, h, MethodTrace)
}

//
// Handle function allows you to accept all types of requests to specified route.
//
func (r *Router) Handle(path string, h HandlerFunc) {
	r.router.PathPrefix(path).Handler(h)
}

//
// EnableDebug enables pprof debug and connects pprof endpoints to the router.
// All pprof HTTP endpoints are available under /_service/debug route.
//
func EnableDebug(o string) func(*Router) {
	return func(r *Router) {
		if o != "" {
			r.GetMuxRouter().Handle(RouteServiceDebug, http.StripPrefix(
				"/_service/debug",
				pprof.AuthHandler(o),
			)).Methods(http.MethodGet)
		}
	}
}

//
// SetupHealthDependencyList makes setup of service dependency list.
// This information is used to provide extended health info through
// the standard service health /_service/info endpoint.
//
func SetupHealthDependencyList(o ...health.Provider) func(*Router) {
	return func(r *Router) {
		r.healthDependencyList = o
	}
}
