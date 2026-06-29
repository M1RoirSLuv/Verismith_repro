#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

ROOT="$REPRO_ROOT"
SRC="$ROOT/upstream/yosys_0_8"
PREFIX="/home/m1roirs/yosys_versions/0.8"
LOG="$ROOT/logs/yosys_0_8_build.log"

cd "$SRC"
make config-gcc > "$LOG" 2>&1
{
  echo ""
  echo "ENABLE_ABC := 0"
} >> Makefile.conf

if ! grep -q "#include <limits>" passes/sat/freduce.cc; then
  python3 - <<'PY'
from pathlib import Path
p = Path("passes/sat/freduce.cc")
s = p.read_text()
s = s.replace("#include <algorithm>\n", "#include <algorithm>\n#include <limits>\n", 1)
p.write_text(s)
PY
fi

timeout 40m make -j2 PREFIX="$PREFIX" >> "$LOG" 2>&1
make install PREFIX="$PREFIX" >> "$LOG" 2>&1
"$PREFIX/bin/yosys" -V > "$ROOT/logs/yosys_0_8_version.txt"
cat "$ROOT/logs/yosys_0_8_version.txt"
