package config

//
// GetLogLevel returns a log level value.
//
func (c *Config) GetLogLevel() string {

	return c.config.GetLogLevel(ConfLogLevel)
}
