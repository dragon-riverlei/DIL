#!/usr/local/bin/bash

# Given a jq filter file and a json line file,
# returns empty if the distinct values extracted by jq are either "--" or "yes" or both of them.
# otherwise returns values that are not the same as the above.

usage(){
    echo "usage:"
    echo "print_distinct_jq_processed_values.sh <jq_filter_file> <json_line_file>"
    exit 1
}

jq -r -f "$1" "$2" | awk -F ',' '{for (i=2; i<=NF; i++){if(i!=6){print $i}}}' | gsort -u | grep -v '"\-\-"' | grep -v '"yes"'
