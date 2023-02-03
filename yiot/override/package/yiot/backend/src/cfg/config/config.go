package config

import (
	"time"

	"yiot_api/core/cfg/config"
)

//
// Configuration parameter names.
//
const (
	ConfKubernetes                  = "YIOT_K8S"
	ConfPostgreSQL                  = "YIOT_POSTGRESQL"
	ConfServerHTTPAddress           = "YIOT_SERVER_ADDRESS"
	ConfServerReadTimeout           = "YIOT_SERVER_READ_TIMEOUT"
	ConfServerWriteTimeout          = "YIOT_SERVER_WRITE_TIMEOUT"
	ConfDiscordToken                = "YIOT_DISCORD_TOKEN"
	ConfDiscordChannel              = "YIOT_DISCORD_CHANNEL"
	ConfLogLevel                    = "YIOT_LOG_LEVEL"
	ConfNodePortIP                  = "YIOT_NODE_PORT_IP"
	ConfTracerDisabled              = "YIOT_TRACER_DISABLED"
	ConfTracerAgentAddress          = "YIOT_TRACER_AGENT_ADDRESS"
	ConfTracerSamplerType           = "YIOT_TRACER_SAMPLER_TYPE"
	ConfTracerSamplerParam          = "YIOT_TRACER_SAMPLER_PARAM"
	ConfTracerSamplerManagerAddress = "YIOT_TRACER_SAMPLER_MANAGER_ADDRESS"
)

//
// General constants.
//
const (
	MetricPrefix = "yiot_api"

	ServiceName = "yiot-api"
)

//
// Config is an application config object.
//
type Config struct {
	config *config.Config
}

//
// New returns a new Config instance.
//
func New() (*Config, error) {

	c := config.New()
	c.RegisterParameters(
		config.NewString(
			ConfServerHTTPAddress,
			"HTTP server address for binding.",
			":8080",
		),
		config.NewDuration(
			ConfServerReadTimeout,
			"HTTP server read timeout.",
			90*time.Second,
		),
		config.NewDuration(
			ConfServerWriteTimeout,
			"HTTP server write timeout.",
			90*time.Second,
		),

		config.NewLoggerLevel(
			ConfLogLevel,
			"Logging level",
		),

		config.NewString(
			ConfDiscordToken,
			"Discord Bot token string.",
			"",
		),

		config.NewString(
			ConfDiscordChannel,
			"Discord Bot channel ID.",
			"",
		),

		config.NewString(
			ConfNodePortIP,
			"NodePort IP address.",
			"127.0.0.1",
		),

		config.NewBool(
			ConfTracerDisabled,
			"Enable/Disable request tracing..",
			true,
		),

		config.NewString(
			ConfTracerAgentAddress,
			"Address where tracer agent is listening on.",
			"",
		),

		config.NewString(
			ConfTracerSamplerType,
			"Sampler type. Allowed values are: remote, const, probabilistic, rateLimiting.",
			"probabilistic",
		),

		config.NewString(
			ConfTracerSamplerManagerAddress,
			"Address of remote sampler manager.",
			"",
		),
	)

	if err := c.Parse(); nil != err {
		return nil, err
	}

	return &Config{
		config: c,
	}, nil
}
