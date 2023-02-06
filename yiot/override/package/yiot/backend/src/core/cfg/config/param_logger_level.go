package config

import (
	"strings"

	"yiot_api/core/errors"
	"yiot_api/core/log"
)

//
// ParameterLoggerProvider is an interface for the logger parameter entry.
//
type ParameterLoggerProvider interface {

	//
	// ParameterProvider include base parameter interface.
	//
	ParameterProvider

	//
	// getLevel returns log level setting.
	//
	getLevel() string

	//
	// getValuePointer returns value link.
	//
	getValuePointer() *string

	//
	// getDefault returns a string parameter value.
	//
	getDefault() string
}

const (
	//
	// DefaultLogLevel default logger level - ERROR.
	//
	DefaultLogLevel = log.LevelError
)

//
// LoggerLevelParam is a log config parameter.
//
type LoggerLevelParam struct {
	level        string
	defaultValue string

	baseParam
}

//
// NewLoggerLevel returns a new instance of logger parameter object.
//
func NewLoggerLevel(name, usage string) *LoggerLevelParam {

	return &LoggerLevelParam{
		defaultValue: DefaultLogLevel,
		baseParam: baseParam{
			name:      name,
			usage:     usage,
			paramType: ParameterTypeLogger,
		},
	}
}

//
// getLevel returns log level setting.
//
func (p *LoggerLevelParam) getLevel() string {

	return strings.ToUpper(p.level)
}

//
// getValuePointer returns value link.
//
func (p *LoggerLevelParam) getValuePointer() *string {

	return &p.level
}

//
// getDefault returns default value.
//
func (p *LoggerLevelParam) getDefault() string {

	return p.defaultValue
}

//
// validate validates the URL config parameter.
//
func (p *LoggerLevelParam) validate() error {

	level := p.getLevel()
	if "" == level {
		return errors.New("log level (%s) is empty", p.getName())
	}

	if _, ok := log.LevelList[level]; ok {
		return nil
	}

	return errors.New(`log level (%s) is invalid (%s)`, p.getName(), level)
}
