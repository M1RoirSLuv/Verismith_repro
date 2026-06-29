#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

echo "=== binary ==="
command -v iverilog || true

echo "=== version ==="
iverilog -V 2>&1 | sed -n '1,6p'

echo "=== package owner ==="
iverilog_bin="$(command -v iverilog || true)"
if [[ -n "${iverilog_bin}" ]]; then
  dpkg -S "${iverilog_bin}" || true
fi

echo "=== apt policy ==="
apt-cache policy iverilog | sed -n '1,20p'

echo "=== apt history grep ==="
grep -R 'Install:.*iverilog\|Commandline:.*iverilog' \
  /var/log/apt/history.log /var/log/apt/history.log.* 2>/dev/null | tail -n 20 || true
