package response

//
// PostProcesser provides an interface to make a post process of the Response object.
//
type PostProcesser interface {

	//
	// Process makes post process of the response data.
	//
	Process() error

	//
	// SetData sets the response data.
	//
	SetData(data interface{})

	//
	// SetResponse sets the response object.
	//
	SetResponse(response Provider)
}

//
// DefaultPostProcessor represents just an empty post process just for initialization consistency.
//
type DefaultPostProcessor struct {
	response Provider
}

//
// Process makes post process of the response.
//
func (p *DefaultPostProcessor) Process() error {

	return nil
}

//
// SetData sets the response data.
//
func (p *DefaultPostProcessor) SetData(d interface{}) {

}

//
// SetResponse sets the response object.
//
func (p *DefaultPostProcessor) SetResponse(r Provider) {

	p.response = r
}
