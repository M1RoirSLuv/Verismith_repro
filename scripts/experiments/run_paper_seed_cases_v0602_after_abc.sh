#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT"
export PATH=/home/m1roirs/.ghcup/bin:/home/m1roirs/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

verismith_bin=/home/m1roirs/verismith_versions/0.6.0.2/bin/verismith

run_case() {
  local name="$1"
  local config="$2"
  local out_dir="$3"
  local log="$4"

  echo "=== ${name} ==="
  "${verismith_bin}" fuzz \
    -c "${config}" \
    -o "${out_dir}" \
    --keep \
    --no-reduction \
    > "${log}" 2>&1
  tail -n 80 "${log}"
}

run_case \
  "yosys_3333e002_mis_synthesis_seed" \
  "configs/config_yosys_3333e002_ms_seed_v0602.toml" \
  "fuzz_yosys_3333e002_ms_seed_v0602_abc" \
  "logs/fuzz_yosys_3333e002_ms_seed_v0602_abc.log"

run_case \
  "yosys_70d0f38_crash_seed" \
  "configs/config_yosys_70d0f38_crash_seed_v0602.toml" \
  "fuzz_yosys_70d0f38_crash_seed_v0602_abc" \
  "logs/fuzz_yosys_70d0f38_crash_seed_v0602_abc.log"

run_case \
  "yosys_3333e002_crash_seed_from_instructions" \
  "configs/config_yosys_3333e002_crash_seed_v0602.toml" \
  "fuzz_yosys_3333e002_crash_seed_v0602_abc" \
  "logs/fuzz_yosys_3333e002_crash_seed_v0602_abc.log"
