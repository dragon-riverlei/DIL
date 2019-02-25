#!/usr/local/bin/bash

# Update securities kpi table.

usage(){
    echo "usage:"
    echo "update_securities_kpi.sh 2018"
    echo ""
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT/"
is_year=$(echo "$1" | grep -E -c "^[0-9]{4}$")
if [ ! "$is_year" == "1" ];then
    usage
fi

for ((i=2010; i<="$1"; i ++))
do
    echo "Executing insert_securities_kpi_cs($i, $1)..."
    psql "$db" <<EOF
\x
select insert_securities_kpi_c2($i, $1);
EOF
done

