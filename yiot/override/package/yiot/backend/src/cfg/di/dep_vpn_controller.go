package di

import (
	"yiot_api/app/controller"
	"yiot_api/core/cfg/di"
)

//
// Dependency name.
//
const (
	DefVpnController = "VpnController"
)

//
// registerVpnController dependency registrar.
//
func (c *Container) registerVpnController() error {

	return c.RegisterDependency(
		DefVpnController,
		func(ctx di.Context) (interface{}, error) {

			return controller.NewVpnServiceController(
				c.GetVpnValidators(),
			), nil
		},
		nil,
	)
}

//
// GetVpnController dependency retriever.
//
func (c *Container) GetVpnController() controller.ProviderVpn {

	return c.Container.Get(DefVpnController).(controller.ProviderVpn)
}
