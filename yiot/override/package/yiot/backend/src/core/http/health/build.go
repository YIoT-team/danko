package health

var (
	// BuildDate build date.
	BuildDate string

	// BuildBranch which branch has has used for build.
	BuildBranch string

	// BuildCommit which commit hash has used for build.
	BuildCommit string
)

//
// BuildInfo is a service build info.
//
type BuildInfo struct {
	Date   string `json:"date,omitempty"`
	Branch string `json:"branch,omitempty"`
	Commit string `json:"commit,omitempty"`
}

//
// NewBuildInfo returns new Build instance.
//
func NewBuildInfo() *BuildInfo {

	return &BuildInfo{
		Date:   BuildDate,
		Branch: BuildBranch,
		Commit: BuildCommit,
	}
}
