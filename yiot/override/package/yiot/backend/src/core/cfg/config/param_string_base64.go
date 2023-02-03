package config

import (
	"encoding/base64"

	"yiot_api/core/errors"
)

//
// ParameterBase64StringProvider is an interface for the Base64 String parameter entry.
//
type ParameterBase64StringProvider interface {
	//
	// ParameterProvider include base parameter interface.
	//
	ParameterProvider

	//
	// getValuePointer returns value link.
	//
	getValuePointer() *string

	//
	// getDefault returns a string parameter value.
	//
	getDefault() string

	//
	// getValue returns a decoded parameter value.
	//
	getValue() []byte
}

//
// Base64StringParam is a base64-encoded string configuration parameter.
//
type Base64StringParam struct {
	value        string
	defaultValue string
	decodedValue []byte

	baseParam
}

//
// NewBase64String returns a new instance of base64 string parameter object.
//
func NewBase64String(name, usage string, defaultValue string) *Base64StringParam {

	return &Base64StringParam{
		defaultValue: defaultValue,
		baseParam: baseParam{
			name:      name,
			usage:     usage,
			paramType: ParameterTypeBase64String,
		},
	}
}

//
// getDefault returns a default value.
//
func (p *Base64StringParam) getDefault() string {

	return p.defaultValue
}

//
// getValuePointer returns the link to the base64 string value.
//
func (p *Base64StringParam) getValuePointer() *string {

	return &p.value
}

//
// GetDecodedValue returns a decoded value.
//
func (p *Base64StringParam) getValue() []byte {

	return p.decodedValue
}

//
// validate makes validation of the base64 string parameter.
//
func (p *Base64StringParam) validate() error {

	decodedValue, err := base64.StdEncoding.DecodeString(p.value)
	if err != nil {
		return errors.WithMessage(err, "config parameter (%s) has wrong base64 encoding", p.getName())
	}

	p.decodedValue = decodedValue

	return nil
}
