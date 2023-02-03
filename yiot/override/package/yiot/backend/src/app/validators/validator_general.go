package validators

import (
	"encoding/base64"
	"regexp"
	"strconv"
	"strings"
	"yiot_api/api"
)

//
// ValidateUser performs a validation of the User object.
//
func ValidateUser(
	user string,
) error {
	if user == "" {
		return api.ErrUserFieldIsEmpty
	}

	if len(user) > 256 {
		return api.ErrUserFieldTooLong
	}

	matched, _ := regexp.MatchString(`^[a-z0-9]*$`, user)
	if !matched {
		return api.ErrUserFieldInvalid
	}

	return nil
}

//
// ValidatePassword performs a validation of the Password object.
//
func ValidatePassword(
	password string,
) error {
	if password == "" {
		return api.ErrPasswordIsEmpty
	}

	if len(password) > 512 {
		return api.ErrPasswordTooLong
	}

	matched, _ := regexp.MatchString(`^[a-zA-Z0-9.\!@\#\$%\^&\*\(\)]*$`, password)
	if !matched {
		return api.ErrPasswordFieldInvalid
	}

	return nil
}

//
// ValidateBCrypt performs a validation of the BCrypt hash string.
//
func ValidateBCrypt(
	password string,
) error {
	if password == "" {
		return api.ErrPasswordIsEmpty
	}

	if len(password) > 512 {
		return api.ErrPasswordTooLong
	}

	matched, _ := regexp.MatchString(`^\$2[ayb]\$.{56}$`, password)
	if !matched {
		return api.ErrBCryptFieldInvalid
	}

	return nil
}

//
// ValidateFullName performs a validation of the User's Full Name object.
//
func ValidateFullName(
	name string,
) error {
	if name == "" {
		return api.ErrUserNameIsEmpty
	}

	if len(name) > 256 {
		return api.ErrUserNameTooLong
	}

	matched, _ := regexp.MatchString(`^[a-zA-Z0-9 ]*$`, name)
	if !matched {
		return api.ErrUserNamedInvalid
	}

	return nil
}

//
// ValidateEmail performs a validation of the email.
//
func ValidateEmail(
	email string,
) error {

	matched, _ := regexp.MatchString(`^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$`, email)
	if !matched {
		return api.ErrEmailInvalid
	}

	return nil
}

//
// ValidateBase64 performs a validation of the Base64 string.
//
func ValidateBase64(
	val string,
) (string, error) {
	decodedValue, err := base64.StdEncoding.DecodeString(val)
	if err != nil {
		return "", api.ErrBase64Param
	}

	return string(decodedValue), nil
}

//
// ValidateIPv4Subnet performs a validation of the IPv4 subnet string.
//
func ValidateIPv4Subnet(
	val string, rangeMin int, rangeMax int,
) error {

	matched, _ := regexp.MatchString(`^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,3}$`, val)
	if !matched {
		return api.ErrSubnetIncorrect
	}

	elements := strings.Split(val, "/")
	if len(elements) < 2 {
		return api.ErrSubnetIncorrect
	}

	r, _ := strconv.Atoi(elements[1])

	if r < rangeMin || r > rangeMax {
		return api.ErrSubnetRangeIncorrect
	}

	return nil
}
