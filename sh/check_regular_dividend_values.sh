#!/usr/local/bin/bash

# Return an enumeration of values that appear in the dividend report.
# For the value that is numeric, a "yes" is returned.
# For the value that is NOT numeric, it is returned literally.
# By doing do, we can conclude all the possible values in the dividend report.

usage(){
    echo "usage:"
    echo "check_regular_dividend_values.sh"
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

cd "$DIL_ROOT"
cd "feeds/fdmt_dividend/data"

# ======= replaced by xargs parallel mode to speed up processing ======

# for f in $(ls *)
# do
#     cat "$f" | jq -r -f "$DIL_ROOT"/sh/check_regular_dividend_values.jq | \
#         awk -F "," '{for (i=2; i<=NF; i++){if(i!=6){print $i}}}'
# done | sort | uniq

# ======= replaced by xargs parallel mode to speed up processing ======

ls * | xargs -P 4 jq -r -f "$DIL_ROOT"/sh/check_regular_dividend_values.jq | awk -F ',' '{for (i=2; i<=NF; i++){if(i!=6){print $i}}}' | gsort -u
