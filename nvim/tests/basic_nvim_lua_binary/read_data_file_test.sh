#!/usr/bin/env bash

set -euo pipefail

ROOT="$(dirname "$0")"
output="$("$ROOT"/basic_nvim_lua_binary_with_data_runner.sh)"

[ "$output" == "314159" ]
