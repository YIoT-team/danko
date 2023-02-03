package breaker

import (
	"github.com/afex/hystrix-go/hystrix"
)

var (
	//
	// Do the function alias to the original Hystrix Do function.
	//
	Do = hystrix.Do

	//
	// GetCircuitSettings the function alias to the original Hystrix GetCircuitSettings function.
	//
	GetCircuitSettings = hystrix.GetCircuitSettings
)

//
// Settings is type alias for hystrix.Settings.
//
type Settings = hystrix.Settings

// HystrixBreaker represents the Hystrix breaker wrapper.
type HystrixBreaker struct {
	registeredCommandList map[string]bool
}

// Init makes an initialization of all Hystrix commands.
func Init(commandConfigList CommandConfigList) {

	breaker := HystrixBreaker{
		registeredCommandList: make(map[string]bool),
	}

	for command, config := range commandConfigList {
		if !breaker.isCommandRegistered(command) {
			hystrix.ConfigureCommand(command, config)

			breaker.registeredCommandList[command] = true
		}
	}
}

//
// IsCommandRegistered makes check that Hystrix command already registered.
//
func (c *HystrixBreaker) isCommandRegistered(command string) bool {

	return c.registeredCommandList[command]
}
