#!/usr/local/bin/bash

# Return a list of code for which the regular stock structure report of the given year is not scraped yet.
# The list of code is the ones in feeds/stock_list_china.jl
# but neither in "$subfolder"/code_missed nor "$subfolder"/code_with_absent_regular_report.
# year=2017 is used for invoking sh/find_stock_list_china_with_absence_regular_report.sh
# since the initial regular reports are scraped in first half of 2018.

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
sh/find_stock_list_china_with_absence_regular_report.sh > "$subfolder"/code_with_absent_regular_report
codes_to_report=$(cat "$subfolder"/code_missed "$subfolder"/code_with_absent_regular_report "$subfolder"/code_with_absent_regular_report | sort | uniq -u | paste -s -d "|" -)
if [ ! $codes_to_report == "" ];then
    cat feeds/stock_list_china.jl | ag $codes_to_report | jq -r 'if .market=="Shanghai" then "sh" else "sz" end + .code'
fi
