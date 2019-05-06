#!/usr/local/bin/bash

# Update balance sheet, cash flow sheet and profit sheet.

usage(){
    echo "usage:"
    echo "update_balance_cash_flow_profit_sheets.sh <year> <month>"
    echo "update_balance_cash_flow_profit_sheets.sh <year> <month> <codes>"
    exit 1
}

if [ "$(date -j -f '%Y-%m-%d' $1-12-31)" == "" ];then
    usage
fi

if [ ! -n "$2" ] || [ ! "$2" -eq "$2" ]; then
    usage
fi

if [ ! "$2" -eq 3 ] && [ ! "$2" -eq 6 ] && [ ! "$2" -eq 9 ] && [ ! "$2" -eq 12 ]; then
    usage
fi

. $(dirname "$0")/env.sh

"$DIL_ROOT"/sh/update_balance_sheet.sh "$1" "$2" "$3"
"$DIL_ROOT"/sh/update_cash_flow_sheet.sh "$1" "$2" "$3"
"$DIL_ROOT"/sh/update_profit_sheet.sh "$1" "$2" "$3"

echo "Updating table securities_cash_flow_sheet_running_total..."
psql "$db" <<EOF
select * from insert_securities_cash_flow_sheet_running_total_single_year($1);
EOF
echo "Updating table securities_cash_flow_sheet_running_total done."

echo "Updating table securities_profit_sheet_running_total..."
psql "$db" <<EOF
select * from insert_securities_profit_sheet_running_total_single_year($1);
EOF
echo "Updating table securities_profit_sheet_running_total done."

echo "Updating table securities_kpi..."
psql "$db" <<EOF
select * from insert_securities_kpi_c1($1,$1);
select * from insert_securities_kpi_c2($1,$1);
EOF
echo "Updating table securities_kpi done."
