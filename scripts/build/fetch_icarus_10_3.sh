#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/upstream"

repo=https://github.com/steveicarus/iverilog.git
log=$REPRO_ROOT/logs/icarus_10_3_fetch.log

{
  echo "=== ls-remote tags containing 10 ==="
  git ls-remote --tags "${repo}" | grep -E 'v10|10_3|10-3|10\.3' || true

  echo "=== clone candidates ==="
  if [[ ! -d iverilog ]]; then
    git clone --depth 1 --branch v10_3 "${repo}" iverilog \
      || git clone --depth 1 --branch v10-3 "${repo}" iverilog \
      || git clone --depth 1 --branch v10_3_0 "${repo}" iverilog \
      || git clone --depth 1 "${repo}" iverilog
  fi

  cd iverilog
  git rev-parse --short HEAD
  git tag -l | grep -E 'v10|10_3|10-3|10\.3' || true
} 2>&1 | tee "${log}"
