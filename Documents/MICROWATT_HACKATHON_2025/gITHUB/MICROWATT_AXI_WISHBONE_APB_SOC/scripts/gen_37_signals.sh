#!/usr/bin/env bash
set -euo pipefail

VCD_PATH="$1"
OUT="$2"  # output file for list
if [ -z "$VCD_PATH" ] || [ -z "$OUT" ]; then
  echo "Usage: $0 <path/to/dump.vcd> <out_signals.txt>"
  exit 2
fi
if [ ! -f "$VCD_PATH" ]; then
  echo "VCD not found: $VCD_PATH"
  exit 1
fi

# get hierarchical signal names from $scope / $var lines
grep -n "^\$scope\|^\$var" "$VCD_PATH" > /dev/null 2>&1 || true

# collect var lines with scope path (rudimentary)
python3 - <<PY
import re,sys
vcd="$VCD_PATH"
out="$OUT"
signals=[]
scope_stack=[]
with open(vcd,"r",errors="ignore") as f:
    for line in f:
        line=line.rstrip("\n")
        if line.startswith("$scope"):
            # $scope module name $end
            parts=line.split()
            if len(parts)>=3:
                scope_stack.append(parts[2])
        elif line.startswith("$upscope"):
            if scope_stack: scope_stack.pop()
        elif line.startswith("$var"):
            parts=line.split()
            # var syntax: $var <type> <size> <id> <ref> $end
            # ref may be hierarchicalless; we join with scope_stack
            ref_idx=4
            if len(parts) > ref_idx:
                refname=" ".join(parts[ref_idx:-1])
                full=".".join(scope_stack + [refname])
                signals.append(full)
        elif line.startswith("$enddefinitions"):
            break
# unique preserve order
seen=set()
uniq=[]
for s in signals:
    if s not in seen:
        uniq.append(s); seen.add(s)
# write first 37
with open(out,"w") as fo:
    for s in uniq[:37]:
        fo.write(s+"\n")
print("Wrote", min(37,len(uniq)), "signals to", out)
PY

