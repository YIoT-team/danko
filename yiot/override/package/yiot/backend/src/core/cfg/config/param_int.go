package config

//
// ParameterIntProvider is an interface for the Int parameter entry.
//
type ParameterIntProvider interface {
	//
	// ParameterProvider include base parameter interface.
	//
	ParameterProvider

	//
	// getValuePointer returns value link.
	//
	getValuePointer() *int

	//
	// getDefault returns a string parameter value.
	//
	getDefault() int

	//
	// getValue returns the value link for passing to the flags parsing block.
	//
	getValue() int
}

//
// IntegerParam is a integer configuration parameter.
//
type IntegerParam struct {
	value        int
	defaultValue int

	baseParam
}

//
// NewInt returns a new instance of integer parameter object.
//
func NewInt(name, usage string, defaultValue int) *IntegerParam {

	return &IntegerParam{
		defaultValue: defaultValue,
		baseParam: baseParam{
			name:      name,
			usage:     usage,
			paramType: ParameterTypeInteger,
		},
	}
}

//
// getValue returns an integer value.
//
func (p *IntegerParam) getValue() int {

	return p.value
}

//
// getDefault returns a default value.
//
func (p *IntegerParam) getDefault() int {

	return p.defaultValue
}

//
// getValuePointer returns link to the integer value.
//
func (p *IntegerParam) getValuePointer() *int {

	return &p.value
}

//
// validate validates the integer configuration parameter value not to be an empty string.
//
func (p *IntegerParam) validate() error {

	return nil
}
