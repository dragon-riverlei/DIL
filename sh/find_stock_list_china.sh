#!/usr/local/bin/bash

# Return a list of code from table securities_code.

usage(){
    echo "usage:"
    echo "find_stock_list_china.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

psql "$db" -t <<EOF | awk '{print $1}'
select code from securities_code;
EOF
