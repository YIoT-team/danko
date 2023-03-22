package config

//
// ParameterBoolProvider is an interface for the Bool parameter entry.
//
type ParameterBoolProvider interface {
	//
	// ParameterProvider include base parameter interface.
	//
	ParameterProvider

	//
	// getValuePointer returns value link.
	//
	getValuePointer() *bool

	//
	// getDefault returns a string parameter value.
	//
	getDefault() bool

	//
	// getValue returns the value link for passing to the flags parsing block.
	//
	getValue() bool
}

//
// BoolParam is a boolean configuration parameter.
//
type BoolParam struct {
	value        bool
	defaultValue bool

	baseParam
}

//
// NewBool returns a new instance of boolean parameter object.
//
func NewBool(name, usage string, defaultValue bool) *BoolParam {

	return &BoolParam{
		defaultValue: defaultValue,
		baseParam: baseParam{
			name:      name,
			usage:     usage,
			paramType: ParameterTypeBool,
		},
	}
}

//
// getValue returns a boolean parameter value.
//
func (p *BoolParam) getValue() bool {

	return p.value
}

//
// getDefault returns a default value.
//
func (p *BoolParam) getDefault() bool {

	return p.defaultValue
}

//
// getValuePointer returns the link to the bool value.
//
func (p *BoolParam) getValuePointer() *bool {

	return &p.value
}

//
// validate makes validation of the bool parameter.
//
func (p *BoolParam) validate() error {

	return nil
}
