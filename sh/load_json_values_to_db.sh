#!/usr/local/bin/bash

# Load data from json format files and write them into DB.

usage(){
    echo "usage:"
    echo "load_json_values_to_db.sh <slc|dq|dvdd|ipo|stock_struct>"
    echo ""
    echo "  slc: stock list china"
    echo "  dq: day quote"
    echo "  dvdd: dividend"
    echo "  ipo: IPO info"
    echo "  stock_struct: stock structure"
    exit 1
}

# Populate "DIL_ROOT" and "db" with proper value
. $(dirname "$0")/env.sh

load_stock_list_china(){
    local csv_file="stock_list_china.csv"
    local table="securities_code"
    cat "$1" | jq -r '[.code, .name, .market, .country] | @csv' > "$DIL_ROOT"/feeds/"$csv_file"
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$DIL_ROOT/feeds/$csv_file' with delimiter as ',' csv;
insert into "$table" select * from tmp_table where code not in (select code from "$table");
EOF
    rm "$DIL_ROOT"/feeds/"$csv_file"
}

load_stock_day_quote_china(){
    local csv_file="stock_day_quote_china.csv"
    local table="securities_day_quote"
    cat "$1" | jq -r '[.date, .code, .price, .cap * 100000000.0, .pe_ratio, .pb_ratio] | @csv' > "$DIL_ROOT"/feeds/"$csv_file" #  市值cap单位从“亿元”转换到“元”
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$DIL_ROOT/feeds/$csv_file' with delimiter as ',' csv;
insert into "$table" select * from tmp_table where (code, time) not in (select code, time from "$table");
EOF
    rm "$DIL_ROOT"/feeds/"$csv_file"
}

load_stock_dividend_china(){
    local csv_file=${1%%.*}.csv
    local table="securities_dividend"
    local subfolder="feeds/fdmt_dividend/data"
    cat "$1" | jq -r -f "$DIL_ROOT"/sh/convert_regular_dividend_json_to_csv.jq | sed 's/"//g' > "$csv_file"
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$csv_file' with delimiter as ',' NULL as 'NULL' csv;
insert into "$table" select * from tmp_table where (code, time) not in (select code, time from "$table");
EOF
    rm "$csv_file"
}

load_stock_ipo_info_china(){
    local csv_file="stock_ipo_info_china.csv"
    local table="securities_ipo"
    cat "$1" | jq -r -f "$DIL_ROOT/sh/convert_stock_ipo_info_json_to_csv.jq" | sed 's/"//g' > "$DIL_ROOT"/feeds/"$csv_file"
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$DIL_ROOT/feeds/$csv_file' with delimiter as ',' NULL as 'NULL' csv;
insert into "$table" select * from tmp_table where code not in (select code from "$table");
EOF
    rm "$DIL_ROOT"/feeds/"$csv_file"
}

load_all_stock_dividend_china(){
    local subfolder="feeds/fdmt_dividend/data"
    for f in `ls $DIL_ROOT/$subfolder/*`
    do
        load_stock_dividend_china "$f"
    done
}

load_stock_structure_china(){
    local table="securities_stock_structure"
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$1' with delimiter as ',' NULL as '' csv;
insert into "$table" select * from tmp_table where (code, time) not in (select code, time from "$table");
EOF
}

load_all_stock_structure_china(){
    local subfolder="feeds/stock_structure/dbdata"
    cd $DIL_ROOT/$subfolder
    rm -f data.csv
    for f in `ls`
    do
        cat "$DIL_ROOT/$subfolder/$f" >> data.csv
    done

    local table="securities_stock_structure"
    psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
create table tmp_table as select * from "$table" with no data;
copy tmp_table from '$DIL_ROOT/$subfolder/data.csv' with delimiter as ',' NULL as '' csv;
insert into "$table" select * from tmp_table where (code, time) not in (select code, time from "$table");
EOF
    rm data.csv
}

case "$1" in
    slc)
        load_stock_list_china "$DIL_ROOT"/feeds/stock_list_china.jl
        ;;
    dq)
        load_stock_day_quote_china "$DIL_ROOT"/feeds/stock_day_quote_china.jl
        ;;
    dvdd)
        load_all_stock_dividend_china
        ;;
    ipo)
        load_stock_ipo_info_china "$DIL_ROOT"/feeds/stock_ipo_info_china.jl
        ;;
    stock_struct)
        "$DIL_ROOT"/sh/convert_regular_stock_structure_json_to_csv.sh
        load_all_stock_structure_china
        ;;
    *)
        usage
        ;;
esac
