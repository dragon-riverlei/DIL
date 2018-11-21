#!/usr/local/bin/bash

# Return an enumeration of values that appear in the IPO info.
# For the value of a field that matches the given regular expression, the name of the field plus " yes" are returned
# For the value of a field that does NOT match the given regular expression, the name of the field plus the literal value are returned.
# By doing do, we can conclude all the possible values in the IPO info.

usage(){
    echo "usage:"
    echo "check_stock_ipo_info_values.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"

cat feeds/stock_ipo_info_china.jl | jq -r -f "$DIL_ROOT"/sh/check_stock_ipo_info_values.jq | awk -F ',' '{for (i=1; i<=NF; i++){print $i}}' | sort | uniq -c
