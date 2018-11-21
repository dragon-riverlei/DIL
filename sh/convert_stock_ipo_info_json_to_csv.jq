# "--" is the only non-numeric value appears in field "ipo_per" in the json file.
# This is verified by calling check_stock_ipo_info_values.sh
# During conversion, "--" is converted to "NULL".

[
  .code,
  .found_time,
  .ipo_time,
  .ipo_price,
  if .ipo_volume | endswith("亿") then .ipo_volume | rtrimstr("亿") | tonumber * 10000 elif .ipo_volume | endswith("万") then .ipo_volume | rtrimstr("万") | tonumber else .ipo_volume | tonumber / 10000 end,
  if .ipo_cap | endswith("亿") then .ipo_cap | rtrimstr("亿") | tonumber * 100000000 elif .ipo_cap | endswith("万") then .ipo_cap | rtrimstr("万") | tonumber * 10000 else .ipo_cap | tonumber end,
  if .ipo_per=="--" then "NULL" else .ipo_per end
]
| @csv
