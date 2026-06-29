#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

if [ "$#" -ne 3 ]; then
  echo "usage: $0 <rev> <worktree_name> <install_name>" >&2
  exit 2
fi

REV="$1"
WORKTREE_NAME="$2"
INSTALL_NAME="$3"

ROOT="$REPRO_ROOT"
BASE="$ROOT/upstream/yosys_0_9"
SRC="$ROOT/upstream/$WORKTREE_NAME"
PREFIX="/home/m1roirs/yosys_versions/$INSTALL_NAME"
LOG="$ROOT/logs/${WORKTREE_NAME}_build.log"
VERSION_LOG="$ROOT/logs/${WORKTREE_NAME}_version.txt"

if [ ! -d "$SRC/.git" ]; then
  cd "$BASE"
  git worktree add "../$WORKTREE_NAME" "$REV"
fi

cd "$SRC"
make config-gcc > "$LOG" 2>&1
{
  echo ""
  echo "ENABLE_ABC := 0"
} >> Makefile.conf

if [ -f passes/sat/freduce.cc ] && ! grep -q "#include <limits>" passes/sat/freduce.cc; then
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
"$PREFIX/bin/yosys" -V > "$VERSION_LOG"
cat "$VERSION_LOG"
