package http

import (
	"net/http"

	"yiot_api/core/http/response"
)

//
// APIHandler handler.
//
type APIHandler func(req *http.Request) (response.Provider, error)
