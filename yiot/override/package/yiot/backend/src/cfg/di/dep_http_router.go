package di

import (
	"yiot_api/core/cfg/di"
	"yiot_api/core/http"
	"yiot_api/router/routes"
)

//
// Dependency name.
//
const (
	DefHTTPRouter = "HTTPRouter"
)

//
// registerHTTPRouter dependency registrar.
//
func (c *Container) registerHTTPRouter() error {

	return c.RegisterDependency(
		DefHTTPRouter,
		func(ctx di.Context) (interface{}, error) {

			r := http.NewRouter(
				c.GetLogger(),
				c.GetConfig().GetMetricPrefix(),
				http.SetupHealthDependencyList(),
			)

			// Service: VPN endpoints
			routes.InitVpnRouteList( /*c.GetTracer(),*/ r, c.GetVpnHandler())

			return r, nil

		}, nil,
	)
}

//
// GetHTTPRouter dependency retriever.
//
func (c *Container) GetHTTPRouter() http.RouterProvider {

	return c.Container.Get(DefHTTPRouter).(http.RouterProvider)
}
