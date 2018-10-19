#!/usr/local/bin/bash

# Within the given report type, do the following:
# extract the fields of each code
# group the codes with same list of fields

usage(){
    echo "usage:"
    echo "classify_regular_report.sh <bs|cfs|ps|stock_struct>"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo "  stock_struct: stock_structure"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    bs)
        subfolder="feeds/fdmt_balance_sheet_initial"
        ;;
    cfs)
        subfolder="feeds/fdmt_cash_flow_sheet_initial"
        ;;
    ps)
        subfolder="feeds/fdmt_profit_sheet_initial"
        ;;
    stock_struct)
        subfolder="feeds/stock_structure"
        ;;
    *)
        usage
        ;;
esac

function extract_fields(){
    cd "$DIL_ROOT"/"$subfolder"/data
    if [ "$1" == "bs" ] || [ "$1" == "cfs" ] || [ "$1" == "ps" ];then
        cat <<EOF > "$DIL_ROOT"/sh/print_fdmt_csv_fields.awk
BEGIN{
    count = 0
}
{
    line = "{\"" count "\": \"" \$1 "\"}"
    print line > "../fields/" substr(FILENAME, 1, 6)
    count = count + 1
}
EOF
        # for f in $(ls *.csv);do
        #     name=${f%%.csv}
        #     cat "$f" | awk -f "$DIL_ROOT"/sh/print_fdmt_csv_fields.awk	> ../fields/"$name"
        # done
        ls *.csv | xargs -P 4 -I 'file' awk -f $DIL_ROOT/sh/print_fdmt_csv_fields.awk 'file'
        rm "$DIL_ROOT"/sh/print_fdmt_csv_fields.awk
    elif [ "$1" == "stock_struct" ];then
        # for f in $(ls *.jl);do
        #     name=${f%%.jl}
        #     cat "$f" | jq -r '.Result.ShareChangeList[].des'	> ../fields/"$name"
        # done
        ls *.jl | sed 's/\.jl//g' | xargs -P 4 -I 'code' sh -c 'jq -r ".Result.ShareChangeList[].des" code.jl > ../fields/code'
    else
        usage
    fi
}


rm -rf "$DIL_ROOT"/"$subfolder"/fields
rm -rf "$DIL_ROOT"/"$subfolder"/schemas
mkdir "$DIL_ROOT"/"$subfolder"/fields
mkdir "$DIL_ROOT"/"$subfolder"/schemas

extract_fields "$1"

cd "$DIL_ROOT"/"$subfolder"

f0=$(find ./fields -maxdepth 1 -type f -name "*" | sort | head -n 1)
while [ ! "$f0" == "" ];do
    schema=${f0##*/}
    cp "$f0" schemas/"$schema"
    schema_folder=schemas/"$schema"_lst
    mkdir $schema_folder

# ======= replaced by xargs parallel mode to speed up processing ======

#   for f in `find ./fields -maxdepth 1 -type f -name "*" | sort | grep -v "$f0"`
#   do
#       differ=`diff -q $f0 $f | grep -c "differ"`
#       if [ $differ -eq 0 ];then
#           mv "$f" "$schema_folder"
#       fi
#   done
#   mv "$f0" "$schema_folder"

# ======= replaced by xargs parallel mode to speed up processing ======

    find ./fields -maxdepth 1 -type f -name "*" | xargs -P 4 -I 'code' diff -q -s schemas/"$schema" 'code' | grep "identical" | cut -d " " -f 4 | xargs -I '{}' mv '{}' "$schema_folder"
    ls "$schema_folder" > schemas/"$schema".lst
    rm -rf "$schema_folder"
    f0=$(find ./fields -maxdepth 1 -type f -name "*" | sort | head -n 1)
done

rm -rf "$DIL_ROOT"/"$subfolder"/fields
