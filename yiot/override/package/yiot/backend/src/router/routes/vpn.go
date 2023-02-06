package routes

import (
	"net/http"

	kitHTTP "yiot_api/core/http"
	"yiot_api/core/http/response"

	"yiot_api/transport"
)

const (

	//
	// RoutePrefix base VPN service routing prefix.
	//
	VpnRoutePrefix = RoutePrefixDefault + ServicesPrefix + "/vpn"

	//
	// RouteVpnStartPost POST /vpn/start route.
	//
	RouteVpnStartPost = VpnRoutePrefix + "/start"

	//
	// RouteVpnStopDelete DELETE /vpn/stop route.
	//
	RouteVpnStopDelete = VpnRoutePrefix + "/stop"

	//
	// RouteVpnInfoGet GET /vpn/info route.
	//
	RouteVpnInfoGet = VpnRoutePrefix + "/info"

	//
	// RouteVpnConfigGet GET /vpn/config route.
	//
	RouteVpnConfigGet = VpnRoutePrefix + "/config"

	//
	// RouteVpnConfigPost POST /vpn/config route.
	//
	RouteVpnConfigPost = VpnRoutePrefix + "/config"
)

const (
	StartVpnActionID = 400 + iota
	StopVpnActionID
	InfoVpnActionID
	VpnConfigGetActionID
	VpnConfigSetActionID
)

//
// InitVpnRouteList makes an initialization of VPN routes.
//
func InitVpnRouteList(r kitHTTP.RouterProvider, h *transport.VpnHandler) {
	r.Post(RouteVpnStartPost, kitHTTP.SetServiceActionID(StartVpnActionID, func(req *http.Request) (response.Provider, error) {
		return h.VpnStart(req)
	}))

	r.Delete(RouteVpnStopDelete, kitHTTP.SetServiceActionID(StopVpnActionID, func(req *http.Request) (response.Provider, error) {
		return h.VpnStop(req)
	}))

	r.Get(RouteVpnInfoGet, kitHTTP.SetServiceActionID(InfoVpnActionID, func(req *http.Request) (response.Provider, error) {
		return h.VpnInfo(req)
	}))

	r.Get(RouteVpnConfigGet, kitHTTP.SetServiceActionID(VpnConfigGetActionID, func(req *http.Request) (response.Provider, error) {
		return h.VpnGetConfig(req)
	}))

	r.Post(RouteVpnConfigPost, kitHTTP.SetServiceActionID(VpnConfigSetActionID, func(req *http.Request) (response.Provider, error) {
		return h.VpnSetConfig(req)
	}))
}
