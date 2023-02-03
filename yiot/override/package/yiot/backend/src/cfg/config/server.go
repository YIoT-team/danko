package config

import "time"

//
// GetServerHTTPAddress returns an HTTP Server address.
//
func (c *Config) GetServerHTTPAddress() string {

	return c.config.GetString(ConfServerHTTPAddress)
}

//
// GetServerReadTimeout returns an HTTP Server Read timeout.
//
func (c *Config) GetServerReadTimeout() time.Duration {

	return c.config.GetDuration(ConfServerReadTimeout)
}

//
// GetServerWriteTimeout returns an HTTP Server Write timeout.
//
func (c *Config) GetServerWriteTimeout() time.Duration {

	return c.config.GetDuration(ConfServerWriteTimeout)
}
