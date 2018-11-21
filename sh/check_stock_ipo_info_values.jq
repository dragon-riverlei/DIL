[
  if .code | test("[0-9]{6}") then "code yes" else "code " + .code end,
  if .found_time | test ("[0-9]{4}-[0-9]{2}-[0-9]{2}") then "found_time yes" else "found_time " + .found_time end,
  if .ipo_time | test("[0-9]{4}-[0-9]{2}-[0-9]{2}") then "ipo_time yes" else "ipo_time " +.ipo_time end,
  if .ipo_price | test("^[0-9]+(,[0-9]+)*(\\.[0-9]+)?$") then "ipo_price yes" else "ipo_price " + .ipo_price end,
  if .ipo_volume | test("^[0-9]+(,[0-9]+)*(\\.[0-9]+)?[万亿]?$") then "ipo_volume yes" else "ipo_volume " + .ipo_volume + " " + .code end,
  if .ipo_cap | test("^[0-9]+(,[0-9]+)*(\\.[0-9]+)?[万亿]$") then "ipo_cap yes" else "ipo_cap " + .ipo_cap end,
  if .ipo_per | test("^[0-9]+(,[0-9]+)*(\\.[0-9]+)?$") then "ipo_per yes" else "ipo_per " + .ipo_per end
]
| @csv
