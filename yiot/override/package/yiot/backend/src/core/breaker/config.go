package breaker

import "github.com/afex/hystrix-go/hystrix"

//
// CommandConfig Hystrix Command config type alias.
//
type CommandConfig = hystrix.CommandConfig

//
// CommandConfigList the list of Hystrix configuration.
//
type CommandConfigList = map[string]CommandConfig
