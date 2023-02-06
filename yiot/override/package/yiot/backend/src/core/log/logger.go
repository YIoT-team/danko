package log

//
// Logger provides an interface to work with the Log object.
//
type Logger interface {

	//
	// Error logs a message with error severity.
	//
	Error(format string, args ...interface{})

	//
	// Debug logs a message with debug severity.
	//
	Debug(format string, args ...interface{})

	//
	// Info logs a message with info severity.
	//
	Info(format string, args ...interface{})

	//
	// Health logs a message with health severity.
	//
	Health(format string, args ...interface{})

	//
	// Print logs a message with print severity.
	//
	Print(format string, args ...interface{})

	//
	// GetLogLevel returns the current Log Level.
	//
	GetLogLevel() string
}
