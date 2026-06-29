#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

prefixes=(
  /home/m1roirs/yosys_versions/0.8/bin
  /home/m1roirs/yosys_versions/0.9/bin
  /home/m1roirs/yosys_versions/3333e002/bin
  /home/m1roirs/yosys_versions/70d0f38/bin
)

abc_path="$(command -v yosys-abc)"
echo "system_yosys_abc=${abc_path}"

for prefix in "${prefixes[@]}"; do
  echo "=== ${prefix} ==="
  if [[ -e "${prefix}/yosys-abc" || -L "${prefix}/yosys-abc" ]]; then
    ls -l "${prefix}/yosys-abc"
  else
    echo "missing"
  fi
  ln -sfn "${abc_path}" "${prefix}/yosys-abc"
  ls -l "${prefix}/yosys-abc"
done
