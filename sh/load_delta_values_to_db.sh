#!/usr/local/bin/bash

# Load delta data into DB.
# This is a facade script for:
#   prepare_regular_report_csv_values.sh

usage(){
    echo "usage:"
    echo "year=2017 load_delta_values_to_db.sh"
    echo ""
    exit 1
}

if [ "$year" == "" ]; then
    usage
fi

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"/sh

#============== prepare =========================================

echo "Preparing delta regular report data: balance sheet of bank..."
./prepare_regular_report_csv_values.sh d bs bank "$year"
echo done

echo "Preparing delta regular report data: balance sheet of general..."
./prepare_regular_report_csv_values.sh d bs general "$year"
echo done

echo "Preparing delta regular report data: balance sheet of securities..."
./prepare_regular_report_csv_values.sh d bs securities "$year"
echo done

echo "Preparing delta regular report data: balance sheet of insurance..."
./prepare_regular_report_csv_values.sh d bs insurance "$year"
echo done

echo "Preparing delta regular report data: cash flow sheet of bank..."
./prepare_regular_report_csv_values.sh d cfs bank "$year"
echo done

echo "Preparing delta regular report data: cash flow sheet of general..."
./prepare_regular_report_csv_values.sh d cfs general "$year"
echo done

echo "Preparing delta regular report data: cash flow sheet of securities..."
./prepare_regular_report_csv_values.sh d cfs securities "$year"
echo done

echo "Preparing delta regular report data: cash flow sheet of insurance..."
./prepare_regular_report_csv_values.sh d cfs insurance "$year"
echo done

echo "Preparing delta regular report data: profit sheet of bank..."
./prepare_regular_report_csv_values.sh d ps bank "$year"
echo done

echo "Preparing delta regular report data: profit sheet of general..."
./prepare_regular_report_csv_values.sh d ps general "$year"
echo done

echo "Preparing delta regular report data: profit sheet of securities..."
./prepare_regular_report_csv_values.sh d ps securities "$year"
echo done

echo "Preparing delta regular report data: profit sheet of insurance..."
./prepare_regular_report_csv_values.sh d ps insurance "$year"
echo done

echo "Preparing delta regular report data: profit sheet of insurance..."
./prepare_regular_report_csv_values.sh d ps insurance "$year"
echo done

#============== load =========================================

echo "Loading delta regular report data into DB: balance sheet of bank..."
./load_regular_report_csv_values_to_db.sh d bs bank "$year"
echo done

echo "Loading delta regular report data into DB: balance sheet of general..."
./load_regular_report_csv_values_to_db.sh d bs general "$year"
echo done

echo "Loading delta regular report data into DB: balance sheet of securities..."
./load_regular_report_csv_values_to_db.sh d bs securities "$year"
echo done

echo "Loading delta regular report data into DB: balance sheet of insurance..."
./load_regular_report_csv_values_to_db.sh d bs insurance "$year"
echo done

echo "Loading delta regular report data into DB: cash flow sheet of bank..."
./load_regular_report_csv_values_to_db.sh d cfs bank "$year"
echo done

echo "Loading delta regular report data into DB: cash flow sheet of general..."
./load_regular_report_csv_values_to_db.sh d cfs general "$year"
echo done

echo "Loading delta regular report data into DB: cash flow sheet of securities..."
./load_regular_report_csv_values_to_db.sh d cfs securities "$year"
echo done

echo "Loading delta regular report data into DB: cash flow sheet of insurance..."
./load_regular_report_csv_values_to_db.sh d cfs insurance "$year"
echo done

echo "Loading delta regular report data into DB: profit sheet of bank..."
./load_regular_report_csv_values_to_db.sh d ps bank "$year"
echo done

echo "Loading delta regular report data into DB: profit sheet of general..."
./load_regular_report_csv_values_to_db.sh d ps general "$year"
echo done

echo "Loading delta regular report data into DB: profit sheet of securities..."
./load_regular_report_csv_values_to_db.sh d ps securities "$year"
echo done

echo "Loading delta regular report data into DB: profit sheet of insurance..."
./load_regular_report_csv_values_to_db.sh d ps insurance "$year"
echo done

echo "Loading delta regular report data into DB: profit sheet of insurance..."
./load_regular_report_csv_values_to_db.sh d ps insurance "$year"
echo done

echo "Loading stock list china data into DB..."
./load_json_values_to_db.sh slc
echo done

echo "Loading stock day quote data into DB..."
./load_json_values_to_db.sh dq
echo done

echo "Loading stock dividend data into DB..."
./load_json_values_to_db.sh dvdd
echo done

echo "Loading stock structure data into DB..."
./load_json_values_to_db.sh stock_struct
echo done
