package errors

import (
	"fmt"

	"yiot_api/core/errors/stack"
)

//
// Chain is errors chain wrapping object.
//
type Chain struct {
	errs []error // The chain of errors in reverse order so the oldest error goes first.

	stack *stack.Stack // The stacktrace at invocation moment.
}

//
// NewChain creates a new Chain object.
//
func NewChain() *Chain {

	return &Chain{stack: stack.Get()}
}

//
// Prepend adds an error to the bottom of the chain.
//
func (c *Chain) Prepend(err error) *Chain {
	errs := make([]error, len(c.errs)+1)
	errs[0] = err
	copy(errs[1:], c.errs)
	c.errs = errs

	return c
}

//
// Append adds an error to the top of the chain.
//
func (c *Chain) Append(err error) *Chain {
	c.errs = append(c.errs, err)

	return c
}

//
// Format formats the error chain.
//
func (c *Chain) Format(state fmt.State, verb rune) {
	switch verb {
	case 'v':
		if state.Flag('+') {
			fmt.Fprintln(state, c.Error())
			c.stack.Format(state, verb)
			return
		}
		fallthrough
	default:
		if _, err := state.Write([]byte(c.Error())); err != nil {
			panic(fmt.Errorf("impossible to write error into the chain %+v", err))
		}
	}
}

//
// Error returns a compressed error message for the error chain.
//
func (c *Chain) Error() string {
	var errStr string
	if 0 == len(c.errs) {
		return ""
	}

	for i, err := range c.GetErrors() {
		if i == 0 {
			errStr = err.Error()
			continue
		}
		errStr += " : " + err.Error()
	}

	return errStr
}

//
// GetErrors returns the error chain.
//
func (c *Chain) GetErrors() []error {
	errsLen := len(c.errs)
	errs := make([]error, errsLen)
	for i := range c.errs {
		errs[i] = c.errs[errsLen-i-1]
	}

	return errs
}
