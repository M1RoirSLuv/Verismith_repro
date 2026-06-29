#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

ROOT="$REPRO_ROOT"
YOSYS09="/home/m1roirs/yosys_versions/0.9/bin/yosys"

cd "$ROOT"
mkdir -p logs artifacts

"$YOSYS09" -p 'read_verilog bugs/known_yosys_13.v; hierarchy -top top; synth -noabc; write_verilog -noattr artifacts/known_yosys_13_yosys_0_9_noabc.v' \
  > logs/known_yosys_13_yosys_0_9_noabc.log 2>&1

/usr/bin/yosys -p 'read_verilog bugs/known_yosys_13.v; hierarchy -top top; synth; write_verilog -noattr artifacts/known_yosys_13_current_yosys_synth.v' \
  > logs/known_yosys_13_current_yosys_synth.log 2>&1

echo "=== Yosys 0.9 output excerpt ==="
grep -n "y <=" artifacts/known_yosys_13_yosys_0_9_noabc.v || true
grep -n "assign y" artifacts/known_yosys_13_yosys_0_9_noabc.v || true

echo "=== Current Yosys output excerpt ==="
grep -n "y <=" artifacts/known_yosys_13_current_yosys_synth.v || true
grep -n "assign y" artifacts/known_yosys_13_current_yosys_synth.v || true
