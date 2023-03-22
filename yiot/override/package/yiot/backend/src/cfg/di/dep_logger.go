package di

import (
	"os"

	"yiot_api/core/cfg/di"
	"yiot_api/core/log"
)

//
// Dependency name.
//
const (
	DefLogger = "Logger"
)

//
// registerLogger dependency registrar.
//
func (c *Container) registerLogger() error {

	return c.RegisterDependency(
		DefLogger,
		func(ctx di.Context) (interface{}, error) {

			return log.New(os.Stdout, c.config.GetLogLevel()), nil
		},
		nil,
	)
}

//
// GetLogger dependency retriever.
//
func (c *Container) GetLogger() log.Logger {

	return c.Container.Get(DefLogger).(log.Logger)
}
