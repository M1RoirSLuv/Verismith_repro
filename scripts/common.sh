#!/usr/bin/env bash

# Shared path helper for reproduction scripts.
# Override REPRO_ROOT when running from a copied or relocated workspace.
if [[ -z "${REPRO_ROOT:-}" ]]; then
  _common_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPRO_ROOT="$(cd "${_common_dir}/.." && pwd)"
fi

export REPRO_ROOT
