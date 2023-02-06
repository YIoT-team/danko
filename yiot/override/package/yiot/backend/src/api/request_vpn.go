package api

// ----------------------------------------------------------------------------
//
// Create VPN Service Request message.
//
type VpnAddRequest struct {
	*Headers
	User                 string `json:"user,omitempty"`
	Password             string `json:"password,omitempty"`
	Email                string `json:"email,omitempty"`
	FullName             string `json:"name,omitempty"`
	Subnet               string `json:"subnet,omitempty"`
	InitialConfiguration string `json:"config,omitempty"`
}

// ----------------------------------------------------------------------------
//
// Remove VPN Service Request message.
//
type VpnRemoveRequest struct {
	*Headers
}

// ----------------------------------------------------------------------------
//
// Set Config for VPN Service Request message.
//
type VpnSetConfigRequest struct {
	*Headers
}

// ----------------------------------------------------------------------------
