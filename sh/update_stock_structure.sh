#!/usr/local/bin/bash

# Update stock structure when computed '市值' is not equal to scraped 'cap'.

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

codes=$(psql dil -t -c "select case when sc.market = 'Shanghai' then 'sh' || kpi3.code else 'sz' || kpi3.code end from (select code from check_securities_kpis_3_cap()) kpi3 join securities_code sc on sc.code = kpi3.code;" | awk '{print $1}' | tr '\n' ',')

cd "$DIL_ROOT/crawl/crawl"
echo "scraping stock structure from web..."
scrapy crawl StockStructureChinaSpider -a codes="$codes"
echo "scraping done."
cd "$DIL_ROOT/"
echo "loading stock structure to securities_stock_structure..."
sh/load_json_values_to_db.sh stock_struct
echo "done."
