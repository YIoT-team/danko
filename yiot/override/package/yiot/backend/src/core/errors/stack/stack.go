package stack

import (
	"fmt"
	"go/build"
	"runtime"
	"strings"
)

//
// General constants.
//
const (
	StacktraceDepth = 16
)

//
// Stack wraps a stack of program counters.
//
type Stack []uintptr

//
// Format prints the stack trace.
//
func (s *Stack) Format(st fmt.State, verb rune) {
	switch verb {
	case 'v':
		fallthrough
	default:
		for _, pc := range *s {
			var (
				function = "unknown"
				file     string
				line     int
			)
			fn := runtime.FuncForPC(pc)
			if fn != nil {
				function = sanitizeFunctionName(fn.Name())
				file, line = fn.FileLine(pc)
				file = sanitizeFilename(file)
			}

			fmt.Fprintf(st, " @ %s:%s:%d\n", file, function, line)
		}
	}
}

//
// Get returns current invoker stack.
//
func Get() *Stack {
	pcs := make([]uintptr, StacktraceDepth)
	n := runtime.Callers(3, pcs[:])
	var st Stack = pcs[0:n]

	return &st
}

//
// sanitizeFunctionName cleans up a function name from the module full name info.
//
func sanitizeFunctionName(filename string) string {
	lastDotIndex := strings.LastIndex(filename, ".")

	return filename[lastDotIndex+1:]
}

//
// sanitizeFilename cleans up a file name from the GOROOT and GOPATH prefixes.
//
func sanitizeFilename(filename string) string {
	pathPrefixes := []string{
		build.Default.GOPATH + "/src",
		runtime.GOROOT() + "/src",
	}

	for _, pathPrefix := range pathPrefixes {
		if strings.HasPrefix(filename, pathPrefix) {
			return filename[len(pathPrefix)+1:]
		}
	}

	return filename
}
