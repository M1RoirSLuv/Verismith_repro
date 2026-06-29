#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/tools"
mkdir -p gperf_deb gperf_user
cd gperf_deb

if ! command -v gperf >/dev/null 2>&1; then
  apt-get download gperf
  deb="$(ls -1 gperf_*.deb | tail -n 1)"
  dpkg-deb -x "${deb}" ../gperf_user
fi

echo "local_gperf=$REPRO_ROOT/tools/gperf_user/usr/bin/gperf"
$REPRO_ROOT/tools/gperf_user/usr/bin/gperf --version | sed -n '1,3p'
