#!/usr/local/bin/bash

# Check scraped stock structure to see if all rows have the same length.

usage(){
    echo "usage:"
    echo "check_regular_stock_structure_values.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"
cd feeds/stock_structure/data

ls | sed 's/.jl//g' | xargs -P 4 -I '{}' jq --arg code _{} -r '.ShareChangeList[]? | .changeList | length | tostring + $code' {}.jl > "$DIL_ROOT"/tmp/check_regular_stock_structure_values_codes
cat "$DIL_ROOT"/tmp/check_regular_stock_structure_values_codes | sort | uniq | awk -F "_" '{print $2}' | sort | uniq -c | awk '$1!="1" {print $2}'
