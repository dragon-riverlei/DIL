#!/usr/local/bin/bash

# For the given report type, print out the fields of the scraped delta report of each code.
# The list of fields will be used by other scripts to determine if there is any difference
# between the fields coming from delta report and the fields coming from initial report.

usage(){
    echo "usage:"
    echo "print_regular_report_delta_jq_fields.sh -ce <bs|cfs|ps> <bank|general|securities|insurance>"
    echo ""
    echo "  -c: check, either this one or -e must be specified"
    echo "  -e: extract, either this one or -c must be specified"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report."
    exit 1
}

while getopts ":ce" opt; do
    case ${opt} in
        c)
            jqf_type="check"
            ;;
        e)
            jqf_type="extract"
            ;;
        \?)
            echo "Invalid option: $opt" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

if [ "$jqf_type" == "" ];then
    usage
fi

function print_jq_fields_check(){
    cd "$DIL_ROOT"/"$subfolder"
    numeric_rexp='"^-?[0-9]+(,[0-9]+)*(\\.[0-9]+([eE]-?[0-9]+)?)?$" as $numeric_rexp |'
    echo $numeric_rexp
    echo "["
    paste -d "\0" <(cat "$data_file" | awk -F "\t" '$3==""{print "-- "}$3!=""{print ""}') <(cat "$schema_file" | jq -r 'map(.) | .[]') | awk '$1!="--"{print $1}' | "$DIL_ROOT"/sh/check_regular_report_delta_fields_filter.sh $1 $2 | awk '{print ".\"" $1 "\","}' | tail -r | sed '1 s/,//g' | tail -r | tail -n +3
    # paste -d "\0" <(cat "$data_file" | awk -F "\t" '$3==""{print "-- "}$3!=""{print ""}') <(cat "$schema_file" | awk '{print $2}' | sed 's/}//g') | awk '$1!="--"{print $1}' | "$DIL_ROOT"/sh/check_regular_report_delta_fields_filter.sh $1 $2 | awk '{print "." $1 ","}' | tail -r | sed '1 s/,//g' | tail -r | tail -n +3
    echo "]"
    echo '| map(if . | test($numeric_rexp) then "yes" else . end)'
    echo "| @csv"
}

function print_jq_fields_extract(){
    cd "$DIL_ROOT"/"$subfolder"
    numeric_rexp='"^-?[0-9]+(,[0-9]+)*(\\.[0-9]+([eE]-?[0-9]+)?)?$" as $numeric_rexp |'
    echo $numeric_rexp
    echo "["
    echo ".date,"
    paste -d "\0" <(cat "$data_file" | awk -F "\t" '$3==""{print "-- "}$3!=""{print ""}') <(cat "$schema_file" | jq -r 'map(.) | .[]') | awk '$1!="--"{print $1}' | "$DIL_ROOT"/sh/check_regular_report_delta_fields_filter.sh $1 $2 | awk '{print ".\"" $1 "\","}' | tail -r | sed '1 s/,//g' | tail -r | tail -n +3
    echo "]"
    echo '| map(sub(",";"";"g"))'
    echo '| map(if . =="--" then "0" else . end)'
    echo '| map(if . | test($numeric_rexp) then . | tonumber else . end)'
    echo '| map(if . | isnormal then . * 10000 else . end)'  # 单位从“万元”转换到“元”
    echo "| [\$code, .[]]"
    echo '| @csv'
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    bs)
        subfolder="feeds/fdmt_balance_sheet_initial"
        report_type="balance"
        ;;
    cfs)
        subfolder="feeds/fdmt_cash_flow_sheet_initial"
        report_type="cash_flow"
        ;;
    ps)
        subfolder="feeds/fdmt_profit_sheet_initial"
        report_type="profit"
        ;;
    *)
        usage
        ;;
esac

cd "$DIL_ROOT"/"$subfolder"

case "$2" in
    bank)
        data_file="data/000001.csv"
        schema_file="schemas/000001"
        ;;
    general)
        data_file="data/000002.csv"
        schema_file="schemas/000002"
        ;;
    securities)
        data_file="data/000686.csv"
        schema_file="schemas/000686"
        ;;
    insurance)
        data_file="data/601318.csv"
        schema_file="schemas/601318"
        ;;
    *)
        usage
        ;;
esac

if [ "$jqf_type" == "check" ]; then
    print_jq_fields_check $1 $2
else
    print_jq_fields_extract $1 $2
fi
