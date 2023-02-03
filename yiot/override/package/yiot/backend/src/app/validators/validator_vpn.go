package validators

import (
	"yiot_api/api"
)

const (
	subnetRange = 24
)

//
// VpnValidator performs Vpn Service request validations.
//
type VpnValidator struct {
}

//
// New returns an instance of the VPN validators.
//
func NewVpnValidator() *VpnValidator {

	return &VpnValidator{}
}

//
// ValidateStartRequest performs a validation of the Vpn Start request object.
//
func (v *VpnValidator) ValidateStartRequest(
	req *api.VpnAddRequest,
) error {

	// Validate user
	err := ValidateUser(req.User)
	if err != nil {
		return err
	}

	// Validate Base64 Password
	pwd, err := ValidateBase64(req.Password)
	if err != nil {
		return err
	}

	// Validate Password
	err = ValidateBCrypt(pwd)
	if err != nil {
		return err
	}

	// Validate Subnet
	err = ValidateIPv4Subnet(req.Subnet, subnetRange, subnetRange)
	if err != nil {
		return err
	}

	// Validate Full Name
	if req.FullName != "" {
		err = ValidateFullName(req.FullName)
		if err != nil {
			return err
		}
	}

	// Validate Email
	if req.Email != "" {
		err = ValidateEmail(req.Email)
		if err != nil {
			return err
		}
	}

	return nil
}

//
// ValidateStopRequest performs a validation of the Vpn Stop request object.
//
func (v *VpnValidator) ValidateStopRequest(
	req *api.VpnRemoveRequest,
) error {
	return nil
}

//
// ValidateSetConfigRequest performs a validation of the Vpn Set Configuration request object.
//
func (v *VpnValidator) ValidateSetConfigRequest(
	req *api.VpnSetConfigRequest,
) error {
	return nil
}
