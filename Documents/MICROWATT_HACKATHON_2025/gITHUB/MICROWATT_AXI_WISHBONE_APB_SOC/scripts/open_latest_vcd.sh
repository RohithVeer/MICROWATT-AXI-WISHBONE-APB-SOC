#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SEARCH=("$ROOT/verif/test_logs" "$ROOT/test_logs" "$ROOT/verif" "$ROOT")
VCD=""

for d in "${SEARCH[@]}"; do
  if [ -d "$d" ]; then
    cand=$(find "$d" -type f -name '*.vcd' -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | awk '{print $2}')
    if [ -n "${cand:-}" ]; then
      VCD="$cand"
      break
    fi
  fi
done

if [ -z "$VCD" ]; then
  echo "No .vcd files found in ${SEARCH[*]}"
  exit 1
fi

if ! command -v gtkwave >/dev/null 2>&1; then
  echo "gtkwave not installed or not on PATH. Run: gtkwave '$VCD' manually."
  exit 1
fi

echo "Opening $VCD in gtkwave ..."
gtkwave "$VCD" &

