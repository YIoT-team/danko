package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
)

//
// NewRedisReadError collects Redis Cache read error metric.
//
func NewRedisReadError(serviceName string) Counter {

	c := prometheus.NewCounter(prometheus.CounterOpts{
		Name:      "redis_read_error_total",
		Namespace: serviceName,
		Help:      "Total number of the Redis Cache read errors.",
	})
	prometheus.MustRegister(c)

	return c
}

//
// NewRedisReadLatency collects Redis Cache read latency metric.
//
func NewRedisReadLatency(metricPrefix string) Histogram {

	sv := prometheus.NewHistogram(
		prometheus.HistogramOpts{
			Name:      "redis_read_latency",
			Namespace: metricPrefix,
			Help:      "Latency of the Redis Cache read operation.",
			Buckets:   []float64{.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10},
		},
	)
	prometheus.MustRegister(sv)

	return sv
}

//
// NewRedisWriteError collects Redis Cache write error metric.
//
func NewRedisWriteError(serviceName string) Counter {

	c := prometheus.NewCounter(prometheus.CounterOpts{
		Name:      "redis_write_error_total",
		Namespace: serviceName,
		Help:      "Total number of the Redis Cache write errors.",
	})
	prometheus.MustRegister(c)

	return c
}

//
// NewRedisWriteLatency collects Redis Cache write latency metric.
//
func NewRedisWriteLatency(metricPrefix string) Histogram {

	sv := prometheus.NewHistogram(
		prometheus.HistogramOpts{
			Name:      "redis_write_latency",
			Namespace: metricPrefix,
			Help:      "Latency of the Redis Cache write operation.",
			Buckets:   []float64{.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10},
		},
	)
	prometheus.MustRegister(sv)

	return sv
}
