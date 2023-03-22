package http

//
// RequestContextKey is a custom request context key type.
//
type RequestContextKey int

//
// Request context keys used in request context.
//
const (
	RequestContextAccountID RequestContextKey = iota
	RequestContextApplicationID
)
