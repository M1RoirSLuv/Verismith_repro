#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

ROOT="$REPRO_ROOT"
WORK="$ROOT/artifacts/reduction_issue997"
VERISMITH="/home/m1roirs/verismith_versions/0.6.0.2/bin/verismith"
SRC="$ROOT/fuzz_yosys_3333e002_ms_seed_v0602_abc/fuzz_1/yosys/rtl.v"

mkdir -p "$WORK" "$ROOT/logs"
cp "$SRC" "$WORK/issue997_original.v"

cd "$WORK"

cat > interesting_issue997.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail

YOSYS="/home/m1roirs/yosys_versions/09467bb9/bin/yosys"
INPUT="candidate.v"
OUT="candidate_syn.v"
LOG="candidate_yosys.log"

"$YOSYS" -q -p "read -formal $INPUT; synth; write_verilog -noattr $OUT" > "$LOG" 2>&1 || exit 1
grep -q "1'hx" "$OUT"
SH
chmod +x interesting_issue997.sh

cp issue997_original.v candidate.v

{
  echo "=== Reduction target ==="
  echo "$SRC"
  echo "original lines: $(wc -l < issue997_original.v)"
  echo "=== Initial interestingness check ==="
  ./interesting_issue997.sh
  echo "initial interestingness: pass"
  echo "=== Verismith reduction ==="
} | tee "$ROOT/logs/reduction_issue997.log"

"$VERISMITH" reduce candidate.v --script ./interesting_issue997.sh \
  >> "$ROOT/logs/reduction_issue997.log" 2>&1

{
  echo "=== Reduction outputs ==="
  ls -l reduce_script.v candidate.v candidate.v.original 2>/dev/null || true
  if [[ -f reduce_script.v ]]; then
    echo "reduced lines: $(wc -l < reduce_script.v)"
    cp reduce_script.v "$ROOT/bugs/reduced_issue997_by_verismith.v"
    cp reduce_script.v candidate.v
    ./interesting_issue997.sh
    echo "reduced interestingness: pass"
  fi
} | tee -a "$ROOT/logs/reduction_issue997.log"
