#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

bazel build //tools:compile_commands_json
sed "s,__EXEC_ROOT__,$(pwd)/bazel-sandbox," bazel-bin/tools/compile_commands.json > compile_commands.json
