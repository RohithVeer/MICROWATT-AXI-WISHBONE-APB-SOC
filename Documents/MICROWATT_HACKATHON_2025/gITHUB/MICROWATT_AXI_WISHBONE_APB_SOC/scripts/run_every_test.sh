#!/usr/bin/env bash
# scripts/run_every_test.sh
# Run all cocotb/python tests under verif/ one-by-one, capture logs and print summary.
# Usage: from repo root: ./scripts/run_every_test.sh

set -euo pipefail

REPO_ROOT="$(pwd)"
VERIF_DIR="$REPO_ROOT/verif"
LOG_DIR="$VERIF_DIR/test_logs"
VENV_PY="$REPO_ROOT/.venv/bin/python"

mkdir -p "$LOG_DIR"

# find candidate test files (you can change the pattern)
mapfile -t files < <(find "$VERIF_DIR" -type f -name "test_*.py" -o -name "*_test.py" | sort)

if [ ${#files[@]} -eq 0 ]; then
  echo "No test files found under $VERIF_DIR"
  exit 1
fi

echo "Found ${#files[@]} test files. Running them one-by-one..."
echo

declare -A results
i=0
for fpath in "${files[@]}"; do
  ((i++))
  rel="${fpath#$VERIF_DIR/}"        # path relative to verif/
  dir="$(dirname "$rel")"          # relative dir inside verif (maybe ".")
  base="$(basename "$rel" .py)"    # file base name without .py

  # Decide MODULE and PYTHONPATH for this test so cocotb can import it.
  # Strategy:
  # 1) If file is directly in verif/ -> export PYTHONPATH=verif and MODULE=basename
  # 2) Else if the subdirectory chain has __init__.py files up to verif -> use dotted package path
  # 3) Else add the file's containing directory to PYTHONPATH and MODULE=basename

  module=""
  extra_py_path=""
  if [ "$dir" = "." ] || [ "$dir" = "" ]; then
    module="$base"
    extra_py_path="$VERIF_DIR"
  else
    # check if every ancestor from VERIF_DIR/dir down to dir contains __init__.py
    IFS='/' read -r -a parts <<< "$dir"
    check_path="$VERIF_DIR"
    all_pkg=true
    dotted=""
    for part in "${parts[@]}"; do
      check_path="$check_path/$part"
      if [ ! -f "$check_path/__init__.py" ]; then
        all_pkg=false
        break
      fi
      if [ -z "$dotted" ]; then
        dotted="$part"
      else
        dotted="$dotted.$part"
      fi
    done

    if [ "$all_pkg" = true ]; then
      module="${dotted}.${base}"
      extra_py_path="$VERIF_DIR"   # repo/verif on PYTHONPATH so dotted import works
    else
      module="$base"
      extra_py_path="$VERIF_DIR/$dir"  # add the directory containing the file
    fi
  fi

  log_file="$LOG_DIR/run_${module}.log"
  echo "[$i/${#files[@]}] Running module='$module' (file='$rel') -> log='$log_file'"

  # run make from verif using the same pattern cocotb uses, but ensure PYTHONPATH and venv are used.
  # we run in a subshell so env changes don't leak
  (
    export PYTHONPATH="$extra_py_path:$PYTHONPATH"
    export PATH="$REPO_ROOT/.venv/bin:$PATH"
    cd "$VERIF_DIR"
    echo "=== START $module ===" > "$log_file"
    echo "PYTHONPATH=$PYTHONPATH" >> "$log_file"
    echo "Invoking: make MODULE=$module" >> "$log_file"
    # run make and tee output to log, keep exit code
    if make MODULE="$module" 2>&1 | tee -a "$log_file"; then
      echo "=== PASS: $module ===" | tee -a "$log_file"
      exit 0
    else
      echo "=== FAIL: $module ===" | tee -a "$log_file"
      exit 2
    fi
  )
  rc=$?
  if [ $rc -eq 0 ]; then
    results["$module"]="PASS"
  else
    results["$module"]="FAIL (code $rc)"
  fi
done

echo
echo "=== TEST SUMMARY ==="
for fpath in "${files[@]}"; do
  rel="${fpath#$VERIF_DIR/}"
  base="$(basename "$rel" .py)"
  log="$LOG_DIR/run_${base}.log"

  if grep -q "=== PASS" "$log"; then
    echo "$base : PASS"
  else
    echo "$base : FAIL"
  fi
done

