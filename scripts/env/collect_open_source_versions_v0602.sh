#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT"
export PATH=/home/m1roirs/.ghcup/bin:/home/m1roirs/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

{
  echo "=== OS ==="
  lsb_release -a 2>/dev/null || cat /etc/os-release

  echo "=== Verismith paper version ==="
  /home/m1roirs/verismith_versions/0.6.0.2/bin/verismith --version

  echo "=== Verismith default on PATH ==="
  command -v verismith || true
  verismith --version || true

  echo "=== GHC and Cabal ==="
  /home/m1roirs/.ghcup/bin/ghc --version
  /home/m1roirs/.ghcup/bin/cabal --version | head -n 2

  echo "=== Current checker Yosys ==="
  yosys --version

  echo "=== Historical Yosys builds ==="
  /home/m1roirs/yosys_versions/0.8/bin/yosys -V
  /home/m1roirs/yosys_versions/0.9/bin/yosys -V
  /home/m1roirs/yosys_versions/3333e002/bin/yosys -V
  /home/m1roirs/yosys_versions/70d0f38/bin/yosys -V

  echo "=== Exact Yosys bug-commit builds ==="
  for ybin in \
    /home/m1roirs/yosys_versions/09467bb9/bin/yosys \
    /home/m1roirs/yosys_versions/92dde319/bin/yosys \
    /home/m1roirs/yosys_versions/acd8bc0a/bin/yosys \
    /home/m1roirs/yosys_versions/0466c485/bin/yosys
  do
    if [[ -x "$ybin" ]]; then
      "$ybin" -V
    fi
  done

  echo "=== Fixed Yosys bug-commit builds ==="
  for ybin in \
    /home/m1roirs/yosys_versions/b37c31e/bin/yosys \
    /home/m1roirs/yosys_versions/33738c1/bin/yosys \
    /home/m1roirs/yosys_versions/349c472/bin/yosys \
    /home/m1roirs/yosys_versions/39f4c10/bin/yosys \
    /home/m1roirs/yosys_versions/4b18a45/bin/yosys
  do
    if [[ -x "$ybin" ]]; then
      "$ybin" -V
    fi
  done

  echo "=== Icarus Verilog ==="
  iverilog -V 2>&1 | head -n 6
  if [[ -x /home/m1roirs/iverilog_versions/10.3/bin/iverilog ]]; then
    echo "=== Icarus Verilog 10.3 ==="
    /home/m1roirs/iverilog_versions/10.3/bin/iverilog -V 2>&1 | head -n 6
  fi

  echo "=== SymbiYosys, Z3, ABC ==="
  sby --version 2>&1 | head -n 3 || true
  z3 --version || true
  yosys-abc -h 2>&1 | head -n 3 || true
} | tee logs/open_source_tool_versions_v0602.txt
