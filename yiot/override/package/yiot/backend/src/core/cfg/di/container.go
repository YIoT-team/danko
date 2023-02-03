package di

import (
	"github.com/sarulabs/di"

	"yiot_api/core/errors"
)

//
// dependencyRegistrar DI registration helper.
//
type dependencyRegistrar func(ctx di.Container) (interface{}, error)

//
// dependencyDisposer DI un registration helper.
//
type dependencyDisposer func(obj interface{}) error

//
// Context just a alias to the original Context to prevent dependency from the third party of DI.
//
type Context = di.Container

//
// Container is a DI container instance.
//
type Container struct {
	ctx                      di.Container
	builder                  *di.Builder
	registeredDependencyList map[string]bool
}

//
// NewContainer returns a new container instance.
//
func NewContainer() (*Container, error) {

	builder, err := di.NewBuilder(di.App, di.Request)
	if err != nil {
		// TODO wrap into good error message.
		return nil, err
	}

	return &Container{
		registeredDependencyList: map[string]bool{},
		builder:                  builder,
	}, nil
}

//
// Build builds application dependencies.
//
func (c *Container) Build() {
	c.ctx = c.builder.Build()
}

//
// Get returns the dependency by its name.
//
func (c *Container) Get(name string) interface{} {

	if nil == c.ctx {
		panic("DI container was not built")
	}

	return c.ctx.Get(name)
}

// isDependencyRegistered makes check that dependency is already registered.
func (c *Container) isDependencyRegistered(dependencyName string) bool {

	return c.registeredDependencyList[dependencyName]
}

//
// RegisterDependency registers a dependency in DI container.
//
func (c *Container) RegisterDependency(
	depName string,
	registrar dependencyRegistrar,
	disposer dependencyDisposer,
) error {

	if !c.isDependencyRegistered(depName) {
		if err := c.builder.Add(
			di.Def{
				Name:  depName,
				Build: registrar,
				Close: disposer,
			},
		); nil != err {
			return errors.WithMessage(err, `dependency (%s) registration error`, depName)
		}

		c.registeredDependencyList[depName] = true
	}

	return nil
}
