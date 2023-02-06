package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
)

//
// Counter prometheus types aliases.
//
type Counter prometheus.Counter

//
// Summary prometheus types aliases.
//
type Summary prometheus.Summary

//
// Histogram prometheus types aliases.
//
type Histogram prometheus.Histogram

//
// CounterVec interface to work with the Counter metrics type.
//
type CounterVec interface {
	WithLabelValues(lvs ...string) prometheus.Counter
}

//
// SummaryVec interface to work with the Summary metrics type.
//
type SummaryVec interface {
	WithLabelValues(lvs ...string) prometheus.Observer
}

//
// HistogramVec interface to work with the Histogram metrics type.
//
type HistogramVec interface {
	WithLabelValues(lvs ...string) prometheus.Observer
}
