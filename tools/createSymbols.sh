#!/bin/bash

BINARY="$1"
TOOLSDIR=$(dirname "$0")
OUTPUTDIR=$TOOLSDIR/../syms

# Run dump_syms, output to temp.sym
mkdir -p $OUTPUTDIR
$TOOLSDIR/dump_syms $BINARY > $OUTPUTDIR/temp.sym

# Extract the module info from the first line of temp.sym
MODULEID=$(head -1 $OUTPUTDIR/temp.sym | grep -Po "[0-9A-F]{33}")
MODULENAME=$(head -1 $OUTPUTDIR/temp.sym | grep -Po "(?<=[0-9A-F]{33}\s).*?(?=.debug|$)")

# Move the .sym file to the appropriate location
mkdir -p $OUTPUTDIR/$MODULENAME/$MODULEID
mv $OUTPUTDIR/temp.sym $OUTPUTDIR/$MODULENAME/$MODULEID/$MODULENAME.sym

