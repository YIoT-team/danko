package di

import (
	"yiot_api/core/cfg/di"
	"yiot_api/transport"
)

//
// Dependency name.
//
const (
	DefVpnHandler = "VpnHandler"
)

//
// registeVpnHandler dependency registrar.
//
func (c *Container) registerVpnHandler() error {

	return c.RegisterDependency(
		DefVpnHandler,
		func(ctx di.Context) (interface{}, error) {

			return transport.NewVpnHandler(
				c.GetVpnController(),
			), nil
		},
		nil,
	)
}

//
// GetVpnHandler dependency retriever.
//
func (c *Container) GetVpnHandler() *transport.VpnHandler {

	return c.Container.Get(DefVpnHandler).(*transport.VpnHandler)
}
