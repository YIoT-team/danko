package config

//
// ParameterStringProvider is an interface for the string parameter type.
//
type ParameterStringProvider interface {
	//
	// ParameterProvider include base parameter interface.
	//
	ParameterProvider

	//
	// getValuePointer returns link to the string value.
	//
	getValuePointer() *string

	//
	// getDefault returns a string parameter value.
	//
	getDefault() string

	//
	// getValue returns a string parameter value.
	//
	getValue() string
}

//
// StringParam is a string configuration parameter.
//
type StringParam struct {
	value        string
	defaultValue string

	baseParam
}

//
// NewString returns a new instance of string parameter object.
//
func NewString(name, usage string, defaultValue string) *StringParam {

	return &StringParam{
		defaultValue: defaultValue,
		baseParam: baseParam{
			name:      name,
			usage:     usage,
			paramType: ParameterTypeString,
		},
	}
}

//
// getValue returns a string parameter value.
//
func (p *StringParam) getValue() string {

	return p.value
}

//
// getDefault returns a default value.
//
func (p *StringParam) getDefault() string {

	return p.defaultValue
}

//
// getValuePointer returns link to the string value.
//
func (p *StringParam) getValuePointer() *string {

	return &p.value
}

//
// validate makes validation of the string parameter.
//
func (p *StringParam) validate() error {

	return nil
}
