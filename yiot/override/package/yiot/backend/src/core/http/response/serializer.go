package response

import "encoding/json"

const (
	//
	// JSONSerializerType the type of current serializer.
	//
	JSONSerializerType = "json"
)

//
// Serializer provides an interface to work with the data serialization
//
type Serializer interface {
	//
	// GetType returns the serializer type.
	//
	GetType() string

	//
	// Serialize makes data serialization.
	//
	Serialize(data interface{}) ([]byte, error)

	//
	// GetContentType returns the Content Type for current serializer.
	//
	GetContentType() string
}

//
// JSONSerializer represents the JSON data serialize.
//
type JSONSerializer struct {
	serializerType string
}

//
// NewJSONSerializer creates
//
func NewJSONSerializer() *JSONSerializer {

	return &JSONSerializer{
		serializerType: JSONSerializerType,
	}
}

//
// GetType returns the serializer type.
//
func (s JSONSerializer) GetType() string {

	return s.serializerType
}

//
// Serialize makes data serialization.
//
func (s JSONSerializer) Serialize(data interface{}) ([]byte, error) {
	if data == (interface{})(nil) {
		return nil, nil
	}

	return json.Marshal(data)
}

//
// GetContentType returns the Content Type for current serializer.
//
func (s JSONSerializer) GetContentType() string {

	return "application/json"
}
