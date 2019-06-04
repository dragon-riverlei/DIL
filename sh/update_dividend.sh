#!/usr/local/bin/bash

# Update table securities_dividend.

usage(){
    echo "usage:"
    echo "update_dividend.sh <year> <month>"
    exit 1
}

if [ "$(date -j -f '%Y-%m-%d' $1-12-31)" == "" ];then
    usage
fi
year="$1"

if [ ! -n "$2" ] || [ ! "$2" -eq "$2" ]; then
    usage
fi

if [ ! "$2" -eq 6 ] && [ ! "$2" -eq 12 ]; then
    usage
fi

if [ "$2" -eq 6 ];then
    month=0"$2"
    day="30"
else
    month="$2"
    day="31"
fi

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT/crawl/crawl"
echo "scraping stock dividend $year$month from web..."
# scrapy crawl StockDividendChinaSpider -a years="$year$month"
echo "scraping done."
cd "$DIL_ROOT/"
echo "loading stock dividend to securities_dividend..."

csv_file=feeds/fdmt_dividend/data/stock_dividend_china_"$year"-"$month"-"$day".csv
cat feeds/fdmt_dividend/data/stock_dividend_china_"$year"-"$month"-"$day".jl | \
    jq -r -f "$DIL_ROOT"/sh/convert_regular_dividend_json_to_csv.jq | \
    sed 's/"//g' > $csv_file
psql "$db" <<EOF
\x
create temp table tmp_table as select * from securities_dividend with no data;
copy tmp_table from '$DIL_ROOT/$csv_file' with delimiter as ',' NULL as 'NULL' csv;
insert into securities_dividend select * from tmp_table where (code, time) not in (select code, time from securities_dividend);
EOF
rm $csv_file
echo "done."
