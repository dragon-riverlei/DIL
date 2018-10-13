#!/usr/local/bin/bash

# Report if there is any difference of list of fields between the initial and delta regular report.

# It is helpful to gain an overview of the data quality.

# NOTE:
# Only the first line of the delta report is compared to determine if there is any difference.
# Some fields of initial regular report are filtered out before comparison.

usage(){
    echo "usage:"
    echo "check_regular_report_delta_fields.sh <bs|cfs|ps> <bank|general|securities|insurance> <year>"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report."
    echo ""
    echo "  year: the year on which the regular report (should have been scraped already before run this script) should be compared to the schema."
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    bs)
        report_type="balance"
        subfolder="feeds/fdmt_"$report_type"_sheet_delta"
        ;;
    cfs)
        report_type="cash_flow"
        subfolder="feeds/fdmt_"$report_type"_sheet_delta"
        ;;
    ps)
        report_type="profit"
        subfolder="feeds/fdmt_"$report_type"_sheet_delta"
        ;;
    *)
        usage
        ;;
esac

case "$2" in
    bank)
        schema_file="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/schemas/000001"
        fields_folder="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/fields/schema000001"
        ;;
    general)
        schema_file="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/schemas/000002"
        fields_folder="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/fields/schema000002"
        ;;
    securities)
        schema_file="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/schemas/000686"
        fields_folder="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/fields/schema000686"
        ;;
    insurance)
        schema_file="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/schemas/601318"
        fields_folder="$DIL_ROOT/feeds/fdmt_"$report_type"_sheet_initial/fields/schema601318"
        ;;
    *)
        usage
        ;;
esac

if [ "$3" == "" ];then
    usage
fi

cd "$fields_folder"
ls > "$DIL_ROOT"/tmp/check_regular_report_delta_fields_possible_codes
"$DIL_ROOT"/sh/find_stock_list_china_with_absence_regular_report.sh > "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes_to_exclude
cat "$DIL_ROOT"/tmp/check_regular_report_delta_fields_possible_codes \
    "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes_to_exclude \
    "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes_to_exclude \
    | sort | uniq -u > "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes

"$DIL_ROOT"/sh/print_regular_report_fields.sh $1 $2 plain | \
    "$DIL_ROOT"/sh/check_regular_report_delta_fields_filter.sh $1 $2 | sort > "$DIL_ROOT"/tmp/print_regular_report_fields_filtered_out

for code in $(cat "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes)
do
    sort <(head -n 1 $DIL_ROOT/$subfolder/data/"$code"_$3.jl | jq -r 'keys | .[]' | grep -v 'date') \
         <(cat $DIL_ROOT/tmp/print_regular_report_fields_filtered_out) \
        | uniq -u
done | sort | uniq

rm "$DIL_ROOT"/tmp/check_regular_report_delta_fields_possible_codes
rm "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes_to_exclude
rm "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes
rm "$DIL_ROOT"/tmp/print_regular_report_fields_filtered_out
