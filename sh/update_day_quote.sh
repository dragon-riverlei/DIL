#!/usr/local/bin/bash

# Update day quote: both stock_day_quote_china.jl and table securities_day_quote.

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT/crawl/crawl"
echo "scraping day quote from web..."
scrapy crawl StockDayQuoteChinaSpider
echo "scraping done."
cd "$DIL_ROOT/"
echo "loading day quote to securities_day_quote..."
sh/load_json_values_to_db.sh dq
echo "done."
