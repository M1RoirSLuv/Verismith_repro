#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

ROOT="$REPRO_ROOT"
cd "$ROOT"
mkdir -p logs artifacts/yosys_exact_bugs

LOG="logs/yosys_exact_bug_cases.log"
: > "$LOG"

run_yosys() {
  local title="$1"
  local bin="$2"
  local input="$3"
  local output="$4"
  local cmd="$5"
  {
    echo "=== ${title} ==="
    "$bin" -V
    echo "input: ${input}"
  } | tee -a "$LOG"
  "$bin" -q -p "$cmd" > "logs/${output}.log" 2>&1 || true
}

run_yosys \
  "Issue 997, exact affected commit 09467bb9" \
  "/home/m1roirs/yosys_versions/09467bb9/bin/yosys" \
  "bugs/known_yosys_7_issue997_init_ignored.v" \
  "issue997_09467bb9" \
  "read -formal bugs/known_yosys_7_issue997_init_ignored.v; synth; write_verilog -noattr artifacts/yosys_exact_bugs/issue997_09467bb9.v"

{
  echo "Generated netlist excerpt:"
  grep -nE "reg10_reg|1'hx|1'h0|assign y" artifacts/yosys_exact_bugs/issue997_09467bb9.v || true
  echo ""
} | tee -a "$LOG"

if [[ -x /home/m1roirs/yosys_versions/92dde319/bin/yosys ]]; then
  run_yosys \
    "Issue 1047, exact affected commit 92dde319" \
    "/home/m1roirs/yosys_versions/92dde319/bin/yosys" \
    "bugs/known_yosys_8_issue1047_shift_mul.v" \
    "issue1047_92dde319" \
    "read -formal bugs/known_yosys_8_issue1047_shift_mul.v; synth; write_verilog -noattr artifacts/yosys_exact_bugs/issue1047_92dde319.v"
  {
    echo "Generated netlist excerpt:"
    grep -nE "assign y|input \\[2:0\\] w|_0_|w\\[|~" artifacts/yosys_exact_bugs/issue1047_92dde319.v || true
    echo ""
  } | tee -a "$LOG"
fi

if [[ -x /home/m1roirs/yosys_versions/acd8bc0a/bin/yosys ]]; then
  run_yosys \
    "Issue 1243, exact affected commit acd8bc0a" \
    "/home/m1roirs/yosys_versions/acd8bc0a/bin/yosys" \
    "bugs/known_yosys_9_issue1243_for_if.v" \
    "issue1243_acd8bc0a" \
    "read_verilog bugs/known_yosys_9_issue1243_for_if.v; synth; write_verilog -noattr artifacts/yosys_exact_bugs/issue1243_acd8bc0a.v"
  {
    echo "Generated netlist excerpt:"
    grep -nE "assign y|1'h0|sel|reg_assign" artifacts/yosys_exact_bugs/issue1243_acd8bc0a.v || true
    echo ""
  } | tee -a "$LOG"
fi

if [[ -x /home/m1roirs/yosys_versions/0466c485/bin/yosys ]]; then
  run_yosys \
    "Issue 1531, exact affected commit 0466c485" \
    "/home/m1roirs/yosys_versions/0466c485/bin/yosys" \
    "bugs/known_yosys_13_issue1531_missynth.v" \
    "issue1531_0466c485" \
    "read_verilog bugs/known_yosys_13_issue1531_missynth.v; synth; write_verilog -noattr artifacts/yosys_exact_bugs/issue1531_0466c485.v"
  {
    echo "Generated netlist excerpt:"
    grep -nE "always|y <=|assign y|1'h1|input w" artifacts/yosys_exact_bugs/issue1531_0466c485.v || true
    echo ""
  } | tee -a "$LOG"
fi

cat "$LOG"
