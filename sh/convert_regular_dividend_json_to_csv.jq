# "-" is the only non-numeric value appears in dividend json file.
# This is verified by calling check_regular_dividend_values.sh
# During conversion, "-" is converted to "NULL".

[
  .Code, 
  .ReportingPeriod,
  if .YAGGR=="-" then "NULL" else .YAGGR end,
  if .GQDJR=="-" then "NULL" else .GQDJR end,
  if .CQCXR=="-" then "NULL" else .CQCXR end,
  .ProjectProgress,
  if .SZZBL=="-" then "NULL" else .SZZBL end,
  if .SGBL=="-" then "NULL" else .SGBL end,
  if .ZGBL=="-" then "NULL" else .ZGBL end,
  if .XJFH=="-" then "NULL" else .XJFH end,
  if .GXL=="-" then "NULL" else .GXL end,
  if .YAGGRHSRZF=="-" then "NULL" else .YAGGRHSRZF end,
  if .GQDJRQSRZF=="-" then "NULL" else .GQDJRQSRZF end,
  if .CQCXRHSSRZF=="-" then "NULL" else .CQCXRHSSRZF end
]
| @csv
