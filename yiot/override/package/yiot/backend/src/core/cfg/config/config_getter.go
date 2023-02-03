package config

import "time"

//
// Getter provides a base interface to access to the different configuration variables types.
//
type Getter interface {

	//
	// IsParsed returns the parsing status of Config object.
	//
	IsParsed() bool

	//
	// GetString returns the string representation of ENV parameter.
	//
	GetString(p string) string

	//
	// GetBase64String returns the base64 string representation of ENV parameter.
	//
	GetBase64String(p string) []byte

	//
	// GetBool returns the bool representation of ENV parameter.
	//
	GetBool(p string) bool

	//
	// GetInt returns the integer representation of ENV parameter.
	//
	GetInt(p string) int

	//
	// GetDuration returns the time.Duration representation of ENV parameter.
	//
	GetDuration(p string) time.Duration

	//
	// GetLogLevel returns the parsed logger configuration.
	//
	GetLogLevel(p string) string
}
