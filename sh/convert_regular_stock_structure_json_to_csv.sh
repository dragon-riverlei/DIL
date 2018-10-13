#!/usr/local/bin/bash

# Convert scraped stock structure from json format to csv format.

usage(){
    echo "usage:"
    echo "convert_regular_stock_structure_json_to_csv.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"
cd feeds/stock_structure/data
mkdir ../dbdata

ls | sed 's/.jl//g' | xargs -P 4 -I '{}' jq --arg code {} -r '.Result.ShareChangeList[]? | $code + "=" + .des? + "=" + .changeList[]?' {}.jl | sed '/变动原因/ s/,/，/g' | sed 's/,//g' > "$DIL_ROOT"/tmp/convert_regular_stock_structure_json_to_csv_data

awk -F "=" -v dir="$DIL_ROOT"/feeds/stock_structure/dbdata -f "$DIL_ROOT/sh/convert_regular_stock_structure_json_to_csv.awk" "$DIL_ROOT"/tmp/convert_regular_stock_structure_json_to_csv_data
