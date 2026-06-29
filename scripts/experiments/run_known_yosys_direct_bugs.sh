#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT"
mkdir -p artifacts/known_yosys_direct logs

echo "=== Yosys Issue 993 direct crash case ===" | tee logs/known_yosys_direct_bugs.log
echo "Tool: /home/m1roirs/yosys_versions/70d0f38/bin/yosys" | tee -a logs/known_yosys_direct_bugs.log
/home/m1roirs/yosys_versions/70d0f38/bin/yosys -V 2>&1 | tee -a logs/known_yosys_direct_bugs.log
set +e
/home/m1roirs/yosys_versions/70d0f38/bin/yosys \
  -p 'read -formal bugs/known_yosys_6_issue993_crash.v; synth; write_verilog artifacts/known_yosys_direct/issue993_yosys_70d0f38.v' \
  > logs/known_yosys_issue993_yosys_70d0f38.log 2>&1
issue993_status=$?
set -e
echo "Issue 993 exit code: ${issue993_status}" | tee -a logs/known_yosys_direct_bugs.log
grep -E "terminate called|vector::_M_range_check|out_of_range|Aborted|ERROR|Executing PEEPOPT" \
  logs/known_yosys_issue993_yosys_70d0f38.log | tail -n 20 | tee -a logs/known_yosys_direct_bugs.log

echo "" | tee -a logs/known_yosys_direct_bugs.log
echo "=== Yosys Issue 1531 direct mis-synthesis case ===" | tee -a logs/known_yosys_direct_bugs.log
echo "Tool: /home/m1roirs/yosys_versions/0.9/bin/yosys" | tee -a logs/known_yosys_direct_bugs.log
/home/m1roirs/yosys_versions/0.9/bin/yosys -V 2>&1 | tee -a logs/known_yosys_direct_bugs.log
/home/m1roirs/yosys_versions/0.9/bin/yosys -q \
  -p 'read_verilog bugs/known_yosys_13_issue1531_missynth.v; synth; write_verilog -noattr artifacts/known_yosys_direct/issue1531_yosys_0_9.v' \
  > logs/known_yosys_issue1531_yosys_0_9.log 2>&1
echo "Generated netlist excerpt:" | tee -a logs/known_yosys_direct_bugs.log
grep -nE "always|y <=|assign y|1'h1|input w" \
  artifacts/known_yosys_direct/issue1531_yosys_0_9.v | tee -a logs/known_yosys_direct_bugs.log
