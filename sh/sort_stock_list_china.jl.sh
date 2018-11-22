#!/usr/local/bin/bash

# Sort feeds/stock_list_china.jl by code.

usage(){
    echo "usage:"
    echo "sort_stock_list_china.jl.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"

cat feeds/stock_list_china.jl | sort -k 4 > feeds/stock_list_china.jl.new
rm feeds/stock_list_china.jl
mv feeds/stock_list_china.jl.new feeds/stock_list_china.jl
