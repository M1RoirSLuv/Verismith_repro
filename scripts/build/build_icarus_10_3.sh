#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "${SCRIPT_DIR}/.." && pwd)/common.sh"

cd "$REPRO_ROOT/upstream"
export PATH=$REPRO_ROOT/tools/gperf_user/usr/bin:${PATH}
export CFLAGS="-fcommon"

archive=iverilog_v10_3.tar.gz
src=iverilog-10_3
prefix=/home/m1roirs/iverilog_versions/10.3
log=$REPRO_ROOT/logs/icarus_10_3_build.log

rm -rf "${src}"
tar -xzf "${archive}"

cd "${src}"

{
  echo "=== source ==="
  pwd
  echo "=== autoconf ==="
  sh autoconf.sh
  echo "=== configure ==="
  ./configure --prefix="${prefix}"
  echo "=== patch modern bison header handling ==="
  python3 - <<'PY'
from pathlib import Path

old = "mv parse.cc.h $@ 2>/dev/null || mv parse.hh $@"
new = "if test -f parse.cc.h; then cp parse.cc.h $@; cp parse.cc.h parse.hh; else cp parse.hh $@; fi"
old_fp = "mv fp.cc.h $@ 2>/dev/null || mv fp.hh $@"
new_fp = "if test -f fp.cc.h; then cp fp.cc.h $@; cp fp.cc.h fp.hh; else cp fp.hh $@; fi"
changed = []
for path in Path(".").glob("**/Makefile"):
    text = path.read_text()
    if old in text:
        text = text.replace(old, new)
    if old_fp in text:
        text = text.replace(old_fp, new_fp)
    if text != path.read_text():
        path.write_text(text)
        changed.append(str(path))
if not changed:
    raise SystemExit("expected parse header rule not found")
print("\n".join(changed))
PY
  echo "=== make ==="
  make -j"$(nproc)"
  echo "=== install ==="
  make install
  echo "=== version ==="
  "${prefix}/bin/iverilog" -V | sed -n '1,6p'
} 2>&1 | tee "${log}"
