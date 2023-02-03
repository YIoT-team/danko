package breaker

import "github.com/afex/hystrix-go/hystrix"

var (
	//
	// ErrTimeout alias for the original Hystrix ErrTimeout error.
	//
	ErrTimeout = hystrix.ErrTimeout
)

//
// CircuitError alias for the original Hystrix CircuitError type.
//
type CircuitError = hystrix.CircuitError
