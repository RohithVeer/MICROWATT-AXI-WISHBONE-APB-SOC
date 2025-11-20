#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="/home/rv/Documents/MICROWATT_HACKATHON_2025/MICROWATT_AXI_WISHBONE_APB_SOC"
SEARCH_DIRS=( "$PROJECT_ROOT/verif" "$PROJECT_ROOT/verif/tb" )
VCD_BLOCK='
    // --- inserted by helper: unique hierarchical VCD dump ---
    reg [1023:0] vcdfile;
    initial begin
        if ($value$plusargs("vcd=%s", vcdfile)) begin end
        else begin
            vcdfile = $getenv("VCD_FILE");
            if (vcdfile == "") vcdfile = "dump.vcd";
        end
        $display("VCD: %0s", vcdfile);
        $dumpfile(vcdfile);
        $dumpvars(0, soc_top); // FULL hierarchy
    end
    // --- end inserted block ---
'

echo "Searching for verilog testbenches that reference 'soc_top'..."
files=()
for d in "${SEARCH_DIRS[@]}"; do
  [ -d "$d" ] || continue
  while IFS= read -r -d '' f; do
    files+=( "$f" )
  done < <(grep -IlR --exclude-dir=.git --exclude-dir=.venv "soc_top" "$d" 2>/dev/null | tr '\n' '\0' || true)
done

if [ ${#files[@]} -eq 0 ]; then
  echo "No files referencing 'soc_top' were found under verif/. Nothing changed."
  exit 0
fi

for f in "${files[@]}"; do
  echo "Processing: $f"
  if grep -qE '\$dumpfile|\$dumpvars' "$f"; then
    echo "  -> already has dumpfile/dumpvars. Skipping."
    continue
  fi
  cp -v "$f" "$f.bak"
  # find first 'module' line before first occurrence of soc_top
  soc_line=$(grep -n "soc_top" "$f" | head -n1 | cut -d: -f1 || true)
  if [ -z "$soc_line" ]; then
    module_line=1
  else
    module_line=$(nl -ba "$f" | sed -n "1,${soc_line}p" | grep -n "^ *module " | tail -n1 | cut -f1 -d: || true)
    [ -n "$module_line" ] || module_line=1
  fi
  awk -v ins="$VCD_BLOCK" -v lineno="$module_line" '{
    print $0
    if (NR==lineno) print ins
  }' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  echo "  -> inserted VCD block after line $module_line (backup at $f.bak)"
done

echo "Done. Review edits and run scripts/run_all_tests.sh"

