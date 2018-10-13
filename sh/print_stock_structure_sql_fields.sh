#!/usr/local/bin/bash

# Print all the fields appeared in any of the stock structure files.

usage(){
    echo "usage:"
    echo "print_stock_structure_sql_fields.sh_structure_sql_fields.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"/feeds/stock_structure

for f in $(ls schemas/*); do cat $f; done | sort | uniq -c | sort -r | sed 's/(/（/g' | sed 's/)/）/g' | sed 's/:/：/g' | sed 's/"//g' | awk '{print $2 " numeric(20,2) not null,"}'
