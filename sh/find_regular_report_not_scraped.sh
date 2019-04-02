#!/usr/local/bin/bash

# Return a list of code for which the regular report is not found.

# The returned list of code are the ones in feeds/stock_list_china.jl but not
# do not have corresponding data files in "data" folder.

usage(){
    echo "usage:"
    echo "find_regular_report_not_scraped.sh <bs|cfs|ps>
    echo ""
    echo "  bs: balance sheet"
    echo " cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
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

suffix="initial"
subfolder=feeds/fdmt_"$report_type"_sheet_"$suffix"
cd $DIL_ROOT
for code in `cat feeds/stock_list_china.jl | jq -r '.code'`
do
    f="$subfolder"/data/"$code".csv
    if [ ! -f "$f" ];then
        echo $code
    fi
done > "$subfolder"/code_missed
cat "$subfolder"/code_missed | sort | uniq
rm "$subfolder"/code_missed
