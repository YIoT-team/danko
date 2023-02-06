package controller

import (
	"yiot_api/api"
	"yiot_api/app/validators"
)

var (
	serviceName  = "vpn"
	vpnHealthUri = "/_health"
)

//
// ProviderVpn of an interface to work with VPN controller.
//
type ProviderVpn interface {
	//
	// VpnStart handles POST /api/v1/services/vpn/start endpoint.
	//
	VpnStart(request *api.VpnAddRequest) (*api.VpnAddResponse, error)

	//
	// VpnStop handles DELETE /api/v1/services/vpn/stop endpoint.
	//
	VpnStop(request *api.VpnRemoveRequest) error

	//
	// VpnInfo handles GET /api/v1/services/vpn/info endpoint.
	//
	VpnInfo(request *api.YIoTBaseRequest) (*api.VpnGetInfoResponse, error)

	//
	// VpnGetConfig handles GET /api/v1/services/vpn/config endpoint.
	//
	VpnGetConfig(request *api.YIoTBaseRequest) (*api.VpnGetConfigResponse, error)

	//
	// VpnSetConfig handles POST /api/v1/services/vpn/config endpoint.
	//
	VpnSetConfig(request *api.VpnSetConfigRequest) error
}

//
// Controller serves the VPN requests.
//
type ControllerVpn struct {
	validator *validators.VpnValidator
}

//
// New returns an instance of the VPN controller.
//
func NewVpnServiceController(
	validator *validators.VpnValidator,
) *ControllerVpn {

	return &ControllerVpn{
		validator: validator,
	}
}

//
// VpnStart handles POST /api/v1/services/vpn/start endpoint.
//
func (h *ControllerVpn) VpnStart(request *api.VpnAddRequest) (*api.VpnAddResponse, error) {

	// Validate request
	err := h.validator.ValidateStartRequest(request)
	if err != nil {
		return nil, err
	}

	// Prepare response
	resp := new(api.VpnAddResponse)
	resp.Status = "VPN Service created"
	resp.Url = ""
	resp.HealthCheck = vpnHealthUri
	resp.VpnEndpoint = ""

	return resp, nil
}

//
// VpnStop handles DELETE /api/v1/services/vpn/stop endpoint.
//
func (h *ControllerVpn) VpnStop(request *api.VpnRemoveRequest) error {
	return nil
}

//
// VpnInfo handles GET /api/v1/services/vpn/info endpoint.
//
func (h *ControllerVpn) VpnInfo(request *api.YIoTBaseRequest) (*api.VpnGetInfoResponse, error) {

	info := new(api.VpnGetInfoResponse)
	info.Status = "disabled"
	info.Url = ""
	info.HealthCheck = vpnHealthUri
	info.VpnEndpoint = ""

	return info, nil
}

//
// VpnGetConfig handles GET /api/v1/services/vpn/config endpoint.
//
func (h *ControllerVpn) VpnGetConfig(request *api.YIoTBaseRequest) (*api.VpnGetConfigResponse, error) {
	return nil, api.ErrNotImplementedError
}

//
// VpnSetConfig handles POST /api/v1/services/vpn/config endpoint.
//
func (h *ControllerVpn) VpnSetConfig(request *api.VpnSetConfigRequest) error {
	return api.ErrNotImplementedError
}
