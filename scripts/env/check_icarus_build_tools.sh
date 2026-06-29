#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

for tool in git make g++ autoconf automake bison flex gperf pkg-config; do
  printf "%-10s " "${tool}"
  command -v "${tool}" || true
done
