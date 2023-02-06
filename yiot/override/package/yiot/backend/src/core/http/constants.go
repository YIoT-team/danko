package http

import (
	"net/http"

	"yiot_api/core/http/response"
)

//
// Wrapper over default http methods, needed to remove dependency from net/http when using this package.
//
const (
	MethodHead    = http.MethodHead
	MethodGet     = http.MethodGet
	MethodPost    = http.MethodPost
	MethodDelete  = http.MethodDelete
	MethodPatch   = http.MethodPatch
	MethodPut     = http.MethodPut
	MethodOptions = http.MethodOptions
	MethodTrace   = http.MethodTrace
	MethodConnect = http.MethodConnect
)

//
// Handler is an alias for http.Handler type.
//
type Handler = func(req *http.Request) (response.Provider, error)

//
// HandlerFunc is an alias for http.HandlerFunc type.
//
type HandlerFunc = http.HandlerFunc

//
// Header is an alias for http.Header type.
//
type Header = http.Header
