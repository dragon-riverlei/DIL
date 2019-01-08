#!/usr/local/bin/bash

# Return a list of code for which the regular stock structure report of the given year is not scraped yet.

usage(){
    echo "usage:"
    echo "find_regular_report_not_scraped_stock_structure.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

subfolder=feeds/stock_structure

cd $DIL_ROOT
for code in `cat feeds/stock_list_china.jl | jq -r '.code'`
do
    f="$subfolder"/data/"$code".jl
    if [ ! -e "$f" ];then
        echo $code
    fi
done > "$subfolder"/code_missed
codes_to_report=$(cat "$subfolder"/code_missed | sort | uniq -u | paste -s -d "|" -)
if [ ! $codes_to_report == "" ];then
    cat feeds/stock_list_china.jl | ag $codes_to_report | jq -r 'if .market=="Shanghai" then "sh" else "sz" end + .code'
fi
rm "$subfolder"/code_missed
