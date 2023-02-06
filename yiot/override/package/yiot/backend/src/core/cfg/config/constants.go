package config

//
// ParameterType configuration parameter type.
//
type ParameterType string

const (
	//
	// ParameterTypeString config parameter with "string" type.
	//
	ParameterTypeString ParameterType = "string"

	//
	// ParameterTypeBase64String config parameter with "base64" type.
	//
	ParameterTypeBase64String ParameterType = "base64string"

	//
	// ParameterTypeDuration config parameter with "duration" type.
	//
	ParameterTypeDuration ParameterType = "duration"

	//
	// ParameterTypeInteger config parameter with "integer" type.
	//
	ParameterTypeInteger ParameterType = "integer"

	//
	// ParameterTypeBool config parameter with "bool" type.
	//
	ParameterTypeBool ParameterType = "bool"

	//
	// ParameterTypeLogger config parameter with "logger" type.
	//
	ParameterTypeLogger ParameterType = "logger"
)
