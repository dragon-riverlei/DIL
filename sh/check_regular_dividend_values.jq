"20[0-9]{2}-[0-9]{2}-[0-9]{2}T00:00:00" as $time_rexp |
"^-?[0-9]+(,[0-9]+)*(\\.[0-9]+([eE]-?[0-9]+)?)?$" as $numeric_rexp | 
[
  .Code, 
  if .ReportingPeriod | test($time_rexp) then "yes" else .ReportingPeriod end,
  if .YAGGR | test($time_rexp) then "yes" else .YAGGR end,
  if .GQDJR | test($time_rexp) then "yes" else .GQDJR end,
  if .CQCXR | test($time_rexp) then "yes" else .CQCXR end,
  .ProjectProgress,
  if .SZZBL | test($numeric_rexp) then "yes" else .SZZBL end,
  if .SGBL  | test($numeric_rexp) then "yes" else .SGBL end,
  if .ZGBL  | test($numeric_rexp) then "yes" else .ZGBL end,
  if .XJFH  | test($numeric_rexp) then "yes" else .XJFH end,
  if .GXL   | test($numeric_rexp) then "yes" else .GXL end,
  if .YAGGRHSRZF | test($numeric_rexp) then "yes" else .YAGGRHSRZF end,
  if .GQDJRQSRZF | test($numeric_rexp) then "yes" else .GQDJRQSRZF end,
  if .CQCXRHSSRZF | test($numeric_rexp) then "yes" else .CQCXRHSSRZF end
]
| @csv
