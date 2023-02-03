package controller

import (
	"encoding/base64"
	"strings"
	"yiot_api/api"
)

//
// ParseVpnIp gets IP address in virtual private network from WireGuard configuration
//
func ParseVpnIp(vpnConfig string) (string, error) {

	decodedValue, err := base64.StdEncoding.DecodeString(vpnConfig)
	if err != nil {
		return "", api.ErrBase64Param
	}

	config := string(decodedValue)
	lines := strings.Split(config, "\n")

	ip := ""
	for _, s := range lines {
		if strings.Contains(s, "Address") {
			parts := strings.Split(s, "=")
			if len(parts) >= 2 {
				parts = strings.Split(parts[1], "/")
				ip = strings.Replace(parts[0], " ", "", -1)
			}
		}
	}

	return ip, nil
}
