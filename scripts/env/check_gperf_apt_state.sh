#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

echo "=== gperf ==="
command -v gperf || true

echo "=== apt processes ==="
ps -ef | grep -E 'apt|dpkg' | grep -v grep || true

echo "=== dpkg status ==="
dpkg -s gperf 2>/dev/null | sed -n '1,8p' || true
