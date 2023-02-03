package response

import (
	"net/http"
)

//
// Provider provides a HTTP response.
//
type Provider interface {
	//
	// GetData returns a response data.
	//
	GetData() ([]byte, error)

	//
	// GetStatus returns a response HTTP Status Code.
	//
	GetStatus() int

	//
	// SetHeader sets response header.
	//
	SetHeader(header string, value string)

	//
	// SetHeaders sets the response Headers.
	//
	SetHeaders(headers http.Header)

	//
	// GetHeader returns a response Header by header name.
	//
	GetHeader(header string) string

	//
	// GetHeaders returns a response Headers list.
	//
	GetHeaders() http.Header

	//
	// SetPostProcessor sets the Response post processor.
	//
	SetPostProcessor(p PostProcesser)

	//
	// GetPostProcessor returns the Response post processor.
	//
	GetPostProcessor() PostProcesser
}

//
// Response represents a HTTP service response.
//
type Response struct {
	data          interface{}
	status        int
	headers       http.Header
	serializer    Serializer
	postProcessor PostProcesser
}

//
// NewResponse returns a new HTTP service response.
//
func NewResponse(data interface{}, status int) *Response {

	serializer := NewJSONSerializer()
	response := Response{
		data:    data,
		status:  status,
		headers: http.Header{},
	}
	response.SetSerializer(serializer)
	response.SetPostProcessor(new(DefaultPostProcessor))
	response.SetHeader("Content-Type", serializer.GetContentType())

	return &response
}

//
// GetData returns a response data.
//
func (r *Response) GetData() ([]byte, error) {

	return r.serializer.Serialize(r.data)
}

//
// GetStatus returns a response HTTP Status Code.
//
func (r *Response) GetStatus() int {

	return r.status
}

//
// SetHeader sets response header.
//
func (r *Response) SetHeader(key string, value string) {

	r.headers.Set(key, value)
}

//
// SetHeaders sets the response Headers.
//
func (r *Response) SetHeaders(headers http.Header) {

	r.headers = headers
}

//
// GetHeader returns a response Header by header name.
//
func (r *Response) GetHeader(name string) string {

	return r.headers.Get(name)
}

//
// GetHeaders returns a response Headers list.
//
func (r *Response) GetHeaders() http.Header {

	return r.headers
}

//
// SetPostProcessor sets the Response post processor.
//
func (r *Response) SetPostProcessor(pp PostProcesser) {

	pp.SetData(r.data)
	pp.SetResponse(r)
	r.postProcessor = pp
}

//
// GetPostProcessor returns the Response post processor.
//
func (r *Response) GetPostProcessor() PostProcesser {

	return r.postProcessor
}

//
// SetSerializer sets the custom response serializer.
//
func (r *Response) SetSerializer(serializer Serializer) {

	r.serializer = serializer
}
