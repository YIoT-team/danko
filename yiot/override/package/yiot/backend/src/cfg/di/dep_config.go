package di

import "yiot_api/cfg/config"

//
// GetConfig dependency retriever.
//
func (c *Container) GetConfig() *config.Config {

	return c.config
}
