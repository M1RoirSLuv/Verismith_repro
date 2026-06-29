#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/upstream/iverilog"
log=$REPRO_ROOT/logs/icarus_10_3_checkout.log

{
  echo "=== fetch tags ==="
  git fetch --tags --force origin

  echo "=== candidate tags ==="
  git tag -l | grep -E 'v10|10_3|10-3|10\.3' || true

  for tag in v10_3 v10-3 v10_3_0; do
    if git rev-parse -q --verify "refs/tags/${tag}" >/dev/null; then
      echo "checkout_tag=${tag}"
      git checkout -f "${tag}"
      git rev-parse --short HEAD
      exit 0
    fi
  done

  echo "no_10_3_tag_found"
  exit 2
} 2>&1 | tee "${log}"
