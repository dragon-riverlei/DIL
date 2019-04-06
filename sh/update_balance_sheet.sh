#!/usr/local/bin/bash

# Update regular report balance sheet.

usage(){
    echo "usage:"
    echo "update_balance_sheet.sh <year> <month>"
    echo "update_balance_sheet.sh <year> <month> <codes>"
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

spider="StockFdmtBalanceSheetChinaDeltaSpider"

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

load_data_to_db(){
    local code="$1"
    local jqf="$2"
    local jl_file="$3"
    local csv_file="$4"
    local table="$5"
    local year="$6"
    local month="$7"
    jq -r --arg code "$code" -f "$jqf" "$jl_file" > "$csv_file"
    psql "$db" <<EOF
create temp table tmp_table as select * from $table with no data;
copy tmp_table from '$csv_file' with (format csv);
delete from $table where code = '$code' and extract(year from time) = $year;
insert into $table select * from tmp_table on conflict do nothing;
EOF
}

echo "Updating balance sheet..."
cd "$DIL_ROOT"/crawl/crawl
if [ "$3" == "" ];then
    echo "Scraping balance sheet data..."
    scrapy crawl "$spider" -a year="$1" -a month="$2"
    echo "Scraping balance sheet data done."

    echo "Checking and loading balance sheet data to DB..."

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/000001.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_bank.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs bank > "$jqf"
    table=securities_balance_sheet_bank
    for code in $(cat "$schema_lst" <("$DIL_ROOT"/sh/find_regular_report_not_scraped_delta.sh bs "$1" "$2") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_bank.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/000002.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_general.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs general > "$jqf"
    table=securities_balance_sheet_general
    for code in $(cat "$schema_lst" <("$DIL_ROOT"/sh/find_regular_report_not_scraped_delta.sh bs "$1" "$2") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_general.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/601318.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_insurance.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs insurance > "$jqf"
    table=securities_balance_sheet_insurance
    for code in $(cat "$schema_lst" <("$DIL_ROOT"/sh/find_regular_report_not_scraped_delta.sh bs "$1" "$2") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_insurance.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/000686.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_securities.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs securities > "$jqf"
    table=securities_balance_sheet_securities
    for code in $(cat "$schema_lst" <("$DIL_ROOT"/sh/find_regular_report_not_scraped_delta.sh bs "$1" "$2") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_securities.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done
    echo "Checking and loading balance sheet data to DB done."
else
    echo "Scraping balance sheet data..."
    scrapy crawl "$spider" -a year="$1" -a month="$2" -a codes="$3"
    echo "Scraping balance sheet data done."

    echo "Checking and loading balance sheet data to DB..."

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/000001.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_bank.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs bank > "$jqf"
    table=securities_balance_sheet_bank
    for code in $(cat "$schema_lst_bank" <(echo "$3" | tr "," "\n") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_bank.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/000002.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_general.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs general > "$jqf"
    table=securities_balance_sheet_general
    for code in $(cat "$schema_lst_general" <(echo "$3" | tr "," "\n") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_general.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/601318.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_insurance.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs insurance > "$jqf"
    table=securities_balance_sheet_insurance
    for code in $(cat "$schema_lst_insurance" <(echo "$3" | tr "," "\n") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_insurance.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done

    schema_lst="$DIL_ROOT"/feeds/fdmt_balance_sheet_initial/schemas/000686.lst
    jqf="$DIL_ROOT"/tmp/extract_balance_sheet_securities.jq
    "$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e bs securities > "$jqf"
    table=securities_balance_sheet_securities
    for code in $(cat "$schema_lst_securities" <(echo "$3" | tr "," "\n") | sort | uniq -d)
    do
        jl_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/data/"$code"_"$1".jl
        if [ "$2" -eq 3 ] || [ "$2" -eq 12 ];then
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-31)
        else
            count=$(cat "$jl_file" | grep -c "$1"-"$2"-30)
        fi
        if [ "$count" -eq 1 ];then
            csv_file="$DIL_ROOT"/feeds/fdmt_balance_sheet_delta/dbdata/"$code"_"$1".csv
            check_result=$("$DIL_ROOT"/sh/check_balance_sheet_securities.sh "$jl_file")
            if [ "$check_result" == "" ];then
                load_data_to_db "$code" "$jqf" "$jl_file" "$csv_file" "$table" "$1" "$2"
            fi
        fi
    done
    echo "Checking and loading balance sheet data to DB done."
fi
