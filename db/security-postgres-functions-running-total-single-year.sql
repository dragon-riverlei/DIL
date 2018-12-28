drop function if exists securities_profit_sheet_bank_running_total_single_year;
create or replace function securities_profit_sheet_bank_running_total_single_year(single_year integer)
returns table (psbrtsy_code varchar(6), psbrtsy_time date,
               psbrtsy_营业收入 numeric(20,2), psbrtsy_营业支出 numeric(20,2),
               psbrtsy_营业利润 numeric(20,2), psbrtsy_利润总额 numeric(20,2),
               psbrtsy_净利润 numeric(20,2), psbrtsy_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司的净利润,2) over(partition by code order by "time") lag2_归属于母公司的净利润,
    lag(归属于母公司的净利润,1) over(partition by code order by "time") lag1_归属于母公司的净利润,
    归属于母公司的净利润
  from securities_profit_sheet_bank
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司的净利润,2) over(partition by code order by "time") lag2_归属于母公司的净利润,
    lag(归属于母公司的净利润,1) over(partition by code order by "time") lag1_归属于母公司的净利润,
    归属于母公司的净利润
  from securities_profit_sheet_bank
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司的净利润,2) over(partition by code order by "time") lag2_归属于母公司的净利润,
    lag(归属于母公司的净利润,1) over(partition by code order by "time") lag1_归属于母公司的净利润,
    归属于母公司的净利润
  from securities_profit_sheet_bank
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
)

select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司的净利润" + "lag1_归属于母公司的净利润" - "lag2_归属于母公司的净利润" "归属于母公司的净利润"
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司的净利润" + "lag1_归属于母公司的净利润" - "lag2_归属于母公司的净利润" "归属于母公司的净利润"
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司的净利润" + "lag1_归属于母公司的净利润" - "lag2_归属于母公司的净利润" "归属于母公司的净利润"
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入", "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司的净利润" from securities_profit_sheet_bank
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_profit_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_profit_sheet_general_running_total_single_year;
create or replace function securities_profit_sheet_general_running_total_single_year(single_year integer)
returns table (psgrtsy_code varchar(6), psgrtsy_time date,
               psgrtsy_营业收入 numeric(20,2), psgrtsy_营业支出 numeric(20,2),
               psgrtsy_营业利润 numeric(20,2), psgrtsy_利润总额 numeric(20,2),
               psgrtsy_净利润 numeric(20,2), psgrtsy_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(一、营业总收入,2) over(partition by code order by "time") lag2_一、营业总收入,
    lag(一、营业总收入,1) over(partition by code order by "time") lag1_一、营业总收入,
    一、营业总收入,
    lag(二、营业总成本,2) over(partition by code order by "time") lag2_二、营业总成本,
    lag(二、营业总成本,1) over(partition by code order by "time") lag1_二、营业总成本,
    二、营业总成本,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司所有者的净利润,2) over(partition by code order by "time") lag2_归属于母公司所有者的净利润,
    lag(归属于母公司所有者的净利润,1) over(partition by code order by "time") lag1_归属于母公司所有者的净利润,
    归属于母公司所有者的净利润
  from securities_profit_sheet_general
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(一、营业总收入,2) over(partition by code order by "time") lag2_一、营业总收入,
    lag(一、营业总收入,1) over(partition by code order by "time") lag1_一、营业总收入,
    一、营业总收入,
    lag(二、营业总成本,2) over(partition by code order by "time") lag2_二、营业总成本,
    lag(二、营业总成本,1) over(partition by code order by "time") lag1_二、营业总成本,
    二、营业总成本,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司所有者的净利润,2) over(partition by code order by "time") lag2_归属于母公司所有者的净利润,
    lag(归属于母公司所有者的净利润,1) over(partition by code order by "time") lag1_归属于母公司所有者的净利润,
    归属于母公司所有者的净利润
  from securities_profit_sheet_general
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(一、营业总收入,2) over(partition by code order by "time") lag2_一、营业总收入,
    lag(一、营业总收入,1) over(partition by code order by "time") lag1_一、营业总收入,
    一、营业总收入,
    lag(二、营业总成本,2) over(partition by code order by "time") lag2_二、营业总成本,
    lag(二、营业总成本,1) over(partition by code order by "time") lag1_二、营业总成本,
    二、营业总成本,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司所有者的净利润,2) over(partition by code order by "time") lag2_归属于母公司所有者的净利润,
    lag(归属于母公司所有者的净利润,1) over(partition by code order by "time") lag1_归属于母公司所有者的净利润,
    归属于母公司所有者的净利润
  from securities_profit_sheet_general
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
)

select
  code, "time",
  "一、营业总收入" + "lag1_一、营业总收入" - "lag2_一、营业总收入" "一、营业收入",
  "二、营业总成本" + "lag1_二、营业总成本" - "lag2_二、营业总成本" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业总收入" + "lag1_一、营业总收入" - "lag2_一、营业总收入" "一、营业收入",
  "二、营业总成本" + "lag1_二、营业总成本" - "lag2_二、营业总成本" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业总收入" + "lag1_一、营业总收入" - "lag2_一、营业总收入" "一、营业收入",
  "二、营业总成本" + "lag1_二、营业总成本" - "lag2_二、营业总成本" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业总收入" "一、营业收入", "二、营业总成本" "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司所有者的净利润" from securities_profit_sheet_general
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_profit_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_profit_sheet_securities_running_total_single_year;
create or replace function securities_profit_sheet_securities_running_total_single_year(single_year integer)
returns table (pssrtsy_code varchar(6), pssrtsy_time date,
               pssrtsy_营业收入 numeric(20,2), pssrtsy_营业支出 numeric(20,2),
               pssrtsy_营业利润 numeric(20,2), pssrtsy_利润总额 numeric(20,2),
               pssrtsy_净利润 numeric(20,2), pssrtsy_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司所有者的净利润,2) over(partition by code order by "time") lag2_归属于母公司所有者的净利润,
    lag(归属于母公司所有者的净利润,1) over(partition by code order by "time") lag1_归属于母公司所有者的净利润,
    归属于母公司所有者的净利润
  from securities_profit_sheet_securities
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司所有者的净利润,2) over(partition by code order by "time") lag2_归属于母公司所有者的净利润,
    lag(归属于母公司所有者的净利润,1) over(partition by code order by "time") lag1_归属于母公司所有者的净利润,
    归属于母公司所有者的净利润
  from securities_profit_sheet_securities
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司所有者的净利润,2) over(partition by code order by "time") lag2_归属于母公司所有者的净利润,
    lag(归属于母公司所有者的净利润,1) over(partition by code order by "time") lag1_归属于母公司所有者的净利润,
    归属于母公司所有者的净利润
  from securities_profit_sheet_securities
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
)

select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入", "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司所有者的净利润" from securities_profit_sheet_securities
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_profit_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_profit_sheet_insurance_running_total_single_year;
create or replace function securities_profit_sheet_insurance_running_total_single_year(single_year integer)
returns table (psirtsy_code varchar(6), psirtsy_time date,
               psirtsy_营业收入 numeric(20,2), psirtsy_营业支出 numeric(20,2),
               psirtsy_营业利润 numeric(20,2), psirtsy_利润总额 numeric(20,2),
               psirtsy_净利润 numeric(20,2), psirtsy_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司股东的净利润,2) over(partition by code order by "time") lag2_归属于母公司股东的净利润,
    lag(归属于母公司股东的净利润,1) over(partition by code order by "time") lag1_归属于母公司股东的净利润,
    归属于母公司股东的净利润
  from securities_profit_sheet_insurance
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司股东的净利润,2) over(partition by code order by "time") lag2_归属于母公司股东的净利润,
    lag(归属于母公司股东的净利润,1) over(partition by code order by "time") lag1_归属于母公司股东的净利润,
    归属于母公司股东的净利润
  from securities_profit_sheet_insurance
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(一、营业收入,2) over(partition by code order by "time") lag2_一、营业收入,
    lag(一、营业收入,1) over(partition by code order by "time") lag1_一、营业收入,
    一、营业收入,
    lag(二、营业支出,2) over(partition by code order by "time") lag2_二、营业支出,
    lag(二、营业支出,1) over(partition by code order by "time") lag1_二、营业支出,
    二、营业支出,
    lag(三、营业利润,2) over(partition by code order by "time") lag2_三、营业利润,
    lag(三、营业利润,1) over(partition by code order by "time") lag1_三、营业利润,
    三、营业利润,
    lag(四、利润总额,2) over(partition by code order by "time") lag2_四、利润总额,
    lag(四、利润总额,1) over(partition by code order by "time") lag1_四、利润总额,
    四、利润总额,
    lag(五、净利润,2) over(partition by code order by "time") lag2_五、净利润,
    lag(五、净利润,1) over(partition by code order by "time") lag1_五、净利润,
    五、净利润,
    lag(归属于母公司股东的净利润,2) over(partition by code order by "time") lag2_归属于母公司股东的净利润,
    lag(归属于母公司股东的净利润,1) over(partition by code order by "time") lag1_归属于母公司股东的净利润,
    归属于母公司股东的净利润
  from securities_profit_sheet_insurance
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_profit_sheet_running_total)
)

select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司股东的净利润" + "lag1_归属于母公司股东的净利润" - "lag2_归属于母公司股东的净利润" "归属于母公司股东的净利润"
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司股东的净利润" + "lag1_归属于母公司股东的净利润" - "lag2_归属于母公司股东的净利润" "归属于母公司股东的净利润"
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司股东的净利润" + "lag1_归属于母公司股东的净利润" - "lag2_归属于母公司股东的净利润" "归属于母公司股东的净利润"
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入", "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司股东的净利润" from securities_profit_sheet_insurance
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_profit_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_bank_running_total_single_year;
create or replace function securities_cash_flow_sheet_bank_running_total_single_year(single_year integer)
returns table (cfsbrtsy_code varchar(6), cfsbrtsy_time date,
               cfsbrtsy_经营活动产生的现金流量净额 numeric(20,2), cfsbrtsy_投资活动产生的现金流量净额 numeric(20,2),
               cfsbrtsy_筹资活动产生的现金流量净额 numeric(20,2), cfsbrtsy_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_bank
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_bank
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_bank
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额,
  投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 现金及现金等价物净增加额
from securities_cash_flow_sheet_bank
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_cash_flow_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_general_running_total_single_year;
create or replace function securities_cash_flow_sheet_general_running_total_single_year(single_year integer)
returns table (cfsgrtsy_code varchar(6), cfsgrtsy_time date,
               cfsgrtsy_经营活动产生的现金流量净额 numeric(20,2), cfsgrtsy_投资活动产生的现金流量净额 numeric(20,2),
               cfsgrtsy_筹资活动产生的现金流量净额 numeric(20,2), cfsgrtsy_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_general
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_general
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_general
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额,
  投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 现金及现金等价物净增加额
from securities_cash_flow_sheet_general
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_cash_flow_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_securities_running_total_single_year;
create or replace function securities_cash_flow_sheet_securities_running_total_single_year(single_year integer)
returns table (cfssrtsy_code varchar(6), cfssrtsy_time date,
               cfssrtsy_经营活动产生的现金流量净额 numeric(20,2), cfssrtsy_投资活动产生的现金流量净额 numeric(20,2),
               cfssrtsy_筹资活动产生的现金流量净额 numeric(20,2), cfssrtsy_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_securities
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_securities
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_securities
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额,
  投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 现金及现金等价物净增加额
from securities_cash_flow_sheet_securities
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_cash_flow_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_insurance_running_total_single_year;
create or replace function securities_cash_flow_sheet_insurance_running_total_single_year(single_year integer)
returns table (cfsirtsy_code varchar(6), cfsirtsy_time date,
               cfsirtsy_经营活动产生的现金流量净额 numeric(20,2), cfsirtsy_投资活动产生的现金流量净额 numeric(20,2),
               cfsirtsy_筹资活动产生的现金流量净额 numeric(20,2), cfsirtsy_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
profit_only_3 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_insurance
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_6 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_insurance
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
),
profit_only_9 as (
  select code, "time",
    lag(经营活动产生的现金流量净额,2) over(partition by code order by "time") lag2_经营活动产生的现金流量净额,
    lag(经营活动产生的现金流量净额,1) over(partition by code order by "time") lag1_经营活动产生的现金流量净额,
    经营活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_投资活动产生的现金流量净额,
    lag(投资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_投资活动产生的现金流量净额,
    投资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,2) over(partition by code order by "time") lag2_筹资活动产生的现金流量净额,
    lag(筹资活动产生的现金流量净额,1) over(partition by code order by "time") lag1_筹资活动产生的现金流量净额,
    筹资活动产生的现金流量净额,
    lag(五、现金及现金等价物净增加额,2) over(partition by code order by "time") lag2_五、现金及现金等价物净增加额,
    lag(五、现金及现金等价物净增加额,1) over(partition by code order by "time") lag1_五、现金及现金等价物净增加额,
    五、现金及现金等价物净增加额
  from securities_cash_flow_sheet_insurance
  where
    (extract(year from "time") = single_year or extract(year from "time") = single_year - 1 ) and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select distinct code from securities_cash_flow_sheet_running_total)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from profit_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额,
  投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 现金及现金等价物净增加额
from securities_cash_flow_sheet_insurance
where
  extract(year from "time") = single_year and
  extract(month from "time")::integer = 12 and
  code in (select distinct code from securities_cash_flow_sheet_running_total)
);
end;
$$ language plpgsql;

drop function if exists insert_securities_profit_sheet_running_total_single_year;
create or replace function insert_securities_profit_sheet_running_total_single_year(single_year integer) returns integer as $$
declare
  affected_row_count integer := 0;
  psrt_rec record;
  psrt_cur cursor for
    select
      psbrtsy_code code, psbrtsy_time "time",
      psbrtsy_营业收入 营业收入, psbrtsy_营业支出 营业支出,
      psbrtsy_营业利润 营业利润, psbrtsy_利润总额 利润总额,
      psbrtsy_净利润 净利润, psbrtsy_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_bank_running_total_single_year(single_year)
    where psbrtsy_营业收入 is not null
    union
    select
      psgrtsy_code code, psgrtsy_time "time",
      psgrtsy_营业收入 营业收入, psgrtsy_营业支出 营业支出,
      psgrtsy_营业利润 营业利润, psgrtsy_利润总额 利润总额,
      psgrtsy_净利润 净利润, psgrtsy_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_general_running_total_single_year(single_year)
    where psgrtsy_营业收入 is not null
    union
    select
      pssrtsy_code code, pssrtsy_time "time",
      pssrtsy_营业收入 营业收入, pssrtsy_营业支出 营业支出,
      pssrtsy_营业利润 营业利润, pssrtsy_利润总额 利润总额,
      pssrtsy_净利润 净利润, pssrtsy_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_securities_running_total_single_year(single_year)
    where pssrtsy_营业收入 is not null
    union
    select
      psirtsy_code code, psirtsy_time "time",
      psirtsy_营业收入 营业收入, psirtsy_营业支出 营业支出,
      psirtsy_营业利润 营业利润, psirtsy_利润总额 利润总额,
      psirtsy_净利润 净利润, psirtsy_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_insurance_running_total_single_year(single_year)
    where psirtsy_营业收入 is not null;
begin
perform drop_index_securities_profit_sheet_running_total();
open psrt_cur;
loop
  fetch psrt_cur into psrt_rec;
  exit when not found;
  insert into securities_profit_sheet_running_total(code, "time", 营业收入, 营业支出, 营业利润, 利润总额, 净利润, 归属于母公司股东的净利润)
  values (psrt_rec.code, psrt_rec."time", psrt_rec.营业收入, psrt_rec.营业支出, psrt_rec.营业利润, psrt_rec.利润总额, psrt_rec.净利润, psrt_rec.归属于母公司股东的净利润)
  on conflict (code, "time") do update set
    code = excluded.code,
    "time" = excluded. "time",
    营业收入 = excluded.营业收入,
    营业支出 = excluded.营业支出,
    营业利润 = excluded.营业利润,
    利润总额 = excluded.利润总额,
    净利润   = excluded.净利润,
    归属于母公司股东的净利润 = excluded.归属于母公司股东的净利润;
  affected_row_count = affected_row_count + 1;
end loop;
close psrt_cur;
perform create_index_securities_profit_sheet_running_total();
return affected_row_count;
end;
$$ LANGUAGE plpgsql;

drop function if exists insert_securities_cash_flow_sheet_running_total_single_year;
create or replace function insert_securities_cash_flow_sheet_running_total_single_year(single_year integer) returns void as $$
begin
drop index if exists  securities_cash_flow_sheet_running_total_idx_year;
drop index if exists  securities_cash_flow_sheet_running_total_idx_month;
insert into securities_cash_flow_sheet_running_total
select
  cfsbrtsy_code code, cfsbrtsy_time "time",
  cfsbrtsy_经营活动产生的现金流量净额, cfsbrtsy_投资活动产生的现金流量净额,
  cfsbrtsy_筹资活动产生的现金流量净额, cfsbrtsy_现金及现金等价物净增加额
from securities_cash_flow_sheet_bank_running_total_single_year(single_year)
where cfsbrtsy_经营活动产生的现金流量净额 is not null
union
select
  cfsgrtsy_code code, cfsgrtsy_time "time",
  cfsgrtsy_经营活动产生的现金流量净额, cfsgrtsy_投资活动产生的现金流量净额,
  cfsgrtsy_筹资活动产生的现金流量净额, cfsgrtsy_现金及现金等价物净增加额
from securities_cash_flow_sheet_general_running_total_single_year(single_year)
where cfsgrtsy_经营活动产生的现金流量净额 is not null
union
select
  cfssrtsy_code code, cfssrtsy_time "time",
  cfssrtsy_经营活动产生的现金流量净额, cfssrtsy_投资活动产生的现金流量净额,
  cfssrtsy_筹资活动产生的现金流量净额, cfssrtsy_现金及现金等价物净增加额
from securities_cash_flow_sheet_securities_running_total_single_year(single_year)
where cfssrtsy_经营活动产生的现金流量净额 is not null
union
select
  cfsirtsy_code code, cfsirtsy_time "time",
  cfsirtsy_经营活动产生的现金流量净额, cfsirtsy_投资活动产生的现金流量净额,
  cfsirtsy_筹资活动产生的现金流量净额, cfsirtsy_现金及现金等价物净增加额
from securities_cash_flow_sheet_insurance_running_total_single_year(single_year)
where cfsirtsy_经营活动产生的现金流量净额 is not null
on conflict do nothing;
create index securities_cash_flow_sheet_running_total_idx_year on securities_cash_flow_sheet_running_total ((extract(year from time)));
create index securities_cash_flow_sheet_running_total_idx_month on securities_cash_flow_sheet_running_total ((extract(month from time)));
end;
$$ LANGUAGE plpgsql;
