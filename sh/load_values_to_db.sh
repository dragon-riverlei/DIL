#!/usr/local/bin/bash

# Load data into DB.
# This is a facade script for:
#   load_json_values_to_db.sh
#   prepare_regular_report_csv_values.sh
#   load_regular_report_csv_values_to_db.sh

usage(){
    echo "usage:"
    echo "year=2017 load_values_to_db.sh"
    echo ""
    exit 1
}

if [ "$year" == "" ]; then
    usage
fi

# Populate "DIL_ROOT" and "db" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"/sh

#=============== drop tables from DB which are affected by loading the data into DB ========
psql "$db" <<EOF
\x
drop table if exists securities_balance_sheet_bank;
drop table if exists securities_balance_sheet_general;
drop table if exists securities_balance_sheet_insurance;
drop table if exists securities_balance_sheet_securities;
drop table if exists securities_cash_flow_sheet_bank;
drop table if exists securities_cash_flow_sheet_general;
drop table if exists securities_cash_flow_sheet_insurance;
drop table if exists securities_cash_flow_sheet_securities;
drop table if exists securities_profit_sheet_bank;
drop table if exists securities_profit_sheet_general;
drop table if exists securities_profit_sheet_insurance;
drop table if exists securities_profit_sheet_securities;
drop table if exists securities_stock_structure;
drop table if exists securities_code;
drop table if exists securities_day_quote;
drop table if exists securities_dividend;
drop table if exists securities_kpi;
\i $DIL_ROOT/db/security-postgres-tables.sql
EOF

#============== initial =========================================

echo "Preparing initial regular report data: balance sheet..."
./prepare_regular_report_csv_values.sh i bs
echo done

echo "Preparing initial regular report data: cash flow sheet..."
./prepare_regular_report_csv_values.sh i cfs
echo done

echo "Preparing initial regular report data: profit sheet..."
./prepare_regular_report_csv_values.sh i ps
echo done

echo "Loading initial regular report data into DB: balance sheet of bank..."
./load_regular_report_csv_values_to_db.sh i bs bank
echo done

echo "Loading initial regular report data into DB: balance sheet of general..."
./load_regular_report_csv_values_to_db.sh i bs general
echo done

echo "Loading initial regular report data into DB: balance sheet of securities..."
./load_regular_report_csv_values_to_db.sh i bs securities
echo done

echo "Loading initial regular report data into DB: balance sheet of insurance..."
./load_regular_report_csv_values_to_db.sh i bs insurance
echo done

echo "Loading initial regular report data into DB: cash flow sheet of bank..."
./load_regular_report_csv_values_to_db.sh i cfs bank
echo done

echo "Loading initial regular report data into DB: cash flow sheet of general..."
./load_regular_report_csv_values_to_db.sh i cfs general
echo done

echo "Loading initial regular report data into DB: cash flow sheet of securities..."
./load_regular_report_csv_values_to_db.sh i cfs securities
echo done

echo "Loading initial regular report data into DB: cash flow sheet of insurance..."
./load_regular_report_csv_values_to_db.sh i cfs insurance
echo done

echo "Loading initial regular report data into DB: profit sheet of bank..."
./load_regular_report_csv_values_to_db.sh i ps bank
echo done

echo "Loading initial regular report data into DB: profit sheet of general..."
./load_regular_report_csv_values_to_db.sh i ps general
echo done

echo "Loading initial regular report data into DB: profit sheet of securities..."
./load_regular_report_csv_values_to_db.sh i ps securities
echo done

echo "Loading initial regular report data into DB: profit sheet of insurance..."
./load_regular_report_csv_values_to_db.sh i ps insurance
echo done

#============== delta =========================================

./load_delta_values_to_db.sh
