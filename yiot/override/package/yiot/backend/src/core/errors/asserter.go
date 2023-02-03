package errors

import (
	"testing"
)

//
// AssertAppError checks is any of errors inside the error queue passed as an err parameter
// contains the error of type expectedError.
//
func AssertAppError(t *testing.T, expectedError error, err error) bool {
	if expectedError == err {
		return true
	}

	typedError := Cause(err, (*AppError)(nil))
	if nil == typedError || typedError.Error() != expectedError.Error() {
		t.Errorf("Error type is not as expected.\nexpected: %s\nactual: %s", expectedError, err)

		return false
	}

	return true
}
