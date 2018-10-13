#!/usr/local/bin/bash

# Within given report type, print out fields for each code.

usage(){
    echo "usage:"
    echo "print_regular_report_fields.sh <bs|cfs|ps> <bank|general|securities|insurance> <plain|sql>"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report."
    echo ""
    echo "  plain: output the field literally"
    echo "  sql: output the field with modification if necessary in order to be included in SQL table definition"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    bs)
        subfolder="feeds/fdmt_balance_sheet_initial"
        ;;
    cfs)
        subfolder="feeds/fdmt_cash_flow_sheet_initial"
        ;;
    ps)
        subfolder="feeds/fdmt_profit_sheet_initial"
        ;;
    *)
        usage
        ;;
esac

case "$2" in
    bank)
        data_file="data/000001.csv"
        schema_file="schemas/000001"
        ;;
    general)
        data_file="data/000002.csv"
        schema_file="schemas/000002"
        ;;
    securities)
        data_file="data/000686.csv"
        schema_file="schemas/000686"
        ;;
    insurance)
        data_file="data/601318.csv"
        schema_file="schemas/601318"
        ;;
    *)
        usage
        ;;
esac

if [ "$3" == "" ];then
    usage
fi

cd "$DIL_ROOT"/"$subfolder"

if [ "$3" == "plain" ];then
    paste -d "\0" \
    <(cat "$data_file" | awk -F "\t" '$3==""{print "-- "}$3!=""{print ""}') \
    <(cat "$schema_file" | \
        awk -F "\"" '{print $4}') \
    | awk '$1=="--"{print $1 " " $2}$1!="--"{print}' \
    | tail -n +3
else
    paste -d "\0" \
    <(cat "$data_file" | awk -F "\t" '$3==""{print "-- "}$3!=""{print ""}') \
    <(cat "$schema_file" | \
        sed 's/:/：/g' | sed 's/(/（/g' | sed 's/)/）/g' | sed 's/\//_/g' | sed 's/</_/g' | sed 's/>/_/g'  | \
        awk -F "\"" '{print $4 " numeric(20,2) not null,"}') \
    | awk '$1=="--"{print $1 " " $2}$1!="--"{print}' \
    | tail -n +3
fi
