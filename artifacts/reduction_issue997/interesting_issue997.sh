#!/usr/bin/env bash
set -euo pipefail

YOSYS="/home/m1roirs/yosys_versions/09467bb9/bin/yosys"
INPUT="candidate.v"
OUT="candidate_syn.v"
LOG="candidate_yosys.log"

"$YOSYS" -q -p "read -formal $INPUT; synth; write_verilog -noattr $OUT" > "$LOG" 2>&1 || exit 1
grep -q "1'hx" "$OUT"
