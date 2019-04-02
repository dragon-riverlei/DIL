#!/usr/local/bin/bash

# Update regular report profit sheet.

usage(){
    echo "usage:"
    echo "update_profit_sheet.sh <year> <month>"
    echo "update_profit_sheet.sh <year> <month> <codes>"
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

spider="StockFdmtProfitSheetChinaDeltaSpider"


# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"/crawl/crawl
if [ "$3" == "" ];then
    scrapy crawl "$spider" -a year="$1" -a month="$2"
else
    scrapy crawl "$spider" -a year="$1" -a month="$2" -a codes="$3"
fi

schema_lst_bank="$DIL_ROOT"/feeds/fdmt_profit_sheet_initial/schemas/000001.lst
jqf_bank="$DIL_ROOT"/tmp/extract_profit_sheet_bank.jq
"$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e ps bank > "$jqf_bank"
table=securities_profit_sheet_bank
for code in $(cat "$schema_lst_bank" <(echo "$3" | tr "," "\n") | sort | uniq -d)
do
    jl_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    csv_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/dbdata/"$code"_$1.csv
    check_result=$("$DIL_ROOT"/sh/check_profit_sheet_bank.sh "$jl_file")
    if [ "$check_result" == "" ];then
        jq -r --arg code "$code" -f "$jqf_bank" "$jl_file" > "$csv_file"
        psql "$db" <<EOF
create temp table tmp_table as select * from $table with no data;
copy tmp_table from '$csv_file' with (format csv);
delete from $table where code = '$code' and extract(year from time) = $1;
insert into $table select * from tmp_table on conflict do nothing;
EOF
    fi
done

schema_lst_general="$DIL_ROOT"/feeds/fdmt_profit_sheet_initial/schemas/000002.lst
jqf_general="$DIL_ROOT"/tmp/extract_profit_sheet_general.jq
"$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e ps general > "$jqf_general"
table=securities_profit_sheet_general
for code in $(cat "$schema_lst_general" <(echo "$3" | tr "," "\n") | sort | uniq -d)
do
    "$DIL_ROOT"/sh/check_profit_sheet_general.sh "$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    jl_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    csv_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/dbdata/"$code"_$1.csv
    check_result=$("$DIL_ROOT"/sh/check_profit_sheet_general.sh "$jl_file")
    if [ "$check_result" == "" ];then
        jq -r --arg code "$code" -f "$jqf_general" "$jl_file" > "$csv_file"
        psql "$db" <<EOF
create temp table tmp_table as select * from $table with no data;
copy tmp_table from '$csv_file' with (format csv);
delete from $table where code = '$code' and extract(year from time) = $1;
insert into $table select * from tmp_table on conflict do nothing;
EOF
    fi
done

schema_lst_insurance="$DIL_ROOT"/feeds/fdmt_profit_sheet_initial/schemas/601318.lst
jqf_insurance="$DIL_ROOT"/tmp/extract_profit_sheet_insurance.jq
"$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e ps insurance > "$jqf_insurance"
table=securities_profit_sheet_insurance
for code in $(cat "$schema_lst_insurance" <(echo "$3" | tr "," "\n") | sort | uniq -d)
do
    "$DIL_ROOT"/sh/check_profit_sheet_insurance.sh "$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    jl_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    csv_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/dbdata/"$code"_$1.csv
    check_result=$("$DIL_ROOT"/sh/check_profit_sheet_insurance.sh "$jl_file")
    if [ "$check_result" == "" ];then
        jq -r --arg code "$code" -f "$jqf_insurance" "$jl_file" > "$csv_file"
        psql "$db" <<EOF
create temp table tmp_table as select * from $table with no data;
copy tmp_table from '$csv_file' with (format csv);
delete from $table where code = '$code' and extract(year from time) = $1;
insert into $table select * from tmp_table on conflict do nothing;
EOF
    fi
done

schema_lst_securities="$DIL_ROOT"/feeds/fdmt_profit_sheet_initial/schemas/000686.lst
jqf_securities="$DIL_ROOT"/tmp/extract_profit_sheet_securities.jq
"$DIL_ROOT"/sh/print_regular_report_delta_jq_fields.sh -e ps securities > "$jqf_securities"
table=securities_profit_sheet_securities
for code in $(cat "$schema_lst_securities" <(echo "$3" | tr "," "\n") | sort | uniq -d)
do
    "$DIL_ROOT"/sh/check_profit_sheet_securities.sh "$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    jl_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/data/"$code"_"$1".jl
    csv_file="$DIL_ROOT"/feeds/fdmt_profit_sheet_delta/dbdata/"$code"_$1.csv
    check_result=$("$DIL_ROOT"/sh/check_profit_sheet_securities.sh "$jl_file")
    if [ "$check_result" == "" ];then
        jq -r --arg code "$code" -f "$jqf_securities" "$jl_file" > "$csv_file"
        psql "$db" <<EOF
create temp table tmp_table as select * from $table with no data;
copy tmp_table from '$csv_file' with (format csv);
delete from $table where code = '$code' and extract(year from time) = $1;
insert into $table select * from tmp_table on conflict do nothing;
EOF
    fi
done
