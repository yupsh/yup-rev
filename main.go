// Command yup-rev is the CLI wrapper around github.com/gloo-foo/cmd-rev.
package main

import (
	clix "github.com/gloo-foo/cli"
	command "github.com/gloo-foo/cmd-rev"
)

// version is the build version. It defaults to "dev" for local builds and is
// overridden at release time via the linker: -ldflags "-X main.version=<v>".
var version = "dev"

const name = "rev"

// synopsis is the multi-line --help usage block; urfave/cli indents it three
// spaces, so the lines stay flush-left.
const synopsis = `rev [OPTIONS] [FILE...]

The rev utility copies the specified files to standard output, reversing
the order of characters in every line. If no files are specified, standard
input is read.`

// spec declares the rev wrapper: a file-or-stdin filter that takes no options.
var spec = clix.Spec{
	Name:     name,
	Summary:  "reverse lines characterwise",
	Synopsis: synopsis,
	Build:    build,
}

// build maps the invocation to rev's pipeline: a file-or-stdin source into the
// rev command, which takes no options.
func build(inv clix.Invocation) (clix.Source, clix.Command, error) {
	return clix.OperandsOrStdin(inv), command.Rev(), nil
}

// runMain is an indirection seam so main's wiring is testable without spawning
// the process; a test swaps it and restores it.
var runMain = clix.Main

func main() { runMain(spec, version) }
