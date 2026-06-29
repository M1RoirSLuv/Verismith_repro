#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/upstream/yosys_0_9"

for rev in b37c31e 33738c1 349c472 39f4c10 4b18a45; do
  printf "%s " "$rev"
  git cat-file -t "$rev" 2>/dev/null || echo "missing"
done
