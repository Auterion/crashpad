# QGC Crashpad Integration

## Overview

[Crashpad](https://chromium.googlesource.com/crashpad/crashpad/+/master/README.md) is a crash-reporting system which allows post-crash analysis of stack traces and memory dumps. This repository contains the crashpad library pre-built in the needed configuration.

Crashpad requires two pieces to work: the debugging symbols produced during a build, and a memory dump when the crash occurs.

## AMC Integration

*To-do*

## QGC-Gov Integration

### TL;DR

1. When a crash occurs, copy the dump file found in the QGC-Gov folder.
    + `[Documents]/QGC-GOV/CrashLogs/pending/7d62d17e-047b-420a-8ed0-c99c2b52fdd3.dmp`.
1. Run the `decodeCrashDump.sh` script on it.
    + `./libs/crashpad/tools/decodeCrashDump.sh ~/Downloads/7d62d17e-047b-420a-8ed0-c99c2b52fdd3.dmp`
    + If a warning is produced, then you do not have the correct debugging symbols and will need to get them from the computer that compiled this version of QGC-Gov.
        + `WARNING: No debug symbols found for QGC-Gov with module-id 857B2F54F944EF178E06EBB0470DB3DC0`
1. Examine the resulting file for stack trace information.
    + `~/Downloads/7d62d17e-047b-420a-8ed0-c99c2b52fdd3.txt`

### Usage

*Note that all scripts are currently set up to be run on a Linux host / compiler computer.*

#### Creating debug symbols

QGC-Gov is configured to produce and store debug symbols for each build. These are stored locally on the computer which performed the compilation and linking. They are located at `[QGC-Gov]/libs/crashpad/syms/*.sym`. This is done automatically for each build of QGC-Gov with the `createSymbols.sh` script.

If you need to manually create these debug symbols, the `dump_syms` tool (part of the crashpad library) must be called with the QGC_Gov binary as an argument. The resulting symbols can be piped into an output file. It must be stored in a directory structure `[module name]/[module id]/[module name].sym`. The module information can be found in the first line of the symbol file.

#### Decoding crash dumps

Once a crash occurs, a dump file (`*.dmp`) is created in the QGC-Gov crash logs directory (usually `[Documents]/QGC-GOV/CrashLogs/`). In QGC-Gov, crashpad is not configured to upload these anywhere, so dumps will usually remain in the `pending/` directory. (See [Bugsplat](#bugsplat) below.) A dump file can be copied off the target hardware for later analysis, if necessary.

To decode a dump, run the `decodeCrashDump.sh` script (found in `[QGC-Gov]/libs/crashpad/tools/`) with the `.dmp` file as an argument. A corresponding ``.txt`` file will be placed in the same directory as the input `.dmp` file. This file contains the decoded call stack and memory information at the time the crash occured.

The aforementioned debug symbols for the particular build of QGC-Gov which caused the crash must be present on the computer which is doing the decoding. If they are not, a warning will be produced, and the resulting `.txt` will not be complete.

### Bugsplat

Crashpad is designed to work hand-in-hand with Bugsplat, an online bug reporting service. Crashpad contains several features to automatically upload and decode crash dumps online. However, due to the offline and secure nature of QGC-Gov, Bugsplat will not be used.
