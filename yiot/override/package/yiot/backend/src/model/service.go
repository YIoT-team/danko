package model

import (
	"time"
)

//
// YIoT Services Info.
//
type ServiceInfo struct {
	Id           int64       `json:"id"`
	Owner        string      `json:"owner"`
	Name         string      `json:"name"`
	CreationDate time.Time   `json:"creation_date"`
	Params       interface{} `json:"parameters"`
	Info         interface{} `json:"info"`
}
