package http

import (
	"net/http"
	"strconv"

	"yiot_api/core/http/response"
)

//
// SetServiceActionID set service action id to response header
//
func SetServiceActionID(actionID int, h Handler) Handler {
	var actionIdStr = strconv.Itoa(actionID)
	return func(req *http.Request) (response.Provider, error) {
		resp, err := h(req)
		if nil == err {
			resp.SetHeader("SERVICE-ACTION-ID", actionIdStr)
		}
		return resp, err
	}
}
