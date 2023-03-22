package pprof

import (
	"fmt"
	"log"
	"net/http"
	nhpprof "net/http/pprof"
	"net/url"
	"runtime/pprof"
	"strings"
	"text/template"
)

func handler(token string) http.Handler {
	info := struct {
		Profiles []*pprof.Profile
		Token    string
	}{
		Profiles: pprof.Profiles(),
		Token:    url.QueryEscape(token),
	}

	h := func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimPrefix(r.URL.Path, "/")
		switch name {
		case "":
			// Index page.
			if err := indexTmpl.Execute(w, info); err != nil {
				log.Println(err)
				return
			}
		case "cmdline":
			nhpprof.Cmdline(w, r)
		case "profile":
			nhpprof.Profile(w, r)
		case "trace":
			nhpprof.Trace(w, r)
		case "symbol":
			nhpprof.Symbol(w, r)
		default:
			// Provides access to all profiles under runtime/pprof
			nhpprof.Handler(name).ServeHTTP(w, r)
		}
	}
	return http.HandlerFunc(h)
}

// AuthHandler returns an http.Handler that provides authenticated
// access to the various profiler and debug tools in the
// /net/http/pprof and /runtime/pprof packages.
//
// The token provided is required as a URL parameter called token for
// all requests. The netbug package takes care of injecting the token
// into links in the index page.
//
// The returned handler assumed it is registered on "/" so if you wish
// to register on any other route, you should strip the route prefix
// before passing a request on to the handler.
//
// This is best done with:
//
//	h := http.StripPrefix("/myroute/", netbug.AuthHandler("secret"))
//
// Unless you need to wrap or chain the handler you probably want to use
// netbug.RegisterAuthHandler.
func AuthHandler(token string) http.Handler {
	h := handler(token)
	ah := func(w http.ResponseWriter, r *http.Request) {
		if r.FormValue("token") == token {
			h.ServeHTTP(w, r)
		} else {
			w.WriteHeader(http.StatusUnauthorized)
			fmt.Fprintln(w, "Unauthorized.")
		}
	}
	return http.HandlerFunc(ah)
}

var indexTmpl = template.Must(template.New("index").Parse(`<html>
  <head>
    <title>Debug Information</title>
  </head>
  <br>
  <body>
    profiles:<br>
    <table>
    {{range .Profiles}}
      <tr>
		<td align=right>{{.Count}}<td>
		<a href="pprof/{{.Name}}?debug=1{{if $.Token}}&token={{$.Token}}{{end}}">{{.Name}}</a>
    {{end}}
    <tr><td align=right><td><a href="pprof/profile{{if .Token}}?token={{.Token}}{{end}}">CPU</a>
    <tr><td align=right><td><a href="pprof/trace?seconds=5{{if .Token}}&token={{.Token}}{{end}}">5-second trace</a>
    <tr><td align=right><td><a href="pprof/trace?seconds=30{{if .Token}}&token={{.Token}}{{end}}">30-second trace</a>
    </table>
    <br>
    debug information:<br>
    <table>
      <tr><td align=right><td><a href="pprof/cmdline{{if .Token}}?token={{.Token}}{{end}}">cmdline</a>
      <tr><td align=right><td><a href="pprof/symbol{{if .Token}}?token={{.Token}}{{end}}">symbol</a>
    <tr>
		<td align=right><td>
		<a href="pprof/goroutine?debug=2{{if .Token}}&token={{.Token}}{{end}}">full goroutine stack dump</a><br>
    <table>
  </body>
</html>`))
