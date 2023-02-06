package config

import (
	"time"
)

//
// ParameterDurationProvider is an interface for the time.Duration parameter entry.
//
type ParameterDurationProvider interface {
	//
	// ParameterProvider include base parameter interface.
	//
	ParameterProvider

	//
	// getValuePointer returns value link.
	//
	getValuePointer() *time.Duration

	//
	// getDefault returns a string parameter value.
	//
	getDefault() time.Duration

	//
	// getValue returns the value link for passing to the flags parsing block.
	//
	getValue() time.Duration
}

//
// DurationParam is a time.Duration configuration parameter.
//
type DurationParam struct {
	value        time.Duration
	defaultValue time.Duration

	baseParam
}

//
// NewDuration returns a new instance of time.Duration parameter object.
//
func NewDuration(name, usage string, defaultValue time.Duration) *DurationParam {

	return &DurationParam{
		defaultValue: defaultValue,
		baseParam: baseParam{
			name:      name,
			usage:     usage,
			paramType: ParameterTypeDuration,
		},
	}
}

//
// getValue returns a time.Duration parameter value.
//
func (p *DurationParam) getValue() time.Duration {

	return p.value
}

//
// getDefault returns a default value.
//
func (p *DurationParam) getDefault() time.Duration {

	return p.defaultValue
}

//
// getValuePointer returns link to the time.Duration value.
//
func (p *DurationParam) getValuePointer() *time.Duration {

	return &p.value
}

//
// validate validates the time.Duration configuration parameter value not to be an empty string.
//
func (p *DurationParam) validate() error {

	return nil
}
