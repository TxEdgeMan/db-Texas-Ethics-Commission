#!/usr/bin/env bash
## Purpose: Fix missing commActivityName column in CFS-Readme.txt file
## Usage: ./purpose_csv_fix.sh <file>
## This script uses awk to insert the missing commActivityName column definition
## after the activitySeekOfficeCountyDescr column definition in the CFS-Readme.txt file
## into the appropriate section of 06_c_CoverSheet3Data.sql 
set -euo pipefail

[[ $# -ne 1 ]] && { echo "Usage: $0 <file>"; exit 1; }

INPUT_FILE="$1"
TMP_FILE="${INPUT_FILE}.tmp.$$"

awk '
BEGIN {
    start_re = "^[[:space:]]*activitySeekOfficeCountyDescr[[:space:]]+text,"
    end_re   = "^[[:space:]]*PRIMARY KEY[[:space:]]*\\(committeeActivityId\\)"
    target_re= "^[[:space:]]*commActivityName[[:space:]]+text,"

    target_line = "        commActivityName       text,"

    in_block = 0
    found = 0
}
{
    if ($0 ~ start_re) {
        in_block = 1
        found = 0
    }

    if (in_block) {
        if ($0 ~ target_re) {
            found = 1
        }

        if ($0 ~ end_re) {
            if (!found) {
                print target_line
            }
            in_block = 0
        }
    }

    print
}
' "$INPUT_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$INPUT_FILE"