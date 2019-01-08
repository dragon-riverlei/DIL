#!/usr/local/bin/bash

# For initial regular report in csv format, transpose the row and column.
# For delta regular report in json format, convert from json format to csv format.

usage(){
    echo "usage:"
    echo "prepare_regular_report_csv_values.sh <i|d> <bs|cfs|ps> <bank|general|securities|insurance> <year>"
    echo ""
    echo "  i: initial"
    echo "  d: delta. When given, then one of <bank|general|securities|insurance> must also be given"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report"
    echo ""
    echo "  year: the year on which the regular report (should have been scraped already before run this script) should be compared to the schema."
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

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

case "$1" in
    d)
        suffix="delta"
        if [ "$3" == "" ] || [ "$4" == "" ];then
            usage
        fi
        jqf="$DIL_ROOT"/tmp/check_regular_report_delta_values_"$report_type"_"$3".jq
        "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e $2 $3 > "$jqf"
        ;;
    i)
        suffix="initial"
        ;;
    *)
        usage
        ;;
esac

case "$3" in
    bank)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000001.lst
        ;;
    general)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000002.lst
        ;;
    securities)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000686.lst
        ;;
    insurance)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/601318.lst
        ;;
    *)
        if [ "$suffix" == "delta" ];then
            usage
        fi
        ;;
esac

subfolder=feeds/fdmt_"${report_type}"_sheet_"$suffix"

function do_initial(){
    cd "$DIL_ROOT"/"$subfolder"
    mkdir dbdata
    for f in data/*.csv
    do
        awk -f "$DIL_ROOT/sh/transpose_regular_report_csv_values.awk" "$f" > dbdata/"${f##*/}"
    done
}

function do_delta(){
    cat "$schema_lst" | sort | uniq > "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes
    mkdir "$DIL_ROOT"/"$subfolder"/dbdata
    for code in $(cat "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes)
    do
        jq -r --arg code "$code" -f "$jqf" "$DIL_ROOT"/"$subfolder"/data/"$code"_$1.jl > "$DIL_ROOT"/"$subfolder"/dbdata/"$code"_$1.csv
    done
    rm "$jqf"
    rm "$DIL_ROOT"/tmp/check_regular_report_delta_fields_codes
}

case "$suffix" in
    delta)
        do_delta $4
        ;;
    initial)
        do_initial
        ;;
    *)
        ;;
esac
