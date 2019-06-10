#!/usr/local/bin/bash

# Returns empty if the check is passed.
# Returns a diff between the expected and the actual.

usage(){
    echo "usage:"
    echo "check_cash_flow_sheet_securities.sh <file_list>"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

jqf="$DIL_ROOT"/tmp/check_cash_flow_sheet_securities.jq
rm -rf "$jqf"

"$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -c cfs securities > "$jqf"

while (($#>0));do
    if [ -f "$1" ];then
        "$DIL_ROOT"/sh/print_distinct_jq_processed_values.sh "$jqf" "$1"
    else
        echo "File not found: $1."
    fi
    shift
done