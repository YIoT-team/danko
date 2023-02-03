package config

//
// ConfigerRegistrar provides a base interface to register configuration parameters.
//
type ConfigerRegistrar interface {
	//
	// RegisterParameters registers a predefined configuration parameter for the application.
	//
	RegisterParameters(ParameterProvider)

	//
	// Parse parses registered configuration parameters.
	//
	Parse() error
}
