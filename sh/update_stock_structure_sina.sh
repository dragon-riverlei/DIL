#!/usr/local/bin/bash

# Update table securities_stock_structure_sina with data scraped from sina.

usage(){
    echo "usage:"
    echo "update_stock_structure_sina.sh"
    echo "update_stock_structure_sina.sh <codes>"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

jl_file="$DIL_ROOT/feeds/stock_structure/data/stock_structure_total_share_china.jl"
csv_file="$DIL_ROOT/feeds/stock_structure/dbdata/stock_structure_total_share_china.csv"


cd "$DIL_ROOT/crawl/crawl"
if [ "$1" == "" ];then
    echo "scraping total share of stock structure for all stocks from web..."
    scrapy crawl StockStructureTotalShareChinaSpider
elif [ "$1" == "cap" ];then
    echo "scraping total share of stock structure for stocks whose caps are in dispute from web..."
    codes=$(psql dil -t -c "select code from check_securities_kpi_c3_cap();" | awk '{print $1}' | tr '\n' ',')
    scrapy crawl StockStructureTotalShareChinaSpider -a codes="$codes"
else
    echo "scraping total share of stock structure for the specified stocks from web..."
    scrapy crawl StockStructureTotalShareChinaSpider -a codes="$1"
fi
echo "scraping done."
echo "checking scraped data..."
check_result=$(cat "$jl_file" | jq -r '.csv_line' | awk -F "," '$1 !~ /^[0-9]{6}/ || $2 !~ /[0-9]{4}-[0-9]{2}-[0-9}{2}/ || $3 ~ /[0-9]+\.*[0-9]*/ || $4 !="万股"{print}')
if [ ! "$check_result" == "" ];then
    echo "checking failed..."
    echo "$check_result"
    exit 1
fi
echo "checking done."
echo "loading total share of stock structure to securities_stock_structure_sina..."
cd "$DIL_ROOT/"
cat <<"EOF" > tmp/remove_duplicate_code_time_in_stock_structure.awk
BEGIN{
    code = ""
}
code == $1 {
    shares[$2] = $3
}
code != $1 {
    for (share in shares) {
        print code "," share "," shares[share]
    }
    delete shares
    code = $1
    shares[$2] = $3
}
END {
    for (share in shares) {
        print code "," share "," shares[share]
    }
}
EOF
cat "$jl_file" | jq -r '.csv_line' | cut -d "," -f 1,2,3 | sort -t "," -k 1,2 | awk -F "," -f tmp/remove_duplicate_code_time_in_stock_structure.awk | sort -t "," -k 1,2 > "$csv_file"
table="securities_stock_structure_sina"
psql "$db" <<EOF
\x
create temp table tmp_table as select * from "$table" with no data;
copy tmp_table from '$csv_file' with delimiter as ',' NULL as '' csv;
insert into "$table" select * from tmp_table where extract(year from time)::integer >= 2010 and (code, time) not in (select code, time from "$table");
EOF
echo "done."

rm tmp/remove_duplicate_code_time_in_stock_structure.awk
