package di

import (
	"yiot_api/core/cfg/di"

	"yiot_api/app/validators"
)

//
// Dependency name.
//
const (
	DefVpnValidators = "VpnValidators"
)

//
// registerVpnValidators dependency registrar.
//
func (c *Container) registerVpnValidators() error {

	return c.RegisterDependency(
		DefVpnValidators,
		func(ctx di.Context) (interface{}, error) {

			return validators.NewVpnValidator(), nil
		},
		nil,
	)
}

//
// GetVpnValidators dependency retriever.
//
func (c *Container) GetVpnValidators() *validators.VpnValidator {

	return c.Container.Get(DefVpnValidators).(*validators.VpnValidator)
}
