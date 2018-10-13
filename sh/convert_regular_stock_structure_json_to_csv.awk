#!/usr/bin/env awk

function extract_date(key){
    data[$1][$3][key] = $3
}

function extract_value(key){
    for (date in data[$1]){
        data[$1][date][key] = $3
    }
}

$2=="单位:万股"{
    extract_date(1)
}
$2=="已上市流通A股"{
    extract_value(2)
}
$2=="已流通股份"{
    extract_value(3)
}
$2=="变动原因"{
    extract_value(4)
}
$2=="总股本"{
    extract_value(5)
}
$2=="流通受限股份"{
    extract_value(6)
}
$2=="其他内资持股(受限)"{
    extract_value(7)
}
$2=="国有法人持股(受限)"{
    extract_value(8)
}
$2=="境内自然人持股(受限)"{
    extract_value(9)
}
$2=="国家持股(受限)"{
    extract_value(10)
}
$2=="国家持股"{
    extract_value(11)
}
$2=="境外法人持股(受限)"{
    extract_value(12)
}
$2=="境内法人持股(受限)"{
    extract_value(13)
}
$2=="外资持股(受限)"{
    extract_value(14)
}
$2=="境外上市流通股"{
    extract_value(15)
}
$2=="已上市流通B股"{
    extract_value(16)
}
$2=="未流通股份"{
    extract_value(17)
}
$2=="发起人股份"{
    extract_value(18)
}
$2=="境外自然人持股（受限）"{
    extract_value(19)
}
$2=="自然人持股"{
    extract_value(20)
}
$2=="境内法人持股"{
    extract_value(21)
}
$2=="募集法人股"{
    extract_value(22)
}
$2=="国有法人持股"{
    extract_value(23)
}
$2=="其他未流通股"{
    extract_value(24)
}
$2=="内部职工股"{
    extract_value(25)
}
$2=="其他流通股"{
    extract_value(26)
}
$2=="优先股"{
    extract_value(27)
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
