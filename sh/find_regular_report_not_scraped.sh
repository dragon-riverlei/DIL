#!/usr/local/bin/bash

# Return a list of code for which the regular report of the given year is not scraped yet.
# The list of code is the ones in feeds/stock_list_china.jl
# but neither in "$subfolder"/code_missed nor "$subfolder"/code_with_absent_regular_report.

usage(){
    echo "usage:"
    echo "find_regular_report_not_scraped.sh <i|d> <bs|cfs|ps> <year>"
    echo ""
    echo "  i: initial"
    echo "  d: delta"
    echo ""
    echo "  bs: balance sheet"
    echo " cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  year: the year for which the regular report is to be scraped"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    d)
        suffix="delta"
        ;;
    i)
        suffix="initial"
        ;;
    *)
        usage
        ;;
esac

case "$2" in
    bs)
        report_type="balance"
        ;;
    cfs)
        report_type="cash_flow"
        ;;
    ps)
        report_type="profit"
        ;;
    *)
        usage
        ;;
esac

if [ "$1" == "d" ] && [ "$3" == "" ];then
    usage
fi

subfolder=feeds/fdmt_"$report_type"_sheet_"$suffix"

cd $DIL_ROOT
for code in `cat feeds/stock_list_china.jl | jq -r '.code'`
do
    if [ "$suffix" == "initial" ];then
        f="$subfolder"/data/"$code".csv
    else
        f="$subfolder"/data/"$code"_"$3".jl
    fi

    if [ ! -f "$f" ];then
        echo $code
    fi
done > "$subfolder"/code_missed
cat "$subfolder"/code_missed | sort | uniq

rm "$subfolder"/code_missed
