#!/usr/local/bin/bash

# Return an enumeration of values of all the fields that appear in the regular report.
# For the value that is numeric, a "yes" is returned.
# For the value that is NOT numeric, it is returned literally.
# Thus, we can have a summary of all the possible values in the regular report.

usage(){
    echo "usage:"
    echo "check_regular_report_delta_values.sh <bs|cfs|ps> <bank|general|securities|insurance> <year>"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report."
    echo "  year: the year on which the regular report (should have been scraped already before run this script) should be compared to the schema."
    echo ""
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    bs)
        subfolder="feeds/fdmt_balance_sheet_delta"
        report_type="balance"
        ;;
    cfs)
        subfolder="feeds/fdmt_cash_flow_sheet_delta"
        report_type="cash_flow"
        ;;
    ps)
        subfolder="feeds/fdmt_profit_sheet_delta"
        report_type="profit"
        ;;
    *)
        usage
        ;;
esac

case "$2" in
    bank)
        schema_file="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000001
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000001.lst
        ;;
    general)
        schema_file="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000002
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000002.lst
        ;;
    securities)
        schema_file="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000686
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000686.lst
        ;;
    insurance)
        schema_file="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/601318
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/601318.lst
        ;;
    *)
        usage
        ;;
esac

if [ "$3" == "" ];then
    usage
fi

jqf="$DIL_ROOT"/tmp/check_regular_report_delta_values_"$report_type"_"$2".jq
"$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -c $1 $2 > "$jqf"

cat "$schema_lst" | sort | uniq > "$DIL_ROOT"/"$subfolder"/code_list

"$DIL_ROOT"/sh/find_stock_list_china_with_absence_regular_report.sh > "$DIL_ROOT"/"$subfolder"/code_with_absent_regular_report

cat "$DIL_ROOT"/"$subfolder"/code_list \
    "$DIL_ROOT"/"$subfolder"/code_with_absent_regular_report \
    "$DIL_ROOT"/"$subfolder"/code_with_absent_regular_report \
| sort | uniq -u \
| awk -v folder="$DIL_ROOT" -v subfolder="$subfolder" -v year="$3" '{print folder "/" subfolder "/data/" $0 "_" year ".jl"}' \
| xargs jq -r -f "$jqf" | awk -F "," '{for (i=1; i<=NF; i++){print $i}}' | gsort -u

rm "$DIL_ROOT"/"$subfolder"/code_list
rm "$DIL_ROOT"/"$subfolder"/code_with_absent_regular_report
rm "$jqf"
