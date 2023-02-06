package api

//
// Headers describes common values for most types of requests.
//
type Headers struct {
	OwnerID string `json:"-"`
}

//
// YIoTBaseRequest is a base structure for YIoT request which contains info about Owner
//
type YIoTBaseRequest struct {
	*Headers
}
