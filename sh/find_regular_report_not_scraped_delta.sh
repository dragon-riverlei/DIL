#!/usr/local/bin/bash

# Return a list of code for which the regular report of the given year and month is not found.

# The returned list of code are the ones in DB table securities_code not having the given year and month
# found in the corresponding regular report table.

usage(){
    echo "usage:"
    echo "find_regular_report_not_scraped_delta.sh <bs|cfs|ps> <year> <month>"
    echo ""
    echo "  bs: balance sheet"
    echo " cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  year: the year for which the regular report is to be scraped, such as 2017"
    echo " month: the month for which the regular report is to be scraped, any one of (3,6,9,12)"
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

suffix="delta"
if [ "$(date -j -f '%Y-%m-%d' $2-12-31)" == "" ];then
    usage
fi

if [ -n "$3" ] && [ "$3" -eq "$3" ]; then
    if [ "$3" -eq 3 ] || [ "$3" -eq 6 ] || [ "$3" -eq 9 ] || [ "$3" -eq 12 ];then
        table1=securities_"$report_type"_sheet_bank
        table2=securities_"$report_type"_sheet_general
        table3=securities_"$report_type"_sheet_insurance
        table4=securities_"$report_type"_sheet_securities
        psql "$db" -t <<EOF
select code from securities_code where code not in (
select code from $table1 where extract(year from time) = $2 and extract(month from time) = $3
union
select code from $table2 where extract(year from time) = $2 and extract(month from time) = $3
union
select code from $table3 where extract(year from time) = $2 and extract(month from time) = $3
union
select code from $table4 where extract(year from time) = $2 and extract(month from time) = $3);
EOF
    else
        usage
    fi
else
    usage
fi
