package uuid

import (
	"crypto/rand"
	"encoding/hex"
	"io"
)

//
// SizeV4 the size of UUID v4.
//
const SizeV4 = 16

//
// V4 UUID v4.
//
type V4 [SizeV4]byte

//
// NewV4 creates a new V4 random UUID.
//
func NewV4() (V4, error) {

	// generates a totally random UUID (version 4) as described in RFC 4122.
	var u V4
	_, err := io.ReadFull(rand.Reader, u[:])
	if err != nil {
		return u, err
	}
	// set UUID version 4 fields according to RFC 4122.
	u[6] = (u[6] & 0x0f) | 0x40
	u[8] = (u[8] & 0x3f) | 0x80

	return u, err
}

//
// String returns the string representation of UUID.
//
func (u *V4) String() string {
	return hex.EncodeToString(u[:])
}

//
// Canonical returns the V4 representation of UUID.
//
func (u *V4) Canonical() string {
	buf := make([]byte, 36)

	hex.Encode(buf[0:8], u[0:4])
	buf[8] = '-'
	hex.Encode(buf[9:13], u[4:6])
	buf[13] = '-'
	hex.Encode(buf[14:18], u[6:8])
	buf[18] = '-'
	hex.Encode(buf[19:23], u[8:10])
	buf[23] = '-'
	hex.Encode(buf[24:], u[10:])

	return string(buf)
}
