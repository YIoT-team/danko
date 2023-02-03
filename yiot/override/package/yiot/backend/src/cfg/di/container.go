package di

import (
	"yiot_api/core/cfg/di"
	"yiot_api/core/errors"
	"yiot_api/core/log"

	"yiot_api/cfg/config"
)

//
// Container is a dependency resolver object.
//
type Container struct {
	logger log.Logger
	config *config.Config
	*di.Container
}

//
// NewContainer returns an instance of the DI DIContainer.
//
func NewContainer(c *config.Config, l log.Logger) (*Container, error) {

	container, err := di.NewContainer()
	if err != nil {
		return nil, errors.WithMessage(err, `di container instantiating error`)
	}

	return &Container{
		config:    c,
		logger:    l,
		Container: container,
	}, nil
}

//
// Build builds the application dependencies at once.
//
func (c *Container) Build() error {

	for _, dep := range []func() error{
		c.registerHTTPRouter,
		c.registerLogger,

		c.registerVpnHandler,
		c.registerVpnController,
		c.registerVpnValidators,
	} {
		if err := dep(); err != nil {
			return err
		}
	}

	c.Container.Build()

	return nil
}
