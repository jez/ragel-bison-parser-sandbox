#!/bin/bash
set -e

cd "$(dirname "$0")/../.."

targets="$(bazel query 'kind("cc_(library|binary|test)", //...)' | sort)"

buildifier="$(mktemp -t buildifier.XXXXXX)"
cleanup() {
  rm -f "tools/BUILD.tmp"
  rm -f "$buildifier"
}
trap cleanup exit

# TODO(jez) Consider using buildifier to format the output file

(
  sed -n '1,/BEGIN compile_commands/p' tools/BUILD
  echo "$targets" | sed -e 's/^/        "/' -e 's/$/",/' | grep -v "\\.tar"
  sed -n '/END compile_commands/,$p' tools/BUILD
) > tools/BUILD.tmp

if [ "$1" == "-t" ]; then
  if ! diff -u tools/BUILD tools/BUILD.tmp; then
    echo >&2 "tools/BUILD needs to be updated. Please re-run:"
    echo >&2 ""
    echo >&2 "    tools/scripts/generate_compdb_targets.sh"
    echo >&2 ""
    echo >&2 "and commit the result."
    exit 1
  fi
else
  mv -f tools/BUILD.tmp tools/BUILD
fi
