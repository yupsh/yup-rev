#!/bin/sh
# Integration checks for yup-rev, run inside a Debian container with util-linux
# (rev ships in util-linux, not coreutils).
#
# parity_stdin INPUT       — yup-rev reading stdin must match util-linux `rev`.
# parity_file  FILE...     — yup-rev reading file operands must match util-linux.
set -eu

fails=0
sample='Hello World
abc
12345'

parity_stdin() {
	in=$1
	ours=$(printf '%s' "$in" | yup-rev 2>/dev/null || true)
	ref=$(printf '%s' "$in" | rev 2>/dev/null || true)
	if [ "$ours" = "$ref" ]; then
		printf 'ok    parity  rev < stdin\n'
	else
		printf 'FAIL  parity  rev < stdin\n        ref:  %s\n        ours: %s\n' "$ref" "$ours"
		fails=$((fails + 1))
	fi
}

parity_file() {
	ours=$(yup-rev "$@" 2>/dev/null || true)
	ref=$(rev "$@" 2>/dev/null || true)
	if [ "$ours" = "$ref" ]; then
		printf 'ok    parity  rev %s\n' "$*"
	else
		printf 'FAIL  parity  rev %s\n        ref:  %s\n        ours: %s\n' "$*" "$ref" "$ours"
		fails=$((fails + 1))
	fi
}

# stdin: single ASCII line, multiple lines, and empty input.
parity_stdin "$(printf 'Hello World\n')"
parity_stdin "$(printf '%s\n' "$sample")"
parity_stdin ''

# file operands: single and multiple files, concatenated in order.
printf '%s\n' "$sample" > /tmp/a.txt
printf 'one\ntwo\n' > /tmp/b.txt
parity_file /tmp/a.txt
parity_file /tmp/a.txt /tmp/b.txt

if [ "$fails" -ne 0 ]; then
	printf '\n%s check(s) failed\n' "$fails"
	exit 1
fi
printf '\nall checks passed\n'
