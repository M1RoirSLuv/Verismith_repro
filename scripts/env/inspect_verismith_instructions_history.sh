#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/upstream/verismith"

echo "=== git log for experiments/instructions.md ==="
git log --date=iso --format='%h %ad %an %s' -- experiments/instructions.md | head -n 20

echo "=== blame lines 1-90 ==="
git blame --date=iso experiments/instructions.md | sed -n '1,90p'
