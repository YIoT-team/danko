//  ────────────────────────────────────────────────────────────
//                     ╔╗  ╔╗ ╔══╗      ╔════╗
//                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
//                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
//                      ╚╗╔╝   ║║  ║╔╗║   ║║
//                       ║║   ╔╣╠╗ ║╚╝║   ║║
//                       ╚╝   ╚══╝ ╚══╝   ╚╝
//    ╔╗╔═╗                    ╔╗                     ╔╗
//    ║║║╔╝                   ╔╝╚╗                    ║║
//    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
//    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
//    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
//    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
//                    ║║                         ║║
//                    ╚╝                         ╚╝
//
//    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
//  ────────────────────────────────────────────────────────────

package main

import (
	"fmt"
	"os"

	"yiot_api/core/http"
	"yiot_api/core/log"

	"yiot_api/cfg/config"
	"yiot_api/cfg/di"
)

const (
	Version = "0.1.0.2"
)

// ----------------------------------------------------------------------------
//
// main entry point.
//
func main() {

	// Config, Logger
	c := initConfig()
	l := initLogger(c.GetLogLevel())

	// Print Version
	fmt.Printf("===- VERSION : %v -===\n", Version)

	// DI
	diContainer := initDIContainer(c, l)

	// Run Service
	var h = diContainer.GetHTTPRouter().GetMuxRouter()

	http.NewService(
		config.ServiceName,
		c.GetServerHTTPAddress(),
		c.GetServerReadTimeout(),
		c.GetServerWriteTimeout(),
		h,
		l,
	).Run()
}

// ----------------------------------------------------------------------------
//
// initConfig makes Config init.
//
func initConfig() *config.Config {

	c, err := config.New()
	if err != nil {
		panicError("config initialization error", err)
	}

	return c
}

// ----------------------------------------------------------------------------
//
// initLogger makes Logger init.
//
func initLogger(logLevel string) log.Logger {

	return log.New(os.Stdout, logLevel)
}

// ----------------------------------------------------------------------------
//
// initDIContainer makes DI Container init.
//
func initDIContainer(c *config.Config, l log.Logger) *di.Container {

	diContainer, err := di.NewContainer(c, l)
	if nil != err {
		panicError("DI initialization error", err)
	}

	if err := diContainer.Build(); err != nil {
		panicError("DI build error", err)
	}

	return diContainer
}

// ----------------------------------------------------------------------------
//
// panicError panics with an error.
//
func panicError(msg string, err error) {
	panic(fmt.Sprintf("%s: %+v", msg, err))
}

// ----------------------------------------------------------------------------
