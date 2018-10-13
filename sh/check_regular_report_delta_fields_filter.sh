#!/usr/local/bin/bash

# Filter out some fields from the schema of the initial regular report to help align the schema with the scraped delta regular report.
# This is because it is possible that not all the fields in initial schema will be presented in delta regular report.

usage(){
    echo "usage:"
    echo "check_regular_report_delta_fields_filter.sh <bs|cfs|ps> <bank|general|securities|insurance>"
    echo ""
    echo "  bs: balance sheet"
    echo "  cfs: cash flow sheet"
    echo "  ps: profit sheet"
    echo ""
    echo "  bank, general, securities, insurance: schema name of the initially (opposed to delta) scraped regular report."
    exit 1
}

# Populate "DIL_ROOT" with proper value
. $(dirname "$0")/env.sh

case "$1" in
    # currently no fields found to break the alignment between initial report and the delta report for balance sheet.
    bs)
        case "$2" in
            bank)
                awk '$1!="--"{print $1}'
                ;;
            general)
                awk '$1!="--"{print $1}'
                ;;
            securities)
                awk '$1!="--"{print $1}'
                ;;
            insurance)
                awk '$1!="--"{print $1}'
                ;;
            *)
                usage
                ;;
        esac
        ;;
    # currently no fields found to break the alignment between initial report and the delta report for cash flow sheet.
    cfs)
        case "$2" in
            bank)
                awk '$1!="--" {print $1}'
                ;;
            general)
                awk '$1!="--" {print $1}'
                ;;
            securities)
                awk '$1!="--" {print $1}'
                ;;
            insurance)
                awk '$1!="--" {print $1}'
                ;;
            *)
                usage
                ;;
        esac
        ;;
    # currently no fields found to break the alignment between initial report and the delta report for profit sheet.
    ps)
        case "$2" in
            bank)
                awk '$1!="--"{print $1}'
                ;;
            general)
                awk '$1!="--"{print $1}'
                ;;
            securities)
                awk '$1!="--"{print $1}'
                ;;
            insurance)
                awk '$1!="--"{print $1}'
                ;;
            *)
                usage
                ;;
        esac
        ;;
    *)
        usage
        ;;
esac
