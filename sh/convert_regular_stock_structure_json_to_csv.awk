#!/usr/bin/env awk

BEGIN{
    last_field = ""
    i = 0
}


function extract_date(count, key){
    data[$1][count][key] = $3
}

function extract_value(count, key){
        data[$1][count][key] = $3
}

last_field != $2{
    i = 0
}

$2=="单位:万股"{
    last_field = $2
    i = i + 1
    extract_date(i, 1)
}
$2=="已上市流通A股"{
    last_field = $2
    i = i + 1
    extract_value(i, 2)
}
$2=="已流通股份"{
    last_field = $2
    i = i + 1
    extract_value(i, 3)
}
$2=="变动原因"{
    last_field = $2
    i = i + 1
    extract_value(i, 4)
}
$2=="总股本"{
    last_field = $2
    i = i + 1
    extract_value(i, 5)
}
$2=="流通受限股份"{
    last_field = $2
    i = i + 1
    extract_value(i, 6)
}
$2=="其他内资持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 7)
}
$2=="国有法人持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 8)
}
$2=="境内自然人持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 9)
}
$2=="国家持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 10)
}
$2=="国家持股"{
    last_field = $2
    i = i + 1
    extract_value(i, 11)
}
$2=="境外法人持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 12)
}
$2=="境内法人持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 13)
}
$2=="外资持股(受限)"{
    last_field = $2
    i = i + 1
    extract_value(i, 14)
}
$2=="境外上市流通股"{
    last_field = $2
    i = i + 1
    extract_value(i, 15)
}
$2=="已上市流通B股"{
    last_field = $2
    i = i + 1
    extract_value(i, 16)
}
$2=="未流通股份"{
    last_field = $2
    i = i + 1
    extract_value(i, 17)
}
$2=="发起人股份"{
    last_field = $2
    i = i + 1
    extract_value(i, 18)
}
$2=="境外自然人持股（受限）"{
    last_field = $2
    i = i + 1
    extract_value(i, 19)
}
$2=="自然人持股"{
    last_field = $2
    i = i + 1
    extract_value(i, 20)
}
$2=="境内法人持股"{
    last_field = $2
    i = i + 1
    extract_value(i, 21)
}
$2=="募集法人股"{
    last_field = $2
    i = i + 1
    extract_value(i, 22)
}
$2=="国有法人持股"{
    last_field = $2
    i = i + 1
    extract_value(i, 23)
}
$2=="其他未流通股"{
    last_field = $2
    i = i + 1
    extract_value(i, 24)
}
$2=="内部职工股"{
    last_field = $2
    i = i + 1
    extract_value(i, 25)
}
$2=="其他流通股"{
    last_field = $2
    i = i + 1
    extract_value(i, 26)
}
$2=="优先股"{
    last_field = $2
    i = i + 1
    extract_value(i, 27)
}
END{
    for (code in data){
        for (date in data[code]){
            line = code
            for (key=1; key<=27; key++){
                d = data[code][date][key]
                if (d == "" || d=="--"){
                    if (key==4){
                        line = line ","
                    }else{
                        line = line ",0"
                    }
                }else{
                    line = line  ","  data[code][date][key]
                }

            }
            print line > dir "/" code ".csv"
        }
    }
}
