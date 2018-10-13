#!/usr/local/bin/bash

# Return a list of code for which the regular report is not found for the current year and last year.
# It is helpful to find out companies that are not able to publish the report regularly.

usage(){
    echo "usage:"
    echo "find_stock_list_china_with_absence_regular_report.sh <bs|cfs|ps>"
    echo ""
    echo "  bs: balance sheet"
    echo " cfs: cash flow sheet"
    echo "  ps: profit sheet"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

this_year=$(date "+%Y")
last_year=$((this_year-1))
cat << EOF > "$DIL_ROOT/sh/find_stock_list_china_with_absence_regular_report.awk"
\$2 !~ /$this_year/ && \$2 !~ /$last_year/ && FNR==1 {print FILENAME; nextfile}
EOF

function find_report_specific(){
    find "$data_folder" -type f -name "*.csv" | xargs -P 4 awk -f "$DIL_ROOT"/sh/find_stock_list_china_with_absence_regular_report.awk | \
    awk '{print gensub(/.*([0-9]{6})\.csv/, "\\1", "g")}' | sort | uniq
}

cd $DIL_ROOT/feeds
case "$1" in
    bs)
        data_folder="fdmt_balance_sheet_initial/data" find_report_specific
        ;;
    cfs)
        data_folder="fdmt_cash_flow_sheet_initial/data" find_report_specific
        ;;
    ps)
        data_folder="fdmt_profit_sheet_initial/data" find_report_specific
        ;;
    *)
        find fdmt_balance_sheet_initial/data fdmt_cash_flow_sheet_initial/data fdmt_profit_sheet_initial/data -type f -name "*.csv" | \
        xargs -P 4 awk -f "$DIL_ROOT"/sh/find_stock_list_china_with_absence_regular_report.awk | awk '{print gensub(/.*([0-9]{6})\.csv/, "\\1", "g")}' | sort | uniq
    ;;
esac

rm "$DIL_ROOT/sh/find_stock_list_china_with_absence_regular_report.awk"
