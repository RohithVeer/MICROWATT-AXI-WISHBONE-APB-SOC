#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERIF="$ROOT/verif"

echo "Cleaning sim builds, VCDs and logs under $VERIF ..."
rm -rf "$VERIF"/sim_build_* 2>/dev/null || true
rm -f "$VERIF"/test_logs/*.vcd 2>/dev/null || true
rm -f "$VERIF"/test_logs/run_*.log 2>/dev/null || true
# also optional top-level test_logs
rm -f "$ROOT"/test_logs/*.vcd 2>/dev/null || true
rm -f "$ROOT"/test_logs/run_*.log 2>/dev/null || true
echo "Clean done."

