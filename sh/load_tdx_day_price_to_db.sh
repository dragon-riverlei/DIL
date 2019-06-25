#!/usr/local/bin/bash

# Parse TDX day prices and load them into table securities_day_price.

usage(){
    echo "usage:"
    echo "load_tdx_day_price_to_db.sh min_date max_date"
    echo " min_date: 2011-01-01"
    echo " max_date: 2017-12-31"
    exit 1
}

if [ "$(date -j -f '%Y-%m-%d' $1)" == "" ] || [ "$(date -j -f '%Y-%m-%d' $2)" == "" ];then
    usage
fi

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

# echo "Generating day price file list to be parsed to $DIL_ROOT/tmp/tdx_day_files ..."
# psql -t "$db" <<EOF | awk '$0 !~ /^$/{print $1}' > "$DIL_ROOT"/tmp/tdx_day_files
# select case when market = 'Shanghai' then 'sh' || code || '.day' else 'sz' || code || '.day' end tdx_day_file from securities_code order by tdx_day_file;
# EOF

# echo "Generating day price csv file to $DIL_ROOT/feeds/tdx_data/day_price_$1_$2.csv ..."
# time cat <(ls "$DIL_ROOT"/feeds/tdx_data/vipdoc/sh/lday/) <(ls "$DIL_ROOT"/feeds/tdx_data/vipdoc/sz/lday/) <(cat "$DIL_ROOT"/tmp/tdx_day_files) | sort | uniq -d | \
#     awk -v root="$DIL_ROOT" '$0 ~ /^sh/{print root "/feeds/tdx_data/vipdoc/sh/lday/" $0} $0 ~ /^sz/ {print root "/feeds/tdx_data/vipdoc/sz/lday/" $0}' | \
#     xargs python "$DIL_ROOT"/sh/parse_tdx_day_price.py $1 $2 > "$DIL_ROOT"/feeds/tdx_data/day_price_"$1"_"$2".csv

echo "Loading $DIL_ROOT/feeds/tdx_data/day_price_$1_$2.csv to DB ..."
time psql "$db" <<EOF
create temp table tmp_table as select * from securities_day_price with no data;
copy tmp_table from '$DIL_ROOT/feeds/tdx_data/day_price_$1_$2.csv' with delimiter as ',' csv;
insert into securities_day_price select * from tmp_table;
EOF

echo "Done."
