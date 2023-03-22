package config

import (
	"time"

	"github.com/namsral/flag"
)

//
// Config object provides an access for all the application configuration parameters.
//
type Config struct {
	isParsed   bool
	parameters map[string]ParameterProvider
}

//
// New returns an instance of Config object
//
func New() *Config {

	return &Config{
		isParsed:   false,
		parameters: make(map[string]ParameterProvider),
	}
}

//
// RegisterParameters registers a predefined configuration parameter for the application.
//
func (c *Config) RegisterParameters(parameterList ...ParameterProvider) {

	for _, p := range parameterList {
		c.parameters[p.getName()] = p
	}
}

//
// Parse parses registered configuration parameters.
//
func (c *Config) Parse() error {

	if c.isParsed {
		return nil
	}

	for _, parameter := range c.parameters {
		switch parameter.getType() {
		case ParameterTypeString:
			flag.StringVar(
				parameter.(ParameterStringProvider).getValuePointer(),
				parameter.getName(),
				parameter.(ParameterStringProvider).getDefault(),
				parameter.getUsage(),
			)
		case ParameterTypeBase64String:
			flag.StringVar(
				parameter.(ParameterBase64StringProvider).getValuePointer(),
				parameter.getName(),
				parameter.(ParameterBase64StringProvider).getDefault(),
				parameter.getUsage(),
			)
		case ParameterTypeInteger:
			flag.IntVar(
				parameter.(ParameterIntProvider).getValuePointer(),
				parameter.getName(),
				parameter.(ParameterIntProvider).getDefault(),
				parameter.getUsage(),
			)
		case ParameterTypeBool:
			flag.BoolVar(
				parameter.(ParameterBoolProvider).getValuePointer(),
				parameter.getName(),
				parameter.(ParameterBoolProvider).getDefault(),
				parameter.getUsage(),
			)
		case ParameterTypeDuration:
			flag.DurationVar(
				parameter.(ParameterDurationProvider).getValuePointer(),
				parameter.getName(),
				parameter.(ParameterDurationProvider).getDefault(),
				parameter.getUsage(),
			)
		case ParameterTypeLogger:
			flag.StringVar(
				parameter.(ParameterLoggerProvider).getValuePointer(),
				parameter.getName(),
				parameter.(ParameterLoggerProvider).getDefault(),
				parameter.getUsage(),
			)
		}
	}

	flag.Parse()

	c.isParsed = true

	// Validate parsed parameter list.
	for _, parameter := range c.parameters {
		if err := parameter.validate(); err != nil {
			return err
		}
	}

	return nil
}

//
// IsParsed returns the parsing status of Config object.
//
func (c *Config) IsParsed() bool {

	return c.isParsed
}

//
// GetString returns the string representation of ENV parameter.
//
func (c *Config) GetString(p string) string {

	return c.parameters[p].(ParameterStringProvider).getValue()
}

//
// GetBase64String returns the base64 string representation of ENV parameter.
//
func (c *Config) GetBase64String(p string) []byte {

	return c.parameters[p].(ParameterBase64StringProvider).getValue()
}

//
// GetBool returns the bool representation of ENV parameter.
//
func (c *Config) GetBool(p string) bool {

	return c.parameters[p].(ParameterBoolProvider).getValue()
}

//
// GetInt returns the integer representation of ENV parameter.
//
func (c *Config) GetInt(p string) int {

	return c.parameters[p].(ParameterIntProvider).getValue()
}

//
// GetDuration returns the time.Duration representation of ENV parameter.
//
func (c *Config) GetDuration(p string) time.Duration {

	return c.parameters[p].(ParameterDurationProvider).getValue()
}

//
// GetLogLevel returns the parsed logger configuration.
//
func (c *Config) GetLogLevel(p string) string {

	return c.parameters[p].(ParameterLoggerProvider).getLevel()
}
