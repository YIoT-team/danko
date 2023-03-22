package config

//
// ParameterProvider is an interface for the String parameter entry.
//
type ParameterProvider interface {
	//
	// getType returns a parameter type.
	//
	getType() ParameterType

	//
	// getUsage returns a parameter usage information.
	//
	getUsage() string

	//
	// getName returns a configuration parameter name.
	//
	getName() string

	//
	// validate makes validation of a parameter.
	//
	validate() error
}

//
// baseParam is a base parameter object.
//
type baseParam struct {
	name      string
	usage     string
	paramType ParameterType
}

//
// getType returns a parameter type.
//
func (p baseParam) getType() ParameterType {

	return p.paramType
}

//
// getUsage returns a parameter usage information.
//
func (p baseParam) getUsage() string {

	return p.usage
}

//
// getName returns a configuration parameter name.
//
func (p *baseParam) getName() string {

	return p.name
}
