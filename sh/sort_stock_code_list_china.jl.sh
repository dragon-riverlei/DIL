#!/usr/local/bin/bash

# Sort feeds/stock_code_list_china.jl by code.

usage(){
    echo "usage:"
    echo "sort_stock_code_list_china.jl.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"

paste <(cat feeds/stock_code_list_china.jl | awk -F "\"" '{print $4}' | sed 's/[a-z]*//g') <(cat feeds/stock_code_list_china.jl) | sort -k 1 | cut -f 2,3 > feeds/stock_code_list_china.jl.new
rm feeds/stock_code_list_china.jl
mv feeds/stock_code_list_china.jl.new feeds/stock_code_list_china.jl
