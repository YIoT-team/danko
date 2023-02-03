package health

//
// ServiceInfoResponse Service Info response.
//
type ServiceInfoResponse struct {
	Build        *BuildInfo       `json:"build,omitempty"`
	Dependencies map[string]*Data `json:"dependencies,omitempty"`
}

//
// NewServiceInfoResponse creates new instance of Service Info response.
//
func NewServiceInfoResponse(build *BuildInfo, dependencies map[string]*Data) *ServiceInfoResponse {

	return &ServiceInfoResponse{
		Build:        build,
		Dependencies: dependencies,
	}
}
