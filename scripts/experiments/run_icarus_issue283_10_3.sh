#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT"
mkdir -p artifacts/icarus_issue283_10_3

iverilog_bin=/home/m1roirs/iverilog_versions/10.3/bin/iverilog

"${iverilog_bin}" bugs/known_icarus_10_issue283.v \
  -o artifacts/icarus_issue283_10_3/im \
  > logs/icarus_issue283_10_3_build.log 2>&1

artifacts/icarus_issue283_10_3/im \
  > logs/icarus_issue283_10_3_run.log 2>&1

{
  echo "=== iverilog version ==="
  "${iverilog_bin}" -V 2>&1 | sed -n '1,3p'
  echo "=== build log ==="
  cat logs/icarus_issue283_10_3_build.log
  echo "=== run output ==="
  cat logs/icarus_issue283_10_3_run.log
} | tee logs/icarus_issue283_10_3_summary.log
