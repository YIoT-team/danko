package errors

import (
	"fmt"
	"net/http"
)

//
// HTTPError error object.
//
type HTTPError struct {
	status int    `json:"-"`
	Code   int    `json:"code"`
	Msg    string `json:"message"`
}

//
// NewHTTPError returns new HTTP error object.
//
func NewHTTPError(status, code int, msg string) HTTPError {

	return HTTPError{status: status, Code: code, Msg: msg}
}

//
// NewHTTP400Error returns HTTP 400 (Bad request) error.
//
func NewHTTP400Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusBadRequest, code, msg)
}

//
// NewHTTP401Error returns HTTP 401 (Unauthorized) error.
//
func NewHTTP401Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusUnauthorized, code, msg)
}

//
// NewHTTP403Error returns HTTP 403 (Forbidden) error.
//
func NewHTTP403Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusForbidden, code, msg)
}

//
// NewHTTP404Error returns HTTP 404 (Not Found) error.
//
func NewHTTP404Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusNotFound, code, msg)
}

//
// NewHTTP500Error returns HTTP 500 (Internal server error) error.
//
func NewHTTP500Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusInternalServerError, code, msg)
}

//
// NewHTTP501Error returns HTTP 501 (Not implemented error) error.
//
func NewHTTP501Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusNotImplemented, code, msg)
}

//
// NewHTTP504Error returns HTTP 504 (Gateway timeout error) error.
//
func NewHTTP504Error(code int, msg string) HTTPError {

	return NewHTTPError(http.StatusGatewayTimeout, code, msg)
}

//
// GetCode returns the error Code.
//
func (e HTTPError) GetCode() int {

	return e.Code
}

//
// GetMessage returns an error Message.
//
func (e HTTPError) GetMessage() string {

	return e.Msg
}

//
// GetStatus returns an HTTP status.
//
func (e HTTPError) GetStatus() int {

	return e.status
}

//
// GetContentType returns the HTTP Content Type of an error.
//
func (e HTTPError) GetContentType() string {
	return "application/json"
}

//
// Error returns a string representation for the error.
//
func (e HTTPError) Error() string {
	if "" != e.Msg && 0 != e.Code {
		return fmt.Sprintf(`{"code": %d, "message": "%s"}`, e.Code, e.Msg)
	}

	return ""
}

//
// WithMessage returns a new error instance with extra info.
//
func (e HTTPError) WithMessage(format string, args ...interface{}) error {

	return WithMessage(e, format, args...)
}
