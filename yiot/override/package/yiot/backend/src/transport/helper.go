package transport

import (
	"encoding/json"
	"io"
	"io/ioutil"
	"net/http"

	"yiot_api/api"
	kitHTTP "yiot_api/core/http"
)

//
// NewHeaders constructs Headers structure.
//
func NewHeaders(req *http.Request) (*api.Headers, error) {

	h := api.Headers{
		OwnerID: req.Header.Get(kitHTTP.HeaderOwnerID),
	}

	return &h, nil
}

//
// NewGetRequest constructs YIoTBaseRequest structure.
//
func NewGetRequest(req *http.Request) (*api.YIoTBaseRequest, error) {

	h, err := NewHeaders(req)
	if err != nil {
		return nil, err
	}

	request := api.YIoTBaseRequest{
		Headers: h,
	}

	return &request, nil
}

//
// NewBaseRequest constructs YIoTBaseRequest structure.
//
func NewBaseRequest(req *http.Request) (*api.YIoTBaseRequest, error) {

	h, err := NewHeaders(req)
	if err != nil {
		return nil, err
	}

	request := api.YIoTBaseRequest{
		Headers: h,
	}

	if err = unmarshal(req.Body, &request); err != nil {
		return nil, err
	}

	return &request, nil
}

//
// unmarshal makes unmarshal request body according request structure.
//
func unmarshal(req io.Reader, obj interface{}) error {

	body, err := ioutil.ReadAll(req)
	if err != nil {
		return api.ErrRequestParsing
	}

	if err = json.Unmarshal(body, obj); err != nil {
		return api.ErrRequestParsing
	}

	return nil
}
