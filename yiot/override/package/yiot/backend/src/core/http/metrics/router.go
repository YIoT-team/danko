package metrics

import "github.com/prometheus/client_golang/prometheus"

//
// NewServiceUnhandledError collects service unhandled errors.
//
func NewServiceUnhandledError(metricPrefix string) Counter {

	c := prometheus.NewCounter(prometheus.CounterOpts{
		Name:      "service_unhandled_error_total",
		Namespace: metricPrefix,
		Help:      "Total number of service unhandled errors (HTTP 500).",
	})
	prometheus.MustRegister(c)

	return c
}

//
// NewServiceRequestLatency collects service request latency.
//
func NewServiceRequestLatency(metricPrefix string) HistogramVec {

	sv := prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:      "service_request_latency",
			Namespace: metricPrefix,
			Help:      "Latency of the service requests.",
			Buckets:   []float64{.005, .01, .025, .05, .1, .25, .5, 1, 2.5, 5, 10},
		},
		[]string{"method", "url"},
	)
	prometheus.MustRegister(sv)

	return sv
}

//
// NewServiceResponseStatus collects service response by response status.
//
func NewServiceResponseStatus(metricPrefix string) CounterVec {

	cv := prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name:      "service_response_status_total",
			Namespace: metricPrefix,
			Help:      "Total number of the service response statuses.",
		},
		[]string{"method", "url", "status_code"},
	)
	prometheus.MustRegister(cv)

	return cv
}
