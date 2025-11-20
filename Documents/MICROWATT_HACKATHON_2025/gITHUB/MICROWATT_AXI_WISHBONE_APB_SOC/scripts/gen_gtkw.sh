#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SEARCH_DIRS=( "$ROOT/verif/test_logs" "$ROOT/test_logs" "$ROOT/verif" "$ROOT" )

VCD_PATH=""
for d in "${SEARCH_DIRS[@]}"; do
  if [ -d "$d" ]; then
    # find newest .vcd under directory
    newest=$(find "$d" -type f -name '*.vcd' -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | awk '{print $2}')
    if [ -n "${newest:-}" ]; then
      VCD_PATH="$newest"
      break
    fi
  fi
done

if [ -z "$VCD_PATH" ]; then
  echo " No VCD found in search paths: ${SEARCH_DIRS[*]}. Run a test that generates a VCD first (e.g. test_sram)."
  exit 1
fi

echo " Found VCD: $VCD_PATH"

# If there is an existing gen_37_gtkw.sh in scripts, try to use it (keeps your old logic)
if [ -x "$ROOT/scripts/gen_37_gtkw.sh" ]; then
  echo "Using existing scripts/gen_37_gtkw.sh to create a .gtkw session..."
  # call with VCD path if your script supports it
  "$ROOT/scripts/gen_37_gtkw.sh" "$VCD_PATH" && exit 0 || echo "gen_37_gtkw.sh returned non-zero; falling back to open-only mode."
fi

# Fall back: open the VCD in gtkwave so you can save the session manually
echo "Opening GTKWave with the VCD. If you want an automatic .gtkw session saved, add a gen_37_gtkw.sh script that accepts a VCD path."
if command -v gtkwave >/dev/null 2>&1; then
  # Try to open GTKWave in background
  gtkwave "$VCD_PATH" &
  echo "GTKWave started. To save all signals into a .gtkw file: Window→Save Settings (or File→Save) once GTKWave shows signals."
else
  echo "gtkwave not found on PATH. Install GTKWave or run 'gtkwave $VCD_PATH' manually."
  exit 1
fi

