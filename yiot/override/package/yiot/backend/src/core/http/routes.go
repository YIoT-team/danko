package http

const (
	//
	// RouteServiceInfo service info route.
	//
	RouteServiceInfo = "/_service/info"

	//
	// RouteServiceMetrics service metrics route.
	//
	RouteServiceMetrics = "/_service/metrics"

	//
	// RouteServiceStatus health status route.
	//
	RouteServiceStatus = "/_service/status"

	//
	// RouteServiceDebug pprof /_service/debug route.
	//
	RouteServiceDebug = "/_service/debug{/resource:.*}"
)
