#!/usr/local/bin/bash

# Update stock structure when computed '市值' is not equal to scraped 'cap'.

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

codes=$(psql dil -t -c "select case when sc.market = 'Shanghai' then 'sh' || t2.code else 'sz' || t2.code end code from (select code, 市值 - cap diff_cap from (select tk.code, tk.time, round(tk.市值,-6) 市值, dq.cap from (select * from securities_kpis_3()) tk join securities_day_quote dq on tk.code = dq.code and tk.time = dq.time and dq.code in (select distinct code from securities_profit_sheet_running_total) order by code) t1) t2 join securities_code sc on t2.code = sc.code where t2.diff_cap <> 0 and t2.code in (select distinct code from securities_profit_sheet_running_total);" | awk '{print $1}' | tr '\n' ',')

cd "$DIL_ROOT/crawl/crawl"
echo "scraping stock structure from web..."
scrapy crawl StockStructureChinaSpider -a codes="$codes"
echo "scraping done."
cd "$DIL_ROOT/"
echo "loading stock structure to securities_stock_structure..."
sh/load_json_values_to_db.sh stock_struct
echo "done."
