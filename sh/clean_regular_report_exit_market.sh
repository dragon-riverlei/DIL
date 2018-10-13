#!/usr/local/bin/bash

# Clean data of the companies which have exited the market.

usage(){
    echo "usage:"
    echo "clean_regular_report_exit_market.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

for code in $(cat "$DIL_ROOT"/feeds/stock_code_list_china_exit_market | grep -v "#")
do
    if [ -f $DIL_ROOT/feeds/fdmt_balance_sheet_initial/data/$code.csv ];then
        echo "Delete $DIL_ROOT/feeds/fdmt_balance_sheet_initial/data/$code.csv"
        rm -f $DIL_ROOT/feeds/fdmt_balance_sheet_initial/data/$code.csv
    fi

    if [ -f $DIL_ROOT/feeds/fdmt_balance_sheet_delta/data/$code*.jl ];then
        echo "Delete $DIL_ROOT/feeds/fdmt_balance_sheet_delta/data/$code*.jl"
        rm -f $DIL_ROOT/feeds/fdmt_balance_sheet_delta/data/$code*.jl
    fi

    if [ -f $DIL_ROOT/feeds/fdmt_cash_flow_sheet_initial/data/$code.csv ];then
        echo "Delete $DIL_ROOT/feeds/fdmt_cash_flow_sheet_initial/data/$code.csv"
        rm -f $DIL_ROOT/feeds/fdmt_cash_flow_sheet_initial/data/$code.csv
    fi

    if [ -f $DIL_ROOT/feeds/fdmt_cash_flow_sheet_delta/data/$code*.jl ];then
        echo "Delete $DIL_ROOT/feeds/fdmt_cash_flow_sheet_delta/data/$code*.jl"
        rm -f $DIL_ROOT/feeds/fdmt_cash_flow_sheet_delta/data/$code*.jl
    fi

    if [ -f $DIL_ROOT/feeds/fdmt_profit_sheet_initial/data/$code.csv ];then
        echo "Delete $DIL_ROOT/feeds/fdmt_profit_sheet_initial/data/$code.csv"
        rm -f $DIL_ROOT/feeds/fdmt_profit_sheet_initial/data/$code.csv
    fi

    if [ -f $DIL_ROOT/feeds/fdmt_profit_sheet_delta/data/$code*.jl ];then
        echo "Delete $DIL_ROOT/feeds/fdmt_profit_sheet_delta/data/$code*.jl"
        rm -f $DIL_ROOT/feeds/fdmt_profit_sheet_delta/data/$code*.jl
    fi

    if [ -f $DIL_ROOT/feeds/stock_structure/data/$code*.jl ];then
        echo "Delete $DIL_ROOT/feeds/stock_structure/data/$code*.jl"
        rm -f $DIL_ROOT/feeds/stock_structure/data/$code*.jl
    fi

done
