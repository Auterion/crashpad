#!/bin/bash

DUMPFILE="$1"
MODULENAME="${2:-QGC-Gov}"  # Use second argument if provided; else default to "QGC-Gov"

TOOLSDIR=$(dirname "$0")
SYMSDIR=$TOOLSDIR/../syms
OUTPUTFILE=$(dirname "$DUMPFILE")/$(basename "$DUMPFILE" .dmp).txt

$TOOLSDIR/minidump_stackwalk -s -c "$DUMPFILE" "$SYMSDIR" 2>/dev/null > "$OUTPUTFILE"

if grep -q "No symbols, .*$MODULENAME.*" "$OUTPUTFILE"; then
    MODULEID=$(grep -P "No symbols, .*$MODULENAME.*" "$OUTPUTFILE" | grep -Po "[0-9A-F]{33}")
    echo "WARNING: No debug symbols found for $MODULENAME with module-id $MODULEID"
elif ! grep -q "$MODULENAME\b" "$OUTPUTFILE"; then
    echo "WARNING: No module named $MODULENAME found in the dump file. Please pass the correct module name as the second argument."
fi

