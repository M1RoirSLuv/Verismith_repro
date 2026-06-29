#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT"

export PATH="/home/m1roirs/.local/bin:${PATH}"
VERISMITH=/home/m1roirs/verismith_versions/0.6.0.2/bin/verismith
mkdir -p logs

for size in 20 30 40; do
  config="configs/config_yosys_0_9_size${size}_n2_v0602.toml"
  out="fuzz_yosys_0_9_size${size}_n2_sby_v0602"
  log="logs/fuzz_yosys_0_9_size${size}_n2_sby_v0602.log"
  echo "=== size=${size}, n=2, yosys 0.9, PATH includes sby ===" | tee "${log}"
  command -v sby | tee -a "${log}"
  "${VERISMITH}" fuzz -c "${config}" -n 2 -o "${out}" --keep --no-reduction 2>&1 | tee -a "${log}"
  echo "size_${size}_exit_code=${PIPESTATUS[0]}" | tee -a "${log}"
done
