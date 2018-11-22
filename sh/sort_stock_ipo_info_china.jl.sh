#!/usr/local/bin/bash

# Sort feeds/stock_ipo_info_china.jl by ipo_time, found_time and code.

usage(){
    echo "usage:"
    echo "sort_stock_ipo_info_china.jl.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"

cat feeds/stock_ipo_info_china.jl | sort -k 14 -k 2 -k 4 | jq -r -c '{"ipo_time":.ipo_time, "found_time": .found_time, "code": .code, "ipo_price": .ipo_price, "ipo_volume": .ipo_volume, "ipo_cap": .ipo_cap, "ipo_per": .ipo_per}' > feeds/stock_ipo_info_china.jl.new
rm feeds/stock_ipo_info_china.jl
mv feeds/stock_ipo_info_china.jl.new feeds/stock_ipo_info_china.jl
