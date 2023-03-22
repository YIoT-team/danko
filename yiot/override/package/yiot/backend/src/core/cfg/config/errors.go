package config

import (
	"yiot_api/core/errors"
)

//
// Cassandra errors.
//
var (
	ErrCassandraConnectionStringIsEmpty     = errors.New("cassandra connection string is empty")
	ErrCassandraConnectionStringIsIncorrect = errors.New("cassandra connection string is incorrect")
	ErrCassandraSchemeIsIncorrect           = errors.New("cassandra connection protocol is incorrect")
	ErrCassandraHostsAreEmpty               = errors.New("cassandra hosts are empty")
	ErrCassandraKeyspaceIsEmpty             = errors.New("cassandra cassandraKeyspace is empty")
	ErrCassandraPasswordIsEmpty             = errors.New("cassandra password cannot be empty if username was set")
)

//
// Redis errors.
//
var (
	ErrRedisConnectionStringIsEmpty     = errors.New("redis connection string is empty")
	ErrRedisConnectionStringIsIncorrect = errors.New("redis connection string is incorrect")
	ErrRedisProtocolIsIncorrect         = errors.New("redis connection protocol is incorrect")
	ErrRedisHostIsEmpty                 = errors.New("redis host is empty")
	ErrRedisPortIsEmpty                 = errors.New("redis port is empty")
)

//
// PostgreSQL errors.
//
var (
	ErrPostgreSQLConnectionStringIsEmpty     = errors.New("postgresql connection string is empty")
	ErrPostgreSQLConnectionStringIsIncorrect = errors.New("postgresql connection string is incorrect")
)

//
// Kubernetes errors.
//
var (
	ErrKubernetesConfigStringIsEmpty     = errors.New("k8s connection string is empty")
	ErrKubernetesConfigStringIsIncorrect = errors.New("k8s connection string is incorrect")
)
