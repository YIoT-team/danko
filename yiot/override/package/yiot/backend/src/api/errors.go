package api

import (
	"yiot_api/core/errors"
)

//
// Core errors.
//
var (
	// Bulk internal errors.
	ErrNotImplementedError = errors.NewHTTP501Error(
		50100,
		"Request serving Not implemented error. Try again later.",
	)
	ErrInternalError = errors.NewHTTP500Error(
		10000,
		"Request serving internal error. Try again later.",
	)
	ErrNotFound = errors.NewHTTP404Error(
		10001,
		"Requested entity not found.",
	)
	// Application errors.
	ErrRequestParsing = errors.NewHTTP400Error(
		10002,
		"Request body parsing error. Invalid JSON, field name or field type.",
	)
)

//
// Billing errors
//
var (
	// Low credit error.
	ErrBillingLowCredit = errors.NewHTTP400Error(
		30001,
		"Low credit.",
	)
)

//
// Service creation errors
//
var (
	// Service already active error.
	ErrServiceAlreadyActive = errors.NewHTTP400Error(
		40001,
		"Sertvice already active",
	)

	ErrUserFieldIsEmpty = errors.NewHTTP400Error(
		40002,
		"User field cannot be empty",
	)

	ErrUserFieldTooLong = errors.NewHTTP400Error(
		40003,
		"User field cannot be greater than 256 symbols",
	)

	ErrUserFieldInvalid = errors.NewHTTP400Error(
		40004,
		"User field should contain lower case letters and digits",
	)

	ErrPasswordIsEmpty = errors.NewHTTP400Error(
		40005,
		"Password field cannot be empty",
	)

	ErrPasswordTooLong = errors.NewHTTP400Error(
		40006,
		"Password field cannot be greater than 512 symbols",
	)

	ErrPasswordFieldInvalid = errors.NewHTTP400Error(
		40007,
		"Password field should contain letters and digits, and symbols .!@#$%^&*()",
	)

	ErrEmailInvalid = errors.NewHTTP400Error(
		40008,
		"Email field is invalid",
	)

	ErrUserNameIsEmpty = errors.NewHTTP400Error(
		40009,
		"Full User Name field cannot be empty",
	)

	ErrUserNameTooLong = errors.NewHTTP400Error(
		40010,
		"Full User Name field cannot be greater than 256 symbols",
	)

	ErrUserNamedInvalid = errors.NewHTTP400Error(
		40011,
		"Full User Name field should contain letters and space symbols",
	)

	ErrBase64Param = errors.NewHTTP400Error(
		40012,
		"Incorrect base64 parameter",
	)

	ErrSubnetIncorrect = errors.NewHTTP400Error(
		40013,
		"Subnet parameter is incorrect",
	)

	ErrSubnetRangeIncorrect = errors.NewHTTP400Error(
		40014,
		"Subnet range is incorrect",
	)

	ErrBCryptFieldInvalid = errors.NewHTTP400Error(
		40015,
		"BCrypt hash is incorrect",
	)
)
