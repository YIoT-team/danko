package errors

import (
	"fmt"
)

//
// AppError error object.
//
type AppError struct {
	Code int    `json:"code"`
	Msg  string `json:"message"`
}

//
// NewAppError returns new application error object.
//
func NewAppError(code int, msg string) AppError {

	return AppError{Code: code, Msg: msg}
}

//
// GetCode returns the error Code.
//
func (e AppError) GetCode() int {

	return e.Code
}

//
// GetMessage returns an error Message.
//
func (e AppError) GetMessage() string {

	return e.Msg
}

//
// Error returns a string representation for the error.
//
func (e AppError) Error() string {
	if "" != e.Msg && 0 != e.Code {
		return fmt.Sprintf(`{"code": %d, "message": "%s"}`, e.Code, e.Msg)
	}

	return ""
}

//
// WithMessage returns a new error instance with extra info.
//
func (e AppError) WithMessage(format string, args ...interface{}) error {

	return WithMessage(e, format, args...)
}
