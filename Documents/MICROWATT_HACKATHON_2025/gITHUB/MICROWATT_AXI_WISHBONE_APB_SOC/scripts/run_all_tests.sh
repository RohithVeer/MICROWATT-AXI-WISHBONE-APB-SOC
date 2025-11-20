#!/usr/bin/env bash
set -euo pipefail
export PYTHONPATH="${PYTHONPATH:-}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERIF="$ROOT/verif"
LOGDIR="$VERIF/test_logs"
mkdir -p "$LOGDIR"

# -------------------------------------------------------
# Parse flags
# -------------------------------------------------------
DO_CLEAN=0
DO_GTKW=0

for arg in "$@"; do
    case "$arg" in
        --clean) DO_CLEAN=1 ;;
        --gtkw)  DO_GTKW=1 ;;
    esac
done

# -------------------------------------------------------
# Cleanup
# -------------------------------------------------------
if [[ $DO_CLEAN -eq 1 ]]; then
    echo "Cleaning previous sim_build_* and VCD..."
    rm -rf "$VERIF"/sim_build_* || true
    rm -f "$VERIF"/*.vcd "$LOGDIR"/*.vcd || true
fi

echo "===================="
echo "RUN START: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "===================="

# -------------------------------------------------------
# Discover tests
# -------------------------------------------------------
mapfile -t TEST_FILES < <(find "$VERIF/tb" -type f -name "test_*.py" | sort)

TESTS=()

for f in "${TEST_FILES[@]}"; do
    base="$(basename "$f" .py)"     # test_sram
    pkgdir="$(basename "$(dirname "$f")")"  # tb
    TESTS+=("${pkgdir}.${base}")    # tb.test_sram
done

echo "Discovered tests:"
printf '  %s\n' "${TESTS[@]}"
echo "TEST COUNT = ${#TESTS[@]}"
echo

if [[ ${#TESTS[@]} -eq 0 ]]; then
    echo "ERROR: No tests found. Exiting."
    exit 1
fi

# -------------------------------------------------------
# Build VERILOG_SOURCES list
# -------------------------------------------------------
VERILOG_SOURCES="$(find "$ROOT/rtl" -type f \( -name '*.v' -o -name '*.sv' \) -print0 | xargs -0 printf '%s ')"

# -------------------------------------------------------
# Run each test
# -------------------------------------------------------
for MODULE in "${TESTS[@]}"; do
    echo "-------------------------------------------------------"
    echo "Running test: $MODULE"
    echo "-------------------------------------------------------"

    SIM_BUILD_DIR="$VERIF/sim_build_${MODULE//./_}"
    mkdir -p "$SIM_BUILD_DIR"
    LOGFILE="$LOGDIR/run_${MODULE//./_}.log"

    (
        cd "$VERIF"
        echo "PYTHONPATH=$VERIF" > "$LOGFILE"
        PYTHONPATH="$VERIF:$PYTHONPATH" \
        VERILOG_SOURCES="$VERILOG_SOURCES" \
        SIM_BUILD="$SIM_BUILD_DIR" \
        COCOTB_RESOLVE_X=ZEROS \
        COCOTB_LOG_LEVEL=INFO \
        make -f "$(python3 - <<'EOF'
import cocotb, os
print(os.path.join(os.path.dirname(cocotb.__file__), "share/makefiles/Makefile.sim"))
EOF
        )" \
        MODULE="$MODULE" \
        TOPLEVEL=soc_top \
        SIM=icarus 2>&1 | tee -a "$LOGFILE"
    )

    echo
done

echo "=== DONE. Logs -> $LOGDIR ==="

# -------------------------------------------------------
# GTKWave
# -------------------------------------------------------
if [[ $DO_GTKW -eq 1 ]]; then
    echo "Opening latest VCD with GTKWave..."

    VCD=$(find "$VERIF" "$LOGDIR" -name '*.vcd' | sort | tail -1)

    if [[ -z "$VCD" ]]; then
        echo "No VCD found."
    else
        echo "Opening: $VCD"
        gtkwave "$VCD" &
    fi
fi

