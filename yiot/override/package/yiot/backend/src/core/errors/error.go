package errors

import (
	"fmt"
)

//
// Err is an application error object.
//
type Err struct {
	Msg string
}

//
// New returns a new error instance.
//
func New(format string, args ...interface{}) Err {

	return Err{Msg: fmt.Sprintf(format, args...)}
}

//
// Error returns an error message and implements system errors interface.
//
func (e Err) Error() string {

	return e.Msg
}

//
// WithMessage returns a new error instance with extra info.
//
// Usage:
//   err := New("some application error")
//   err = err.WithMessage("additional error info")
//
//
func (e Err) WithMessage(format string, args ...interface{}) error {

	return WithMessage(e, format, args...)
}
