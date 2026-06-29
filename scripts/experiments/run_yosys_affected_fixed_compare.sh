#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

ROOT="$REPRO_ROOT"
OUT="$ROOT/artifacts/yosys_affected_fixed"
LOG="$ROOT/logs/yosys_affected_fixed_compare.log"
mkdir -p "$OUT" "$ROOT/logs"
: > "$LOG"

ensure_abc() {
  local prefix="$1"
  if [[ -d "$prefix/bin" ]]; then
    ln -sf /usr/bin/yosys-abc "$prefix/bin/yosys-abc"
  fi
}

run_synth() {
  local label="$1"
  local bin="$2"
  local input="$3"
  local stem="$4"
  local read_cmd="$5"
  local out_v="$OUT/${stem}.v"
  local out_log="$ROOT/logs/${stem}.log"

  {
    echo "=== ${label} ==="
    "$bin" -V
  } | tee -a "$LOG"

  set +e
  "$bin" -q -p "${read_cmd} ${input}; synth; write_verilog -noattr ${out_v}" > "$out_log" 2>&1
  local status=$?
  set -e
  echo "exit code: ${status}" | tee -a "$LOG"
  if [[ -f "$out_v" ]]; then
    grep -nE "assign y|y <=|1'hx|1'h0|1'h1|reg10_reg|input w|input \\[2:0\\] w|w\\[2\\]|sel|vector::_M_range_check|out_of_range" "$out_v" \
      | head -n 20 | tee -a "$LOG" || true
  else
    grep -E "PEEPOPT|vector::_M_range_check|out_of_range|terminate called|Aborted|ERROR" "$out_log" \
      | tail -n 20 | tee -a "$LOG" || true
  fi
  echo "" | tee -a "$LOG"
}

for p in \
  /home/m1roirs/yosys_versions/70d0f38 \
  /home/m1roirs/yosys_versions/b37c31e \
  /home/m1roirs/yosys_versions/09467bb9 \
  /home/m1roirs/yosys_versions/33738c1 \
  /home/m1roirs/yosys_versions/92dde319 \
  /home/m1roirs/yosys_versions/349c472 \
  /home/m1roirs/yosys_versions/acd8bc0a \
  /home/m1roirs/yosys_versions/39f4c10 \
  /home/m1roirs/yosys_versions/0466c485 \
  /home/m1roirs/yosys_versions/4b18a45
do
  ensure_abc "$p"
done

cd "$ROOT"

run_synth "Issue 993 affected 70d0f38" \
  /home/m1roirs/yosys_versions/70d0f38/bin/yosys \
  bugs/known_yosys_6_issue993_crash.v \
  issue993_affected_70d0f38 \
  "read -formal"

run_synth "Issue 993 fixed b37c31e" \
  /home/m1roirs/yosys_versions/b37c31e/bin/yosys \
  bugs/known_yosys_6_issue993_crash.v \
  issue993_fixed_b37c31e \
  "read -formal"

run_synth "Issue 997 affected 09467bb9" \
  /home/m1roirs/yosys_versions/09467bb9/bin/yosys \
  bugs/known_yosys_7_issue997_init_ignored.v \
  issue997_affected_09467bb9 \
  "read -formal"

run_synth "Issue 997 fixed 33738c1" \
  /home/m1roirs/yosys_versions/33738c1/bin/yosys \
  bugs/known_yosys_7_issue997_init_ignored.v \
  issue997_fixed_33738c1 \
  "read -formal"

run_synth "Issue 1047 affected 92dde319" \
  /home/m1roirs/yosys_versions/92dde319/bin/yosys \
  bugs/known_yosys_8_issue1047_shift_mul.v \
  issue1047_affected_92dde319 \
  "read -formal"

run_synth "Issue 1047 fixed 349c472" \
  /home/m1roirs/yosys_versions/349c472/bin/yosys \
  bugs/known_yosys_8_issue1047_shift_mul.v \
  issue1047_fixed_349c472 \
  "read -formal"

run_synth "Issue 1243 affected acd8bc0a" \
  /home/m1roirs/yosys_versions/acd8bc0a/bin/yosys \
  bugs/known_yosys_9_issue1243_for_if.v \
  issue1243_affected_acd8bc0a \
  "read_verilog"

run_synth "Issue 1243 fixed 39f4c10" \
  /home/m1roirs/yosys_versions/39f4c10/bin/yosys \
  bugs/known_yosys_9_issue1243_for_if.v \
  issue1243_fixed_39f4c10 \
  "read_verilog"

run_synth "Issue 1531 affected 0466c485" \
  /home/m1roirs/yosys_versions/0466c485/bin/yosys \
  bugs/known_yosys_13_issue1531_missynth.v \
  issue1531_affected_0466c485 \
  "read_verilog"

run_synth "Issue 1531 later commit 4b18a45, still marked not fixed in bug report" \
  /home/m1roirs/yosys_versions/4b18a45/bin/yosys \
  bugs/known_yosys_13_issue1531_missynth.v \
  issue1531_later_4b18a45 \
  "read_verilog"

run_synth "Yosys_11 affected 0.9, unreported fixed-by example" \
  /home/m1roirs/yosys_versions/0.9/bin/yosys \
  bugs/known_yosys_11.v \
  yosys11_affected_0_9 \
  "read_verilog"

run_synth "Yosys_11 fixed 4b18a45, unreported fixed-by example" \
  /home/m1roirs/yosys_versions/4b18a45/bin/yosys \
  bugs/known_yosys_11.v \
  yosys11_fixed_4b18a45 \
  "read_verilog"

cat "$LOG"
