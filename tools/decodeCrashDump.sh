#!/bin/bash

DUMPFILE="$1"
TOOLSDIR=$(dirname "$0")
SYMSDIR=$TOOLSDIR/../syms
OUTPUTFILE=$(dirname "$DUMPFILE")/$(basename "$DUMPFILE" .dmp).txt
MODULENAME="QGC-Gov" # Generic name

$TOOLSDIR/minidump_stackwalk -s -c "$DUMPFILE" "$SYMSDIR" 2>/dev/null > "$OUTPUTFILE"

if grep -q "No symbols, .*$MODULENAME.*" "$OUTPUTFILE"; then
    MODULEID=$(grep -P "No symbols, .*$MODULENAME.*" "$OUTPUTFILE" | grep -Po "[0-9A-F]{33}")
    echo "WARNING: No debug symbols found for $MODULENAME with module-id $MODULEID"
fi

