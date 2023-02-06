package health

//
// Provider should be implemented by an object that wants to provide Health information.
//
type Provider interface {
	//
	// GetHealth returns the Health data.
	//
	GetHealth() (*Data, error)
}

//
// DataProvider is a Health Data.
//
type DataProvider interface {

	//
	// GetName returns name of the service.
	//
	GetName() string

	//
	// GetStatus returns status of service.
	//
	GetStatus() int

	//
	// GetLatency returns service latency.
	//
	GetLatency() float64
}

//
// Data represents the entity Health data object.
//
type Data struct {
	Name    string  `json:"-"`
	Status  int     `json:"status"`
	Latency float64 `json:"latency"`
}

//
// GetName returns name of the service.
//
func (d *Data) GetName() string {
	return d.Name
}

//
// GetStatus returns status of service.
//
func (d *Data) GetStatus() int {
	return d.Status
}

//
// GetLatency returns service latency.
//
func (d *Data) GetLatency() float64 {
	return d.Latency
}
