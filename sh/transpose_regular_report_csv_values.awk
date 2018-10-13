#!/usr/bin/env awk

# The first line of each initial regular report is like this:
# 报表日期	20170930	20170630	20170331	20161231	20160930	20160630	20160331
# "20160331" is the 8th column and is the earliest time stamp in this report.
# This script will search the earliest time stamp up to "20100101".

BEGIN{
    earliest_time = mktime("2010 01 01 00 00 00")
    earliest_col = 0
    row_id = 0
}
FNR==1{
    for(i=2; i<=NF; i++){
        time = gensub(/([0-9]{4})([0-9]{2})([0-9]{2})/, "\\1 \\2 \\3 00 00 00", "g", $i)
        time = mktime(time)
        if(time < earliest_time){
            earliest_col = i - 1
            break
        }
        values[i-2][row_id] = gensub(/([0-9]{4})([0-9]{2})([0-9]{2})/, "\\1-\\2-\\3 00:00:00", "g", $i)
    }
    row_id = row_id + 1
}
FNR>2 && $3!=""{
    for(i=2; i<=earliest_col; i++){
        values[i-2][row_id] = $i
    }
    row_id = row_id + 1
}
END{
    code = gensub(/.*([0-9]{6})\.csv$/, "\\1", "g", FILENAME)
    for (col in values){
        record = code
        for (row in values[col]){
            record = record "," values[col][row]
        }
        print record
    }
}
