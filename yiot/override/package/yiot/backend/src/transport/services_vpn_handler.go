package transport

import (
	"net/http"

	"yiot_api/api"
	"yiot_api/app/controller"
	"yiot_api/core/http/response"
)

//
// VpnHandler provides an abstraction on transport layer.
//
type VpnHandler struct {
	vpnController controller.ProviderVpn
}

//
// NewVpnHandler return VPN handler instance.
//
func NewVpnHandler(vpnController controller.ProviderVpn) *VpnHandler {

	return &VpnHandler{
		vpnController: vpnController,
	}
}

//
// VpnStart handles POST /api/v1/services/vpn/start endpoint.
//
func (h *VpnHandler) VpnStart(req *http.Request) (response.Provider, error) {
	headers, err := NewHeaders(req)
	if err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	request := api.VpnAddRequest{
		Headers: headers,
	}

	if err := unmarshal(req.Body, &request); err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	info, err := h.vpnController.VpnStart(&request)
	if err != nil {
		return response.NewResponse(nil, http.StatusNotFound), err
	}

	resp := response.NewResponse(info, http.StatusOK)

	return resp, nil
}

//
// VpnStop handles DELETE /api/v1/services/vpn/stop endpoint.
//
func (h *VpnHandler) VpnStop(req *http.Request) (response.Provider, error) {
	headers, err := NewHeaders(req)
	if err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	request := api.VpnRemoveRequest{
		Headers: headers,
	}

	if err := unmarshal(req.Body, &request); err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	err = h.vpnController.VpnStop(&request)
	if err != nil {
		return response.NewResponse(nil, http.StatusNotFound), err
	}

	resp := response.NewResponse(nil, http.StatusOK)

	return resp, nil
}

//
// VpnInfo handles GET /api/v1/services/vpn/info endpoint.
//
func (h *VpnHandler) VpnInfo(req *http.Request) (response.Provider, error) {
	request, err := NewGetRequest(req)
	if err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	info, err := h.vpnController.VpnInfo(request)
	if err != nil {
		return response.NewResponse(nil, http.StatusNotFound), err
	}

	resp := response.NewResponse(info, http.StatusOK)

	return resp, nil
}

//
// VpnGetConfig handles GET /api/v1/services/vpn/config endpoint.
//
func (h *VpnHandler) VpnGetConfig(req *http.Request) (response.Provider, error) {
	request, err := NewGetRequest(req)
	if err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	config, err := h.vpnController.VpnGetConfig(request)
	if err != nil {
		return response.NewResponse(nil, http.StatusNotFound), err
	}

	resp := response.NewResponse(config, http.StatusOK)

	return resp, nil
}

//
// VpnSetConfig handles POST /api/v1/services/vpn/config endpoint.
//
func (h *VpnHandler) VpnSetConfig(req *http.Request) (response.Provider, error) {
	headers, err := NewHeaders(req)
	if err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	request := api.VpnSetConfigRequest{
		Headers: headers,
	}

	if err := unmarshal(req.Body, &request); err != nil {
		return response.NewResponse(nil, http.StatusInternalServerError), err
	}

	err = h.vpnController.VpnSetConfig(&request)
	if err != nil {
		return response.NewResponse(nil, http.StatusNotFound), err
	}

	resp := response.NewResponse(nil, http.StatusOK)

	return resp, nil
}
