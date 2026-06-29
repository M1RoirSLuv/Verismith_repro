#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT"
mkdir -p artifacts/icarus_issue283_current

iverilog bugs/known_icarus_10_issue283.v \
  -o artifacts/icarus_issue283_current/im \
  > logs/icarus_issue283_current_build.log 2>&1

artifacts/icarus_issue283_current/im \
  > logs/icarus_issue283_current_run.log 2>&1

{
  echo "=== iverilog version ==="
  iverilog -V 2>&1 | sed -n '1,3p'
  echo "=== build log ==="
  cat logs/icarus_issue283_current_build.log
  echo "=== run output ==="
  cat logs/icarus_issue283_current_run.log
} | tee logs/icarus_issue283_current_summary.log
