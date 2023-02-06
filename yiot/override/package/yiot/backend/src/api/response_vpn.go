package api

// ----------------------------------------------------------------------------
//
// Create VPN Service Response message.
//
type VpnAddResponse struct {
	Status      string `json:"status,omitempty"`
	Url         string `json:"url,omitempty"`
	HealthCheck string `json:"health,omitempty"`
	VpnEndpoint string `json:"endpoint,omitempty"`
}

// ----------------------------------------------------------------------------
//
// Get Config for VPN Service Response message.
//
type VpnGetConfigResponse struct {
	Status string `json:"status,omitempty"`
}

// ----------------------------------------------------------------------------
//
// Get Info for VPN Service Response message.
//
type VpnGetInfoResponse struct {
	Status      string `json:"status,omitempty"`
	Url         string `json:"url,omitempty"`
	HealthCheck string `json:"health,omitempty"`
	VpnEndpoint string `json:"endpoint,omitempty"`
}

// ----------------------------------------------------------------------------
