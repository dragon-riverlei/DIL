#!/usr/local/bin/bash

# Load data from csv files and write them to DB.

usage(){
    echo "usage:"
    echo "load_regular_report_csv_values_to_db.sh <i|d> <bs|cfs|ps> <bank|general|securities|insurance> <year>"
    echo ""
    echo "  i: initial"
    echo "  d: delta"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report."
    echo ""
    echo "  year: the year on which the regular report (should have been scraped already before run this script) should be compared to the schema."
    exit
}

# Populate "DIL_ROOT" and "db" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    d)
        suffix="delta"
        if [ "$4" == "" ];then
            usage
        fi
        ext=_"$4".csv
        ;;
    i)
        suffix="initial"
        ext=.csv
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

subfolder=feeds/fdmt_"$report_type"_sheet_"$suffix"

case "$3" in
    bank)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000001.lst
        table=securities_"$report_type"_sheet_bank
        ;;
    general)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000002.lst
        table=securities_"$report_type"_sheet_general
        ;;
    securities)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/000686.lst
        table=securities_"$report_type"_sheet_securities
        ;;
    insurance)
        schema_lst="$DIL_ROOT"/feeds/fdmt_"$report_type"_sheet_initial/schemas/601318.lst
        table=securities_"$report_type"_sheet_insurance
        ;;
    *)
        usage
        ;;
esac

for f in $(cat "$schema_lst")
do
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$DIL_ROOT/$subfolder/dbdata/$f$ext' with (format csv);
insert into "$table" select * from tmp_table on conflict do nothing;
EOF
done
