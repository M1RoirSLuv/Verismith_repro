#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/upstream/yosys_0_9"

for rev in 09467bb9 92dde319 acd8bc0a 0466c485 70d0f38; do
  printf "%s " "$rev"
  git cat-file -t "$rev" 2>/dev/null || echo "missing"
done
