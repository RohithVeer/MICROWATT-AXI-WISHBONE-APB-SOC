#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VCD="$(find "$ROOT/verif/test_logs" "$ROOT/test_logs" -type f -name '*.vcd' -print0 2>/dev/null | xargs -0 ls -1 -t 2>/dev/null | head -n1 || true)"
if [ -z "$VCD" ]; then
  echo " No VCD found in verif/test_logs or test_logs. Run a simulation that generates a VCD first."
  exit 1
fi
echo "Using VCD: $VCD"
echo "Opening GTKWave — use File → Save Waveform Save File to create a .gtkw with your preferred view."
gtkwave "$VCD" &

