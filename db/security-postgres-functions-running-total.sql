drop function if exists securities_profit_sheet_bank_running_total;
create or replace function securities_profit_sheet_bank_running_total(start_year integer, end_year integer)
returns table (psbrt_code varchar(6), psbrt_time date,
               psbrt_营业收入 numeric(20,2), psbrt_营业支出 numeric(20,2),
               psbrt_营业利润 numeric(20,2), psbrt_利润总额 numeric(20,2),
               psbrt_净利润 numeric(20,2), psbrt_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

profit_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

profit_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司的净利润" + "lag1_归属于母公司的净利润" - "lag2_归属于母公司的净利润" "归属于母公司的净利润"
from profit_level2_only
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
from profit_level3_only_3
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
from profit_level3_only_6
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
from profit_level3_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入", "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司的净利润" from securities_profit_sheet_bank
where
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_profit_sheet_general_running_total;
create or replace function securities_profit_sheet_general_running_total(start_year integer, end_year integer)
returns table (psgrt_code varchar(6), psgrt_time date,
               psgrt_营业收入 numeric(20,2), psgrt_营业支出 numeric(20,2),
               psgrt_营业利润 numeric(20,2), psgrt_利润总额 numeric(20,2),
               psgrt_净利润 numeric(20,2), psgrt_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

profit_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

profit_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  "一、营业总收入" + "lag1_一、营业总收入" - "lag2_一、营业总收入" "一、营业收入",
  "二、营业总成本" + "lag1_二、营业总成本" - "lag2_二、营业总成本" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_level2_only
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
from profit_level3_only_3
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
from profit_level3_only_6
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
from profit_level3_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业总收入" "一、营业收入", "二、营业总成本" "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司所有者的净利润" from securities_profit_sheet_general
where
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_profit_sheet_securities_running_total;
create or replace function securities_profit_sheet_securities_running_total(start_year integer, end_year integer)
returns table (pssrt_code varchar(6), pssrt_time date,
               pssrt_营业收入 numeric(20,2), pssrt_营业支出 numeric(20,2),
               pssrt_营业利润 numeric(20,2), pssrt_利润总额 numeric(20,2),
               pssrt_净利润 numeric(20,2),  pssrt_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

profit_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

profit_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司所有者的净利润" + "lag1_归属于母公司所有者的净利润" - "lag2_归属于母公司所有者的净利润" "归属于母公司所有者的净利润"
from profit_level2_only
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
from profit_level3_only_3
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
from profit_level3_only_6
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
from profit_level3_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入", "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司所有者的净利润" from securities_profit_sheet_securities
where
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_profit_sheet_insurance_running_total;
create or replace function securities_profit_sheet_insurance_running_total(start_year integer, end_year integer)
returns table (psirt_code varchar(6), psirt_time date,
               psirt_营业收入 numeric(20,2), psirt_营业支出 numeric(20,2),
               psirt_营业利润 numeric(20,2), psirt_利润总额 numeric(20,2),
               psirt_净利润 numeric(20,2), psirt_归属于母公司股东的净利润 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

profit_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

profit_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

profit_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  "一、营业收入" + "lag1_一、营业收入" - "lag2_一、营业收入" "一、营业收入",
  "二、营业支出" + "lag1_二、营业支出" - "lag2_二、营业支出" "二、营业支出",
  "三、营业利润" + "lag1_三、营业利润" - "lag2_三、营业利润" "三、营业利润",
  "四、利润总额" + "lag1_四、利润总额" - "lag2_四、利润总额" "四、利润总额",
  "五、净利润" + "lag1_五、净利润" - "lag2_五、净利润" "五、净利润",
  "归属于母公司股东的净利润" + "lag1_归属于母公司股东的净利润" - "lag2_归属于母公司股东的净利润" "归属于母公司股东的净利润"
from profit_level2_only
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
from profit_level3_only_3
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
from profit_level3_only_6
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
from profit_level3_only_9
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  "一、营业收入", "二、营业支出",
  "三、营业利润", "四、利润总额", "五、净利润", "归属于母公司股东的净利润" from securities_profit_sheet_insurance
where
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_bank_running_total;
create or replace function securities_cash_flow_sheet_bank_running_total(start_year integer, end_year integer)
returns table (cfsbrt_code varchar(6), cfsbrt_time date,
               cfsbrt_经营活动产生的现金流量净额 numeric(20,2), cfsbrt_投资活动产生的现金流量净额 numeric(20,2),
               cfsbrt_筹资活动产生的现金流量净额 numeric(20,2), cfsbrt_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

cash_flow_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

cash_flow_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level2_only
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_9
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
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_general_running_total;
create or replace function securities_cash_flow_sheet_general_running_total(start_year integer, end_year integer)
returns table (cfsgrt_code varchar(6), cfsgrt_time date,
               cfsgrt_经营活动产生的现金流量净额 numeric(20,2), cfsgrt_投资活动产生的现金流量净额 numeric(20,2),
               cfsgrt_筹资活动产生的现金流量净额 numeric(20,2), cfsgrt_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

cash_flow_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

cash_flow_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level2_only
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_9
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
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_securities_running_total;
create or replace function securities_cash_flow_sheet_securities_running_total(start_year integer, end_year integer)
returns table (cfssrt_code varchar(6), cfssrt_time date,
               cfssrt_经营活动产生的现金流量净额 numeric(20,2), cfssrt_投资活动产生的现金流量净额 numeric(20,2),
               cfssrt_筹资活动产生的现金流量净额 numeric(20,2), cfssrt_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

cash_flow_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

cash_flow_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level2_only
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_9
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
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists securities_cash_flow_sheet_insurance_running_total;
create or replace function securities_cash_flow_sheet_insurance_running_total(start_year integer, end_year integer)
returns table (cfsirt_code varchar(6), cfsirt_time date,
               cfsirt_经营活动产生的现金流量净额 numeric(20,2), cfsirt_投资活动产生的现金流量净额 numeric(20,2),
               cfsirt_筹资活动产生的现金流量净额 numeric(20,2), cfsirt_现金及现金等价物净增加额 numeric(20,2)) as $$
begin
return query (
with
code_level2 as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
),
code_level2_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(2, start_year, end_year)
  except
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),
code_level3_only as (
  select fcwdcl_code from find_code_with_data_completeness_level(3, start_year, end_year)
),

cash_flow_level2_only as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level2_only)
),

cash_flow_level3_only_3 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 3 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_6 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 6 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
),

cash_flow_level3_only_9 as (
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
    extract(year from "time") between start_year and end_year and
    (extract(month from "time")::integer = 9 or extract(month from "time")::integer = 12) and
    code in (select fcwdcl_code from code_level3_only)
)

select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level2_only
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_3
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_6
where extract(month from "time")::integer <> 12
union
select
  code, "time",
  经营活动产生的现金流量净额 + lag1_经营活动产生的现金流量净额 - lag2_经营活动产生的现金流量净额 经营活动产生的现金流量净额,
  投资活动产生的现金流量净额 + lag1_投资活动产生的现金流量净额 - lag2_投资活动产生的现金流量净额 投资活动产生的现金流量净额,
  筹资活动产生的现金流量净额 + lag1_筹资活动产生的现金流量净额 - lag2_筹资活动产生的现金流量净额 筹资活动产生的现金流量净额,
  五、现金及现金等价物净增加额 + lag1_五、现金及现金等价物净增加额 - lag2_五、现金及现金等价物净增加额 现金及现金等价物净增加额
from cash_flow_level3_only_9
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
  extract(year from "time") between start_year and end_year and
  extract(month from "time")::integer = 12 and
  code in (select fcwdcl_code from code_level2)
);
end;
$$ language plpgsql;

drop function if exists insert_securities_profit_sheet_running_total;
create or replace function insert_securities_profit_sheet_running_total(start_year integer, end_year integer) returns integer as $$
declare
  affected_row_count integer := 0;
  psrt_rec record;
  psrt_cur cursor for
    select
      psbrt_code code, psbrt_time "time",
      psbrt_营业收入 营业收入, psbrt_营业支出 营业支出,
      psbrt_营业利润 营业利润, psbrt_利润总额 利润总额,
      psbrt_净利润 净利润, psbrt_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_bank_running_total(start_year, end_year)
    where psbrt_营业收入 is not null
    union
    select
      psgrt_code code, psgrt_time "time",
      psgrt_营业收入 营业收入, psgrt_营业支出 营业支出,
      psgrt_营业利润 营业利润, psgrt_利润总额 利润总额,
      psgrt_净利润 净利润, psgrt_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_general_running_total(start_year, end_year)
    where psgrt_营业收入 is not null
    union
    select
      pssrt_code code, pssrt_time "time",
      pssrt_营业收入 营业收入, pssrt_营业支出 营业支出,
      pssrt_营业利润 营业利润, pssrt_利润总额 利润总额,
      pssrt_净利润 净利润, pssrt_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_securities_running_total(start_year, end_year)
    where pssrt_营业收入 is not null
    union
    select
      psirt_code code, psirt_time "time",
      psirt_营业收入 营业收入, psirt_营业支出 营业支出,
      psirt_营业利润 营业利润, psirt_利润总额 利润总额,
      psirt_净利润 净利润, psirt_归属于母公司股东的净利润 归属于母公司股东的净利润
    from securities_profit_sheet_insurance_running_total(start_year, end_year)
    where psirt_营业收入 is not null;
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

drop function if exists insert_securities_cash_flow_sheet_running_total;
create or replace function insert_securities_cash_flow_sheet_running_total(start_year integer, end_year integer) returns void as $$
begin
drop index if exists  securities_cash_flow_sheet_running_total_idx_year;
drop index if exists  securities_cash_flow_sheet_running_total_idx_month;
insert into securities_cash_flow_sheet_running_total
select
  cfsbrt_code code, cfsbrt_time "time",
  cfsbrt_经营活动产生的现金流量净额, cfsbrt_投资活动产生的现金流量净额,
  cfsbrt_筹资活动产生的现金流量净额, cfsbrt_现金及现金等价物净增加额
from securities_cash_flow_sheet_bank_running_total(start_year, end_year)
where cfsbrt_经营活动产生的现金流量净额 is not null
union
select
  cfsgrt_code code, cfsgrt_time "time",
  cfsgrt_经营活动产生的现金流量净额, cfsgrt_投资活动产生的现金流量净额,
  cfsgrt_筹资活动产生的现金流量净额, cfsgrt_现金及现金等价物净增加额
from securities_cash_flow_sheet_general_running_total(start_year, end_year)
where cfsgrt_经营活动产生的现金流量净额 is not null
union
select
  cfssrt_code code, cfssrt_time "time",
  cfssrt_经营活动产生的现金流量净额, cfssrt_投资活动产生的现金流量净额,
  cfssrt_筹资活动产生的现金流量净额, cfssrt_现金及现金等价物净增加额
from securities_cash_flow_sheet_securities_running_total(start_year, end_year)
where cfssrt_经营活动产生的现金流量净额 is not null
union
select
  cfsirt_code code, cfsirt_time "time",
  cfsirt_经营活动产生的现金流量净额, cfsirt_投资活动产生的现金流量净额,
  cfsirt_筹资活动产生的现金流量净额, cfsirt_现金及现金等价物净增加额
from securities_cash_flow_sheet_insurance_running_total(start_year, end_year)
where cfsirt_经营活动产生的现金流量净额 is not null
on conflict do nothing;
create index securities_cash_flow_sheet_running_total_idx_year on securities_cash_flow_sheet_running_total ((extract(year from time)));
create index securities_cash_flow_sheet_running_total_idx_month on securities_cash_flow_sheet_running_total ((extract(month from time)));
end;
$$ LANGUAGE plpgsql;
