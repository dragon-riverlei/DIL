-- ====================================
-- Stored procedure definitions
-- ====================================

-- data_status: 汇总目前数据库中所收集数据的状态
-- find_code_time: 在表中查找包含在start_year和end_year年份范围内的记录
-- find_code_with_missing_months
-- find_code_with_missing_years
-- report_code_with_missing_months
-- report_code_with_missing_years
-- transaction_soldout_subtotal: 已结实盈(清仓个股)，曾经持有，目前清仓的证券
-- transaction_soldout_total: 已结实盈(清仓汇总)，曾经持有，目前清仓的证券
-- transaction_dividend_subtotal: 已结实盈(分红个股)，分红
-- transaction_dividend_total: 已结实盈(分红汇总)，分红
-- transaction_holding_subtotal: 浮盈（个股）
-- transaction_holding_total: 浮盈（汇总）
-- insert_securities_kpi: 新增给定日期之后的KPI记录
-- investment_earning: 投资收益（给定时间区间）
-- short_list: 条件选股，返回详细信息
-- short_list_default: 条件选股（使用缺省条件），返回详细信息
-- short_list_code: 条件选股，只返回代码和名称
-- short_list_code_default: 条件选股（使用缺省条件），只返回代码和名称

-- 计算指定时期投资账户的投资盈利P：
--     期初持有证券的总市值 S0
--     期初持有现金 C0
--     期末持有证券的总市值 S1
--     期末持有现金 C1
--     期间银证转帐流入资金净额 Cn = Ci - Co (Ci: 流入，Co: 流出)
--     P = S1 + C1 - S0 - C0 - Cn
-- 计算指定时期的已结实盈P1和浮动盈亏P2:
--     已结实盈又可分为：
--         期末清仓证券所获价差盈利
--         证券分红（不包括红股）
--     浮动盈亏：
--         期末持有的证券：
--             期初已持有：期初持有数量，期初价格
--             期间购入：每次购买数量和购买价格
--             所得红股


-- 在表中查找包含在start_year和end_year年份范围内的记录，
-- 并返回code和time字段
drop function if exists find_code_time;
create or replace function find_code_time(tbl regclass, start_year integer, end_year integer)
returns table (code varchar(6), "time" date) as $$
  begin
    return query execute format(
      '
      select distinct code, time from (
        select code, time from %s
        where extract(year from time) between %s and %s
      ) t1;
      ', tbl, start_year, end_year);
  end;
$$ language plpgsql;

-- 在表中查找满足以下条件的记录：
--     在start_year和end_year年份范围内,
--     最新年份等于end_year
--     且年份在start_year和end_year内有中断的记录，
-- 并返回以下字段:
--     code,
--     actual_years, 实际年份
--     expected_years, 期望年份
--     year_low_bound, 最旧年份
--     year_upper_bound, 最新年份
drop function if exists find_code_with_missing_years;
create or replace function find_code_with_missing_years(tbl regclass, start_year integer, end_year integer)
returns table (fcwmy_code varchar(6), fcwmy_actual_years integer[], fcwmy_expected_years integer[], fcwmy_year_low_bound integer, fcwmy_year_upper_bound integer) as $$
  begin
  return query
      select code, actual_years, expected_years, year_low_bound, year_upper_bound from (
        select
          code,
          array_agg(year) actual_years,
          min(year) year_low_bound,
          max(year) year_upper_bound
        from (
          select distinct code, extract(year from time)::integer "year" from find_code_time(tbl, start_year, end_year) order by "year"
        ) o1
        group by code
        having max(year) = end_year
        order by code, year_low_bound
      ) o2
      join lateral (
        select year_arr expected_years from (
          select array_agg(series) year_arr from generate_series(o2.year_low_bound, o2.year_upper_bound) as series
        ) o3
      ) o4
      on true
      where actual_years <> expected_years;
  end;
$$ language plpgsql;

-- 在表中查找满足以下条件的记录：
--     在start_year和end_year年份范围内,
--     最新年份等于end_year
--     且年份在start_year和end_year内有中断的记录，
-- 并返回以下字段:
--     code,
--     missing_years, 缺失年份（实际年份相对于期望年份）
--     year_low_bound, 最旧年份
--     year_upper_bound, 最新年份
drop function if exists report_code_with_missing_years;
create or replace function report_code_with_missing_years(tbl regclass, start_year integer, end_year integer)
returns table (rcwmy_code varchar(6), rcwmy_name varchar(10), rcwmy_missing_years integer[], rcwmy_year_low_bound integer, rcwmy_year_upper_bound integer) as $$
  begin
  return query
    select t4.code, sc.name, missing_years, year_low_bound, year_upper_bound from (
      select
        t2.code,
        array_agg(years) missing_years,
        max(fcwmy_year_low_bound) year_low_bound,
        max(fcwmy_year_upper_bound) year_upper_bound
        from (
          select code, years from (
            select fcwmy_code code, unnest(fcwmy_expected_years) years from find_code_with_missing_years(tbl, start_year, end_year)
            except
            select fcwmy_code code, unnest(fcwmy_actual_years) years from find_code_with_missing_years(tbl, start_year, end_year)
        ) t1 order by code, years
      ) t2
      join (
        select distinct fcwmy_code code, fcwmy_year_low_bound, fcwmy_year_upper_bound from find_code_with_missing_years(tbl, start_year, end_year)
      ) t3 on t3.code = t2.code
      group by t2.code order by t2.code
    ) t4
    join securities_code sc on sc.code = t4.code;
  end;
$$ language plpgsql;

-- 在表中查找满足以下条件的记录：
--     在start_year和end_year年份范围内,
--     最新年份等于end_year
--     并且年份在start_year和end_year内“没有”中断，
--     并且月份缺失expected_months中的任意一个或多个
-- 并返回以下字段:
--     code,
--     year, 年份
--     actual_months，实际有的月份
drop function if exists find_code_with_missing_months;
create or replace function find_code_with_missing_months(tbl regclass, start_year integer, end_year integer, expected_months integer[])
returns table (fcwmm_code varchar(6), fcwmm_year integer, fcwmm_actual_months integer[]) as $$
  begin
  return query
    select distinct
      code,
      extract(year from time)::integer "year",
      array_agg(extract(month from time)::integer) months
    from find_code_time(tbl, start_year, end_year)
    where code not in (
      select fcwmy_code from find_code_with_missing_years(tbl, start_year, end_year)
    )
    group by code, "year"
    having not array_agg(extract(month from time)::integer) @> expected_months
    order by code, "year";
  end;
$$ language plpgsql;

-- 在表中查找满足以下条件的记录：
--     在start_year和end_year年份范围内,
--     最新年份等于end_year
--     并且年份在start_year和end_year内“没有”中断，
--     并且月份缺失expected_months中的任意一个或多个
-- 并返回以下字段:
--     code,
--     name,
--     year, 年份
--     missing_months，缺失的月份
drop function if exists report_code_with_missing_months;
create or replace function report_code_with_missing_months(tbl regclass, start_year integer, end_year integer, expected_months integer[])
returns table (rcwmm_code varchar(6), rcwmm_name varchar(10), rcwmm_year integer, rcwmm_missing_months integer[]) as $$
  begin
  return query
    select t3.code, sc.name, t3.year, t3.missing_months from (
      select code, "year", array_agg("month") missing_months from (
        select code, "year", "month" from (
          select fcwmm_code code, fcwmm_year "year", unnest(expected_months) "month" from find_code_with_missing_months(tbl, start_year, end_year, expected_months)
          except
          select fcwmm_code code, fcwmm_year "year", unnest(fcwmm_actual_months) "month" from find_code_with_missing_months(tbl, start_year, end_year, expected_months)
        ) t1 order by code, "year", "month"
      ) t2 group by t2.code, "year"
    ) t3
    join securities_code sc on sc.code = t3.code;
  end;
$$ language plpgsql;

drop function if exists find_code_with_data_completeness_level;
create or replace function find_code_with_data_completeness_level(
  level integer, start_year integer, end_year integer,
  cur_expected_months integer[] default array[]::integer[])
returns table (fcwdcl_code varchar(6), fcwdcl_name varchar(10)) as $$
  declare
    pre_expected_months integer[];
    this_year integer := extract(year from now())::integer;
  begin
  case level
    when 1 then
      pre_expected_months := array[]::integer[];
    when 2 then
      pre_expected_months := array[6,12];
    when 3 then
      pre_expected_months := array[3,6,9,12];
    else
      raise exception 'Unexpected level %.', level;
  end case;
  return query
    select sc.code, sc.name from securities_code sc where sc.code not in (
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_bank', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_general', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_insurance', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_securities', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_bank', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_general', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_insurance', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_securities', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_bank', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_general', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_insurance', start_year, end_year, pre_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_securities', start_year, end_year, pre_expected_months)
    )
    intersect
    select sc.code, sc.name from securities_code sc where sc.code not in (
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_bank', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_general', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_insurance', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_balance_sheet_securities', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_bank', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_general', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_insurance', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_cash_flow_sheet_securities', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_bank', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_general', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_insurance', this_year, this_year, cur_expected_months)
      union
      select fcwmm_code from find_code_with_missing_months('securities_profit_sheet_securities', this_year, this_year, cur_expected_months)
    );
  end;
$$ language plpgsql;

drop function if exists find_code_with_ipo_maturity_level;
create or replace function find_code_with_ipo_maturity_level(level integer)
returns table (fcwiml_code varchar(6), fcwiml_name varchar(10)) as $$
  declare
    low_bound integer;
    high_bound integer;
  begin
  case level
    when 1 then low_bound = 0; high_bound = 3;
    when 2 then low_bound = 3; high_bound = 6;
    when 3 then low_bound = 6; high_bound = 10;
    when 4 then low_bound = 10; high_bound = 10000;
    else
      raise exception 'Unexpected level %.', level;
  end case;
  return query
    select sc.code, sc.name from securities_code sc
    join securities_ipo si on si.code = sc.code
    where
      extract(year from age(now(), si.ipo_time)) >= low_bound and
      extract(year from age(now(), si.ipo_time)) < high_bound;
  end;
$$ language plpgsql;

drop function if exists securities_kpis_1;
create or replace function securities_kpis_1(start_year integer, end_year integer)
returns table (code varchar(6), "time" date,
               营业利润vs营业收入 numeric(20,4), 净利润vs营业收入     numeric(20,4),
               净利润vs利润总额   numeric(20,4), 净利润vs股东权益合计 numeric(20,4)) as $$
begin
return query
select
  psrt.code, psrt."time",
  case when psrt.营业收入 = 0 then null else round(psrt.营业利润/psrt.营业收入*100,4)     end 营业利润vs营业收入,
  case when psrt.营业收入 = 0 then null else round(psrt.净利润/psrt.营业收入*100,4)       end 净利润vs营业收入,
  case when psrt.利润总额 = 0 then null else round(psrt.净利润/psrt.利润总额*100,4)       end 净利润vs利润总额,
  case when bsb.股东权益合计 = 0 then null else round(psrt.净利润/bsb.股东权益合计*100,4) end 净利润vs股东权益合计
from securities_profit_sheet_running_total psrt
join securities_balance_sheet_bank bsb on psrt.code = bsb.code and psrt."time" = bsb."time"
where extract(year from psrt."time") between start_year and end_year
union
select
  psrt.code, psrt."time",
  case when psrt.营业收入 = 0 then null else round(psrt.营业利润/psrt.营业收入*100,4)     end 营业利润vs营业收入,
  case when psrt.营业收入 = 0 then null else round(psrt.净利润/psrt.营业收入*100,4)       end 净利润vs营业收入,
  case when psrt.利润总额 = 0 then null else round(psrt.净利润/psrt.利润总额*100,4)       end 净利润vs利润总额,
  case when bsg.所有者权益（或股东权益）合计 = 0 then null else round(psrt.净利润/bsg.所有者权益（或股东权益）合计*100,4) end 净利润vs股东权益合计
from securities_profit_sheet_running_total psrt
join securities_balance_sheet_general bsg on psrt.code = bsg.code and psrt."time" = bsg."time"
where extract(year from psrt."time") between start_year and end_year
union
select
  psrt.code, psrt."time",
  case when psrt.营业收入 = 0 then null else round(psrt.营业利润/psrt.营业收入*100,4)         end 营业利润vs营业收入,
  case when psrt.营业收入 = 0 then null else round(psrt.净利润/psrt.营业收入*100,4)           end 净利润vs营业收入,
  case when psrt.利润总额 = 0 then null else round(psrt.净利润/psrt.利润总额*100,4)           end 净利润vs利润总额,
  case when bss.所有者权益合计 = 0 then null else round(psrt.净利润/bss.所有者权益合计*100,4) end 净利润vs股东权益合计
from securities_profit_sheet_running_total psrt
join securities_balance_sheet_securities bss on psrt.code = bss.code and psrt."time" = bss."time"
where extract(year from psrt."time") between start_year and end_year
union
select
  psrt.code, psrt."time",
  case when psrt.营业收入 = 0 then null else round(psrt.营业利润/psrt.营业收入*100,4)         end 营业利润vs营业收入,
  case when psrt.营业收入 = 0 then null else round(psrt.净利润/psrt.营业收入*100,4)           end 净利润vs营业收入,
  case when psrt.利润总额 = 0 then null else round(psrt.净利润/psrt.利润总额*100,4)           end 净利润vs利润总额,
  case when bsi.所有者权益合计 = 0 then null else round(psrt.净利润/bsi.所有者权益合计*100,4) end 净利润vs股东权益合计
from securities_profit_sheet_running_total psrt
join securities_balance_sheet_insurance bsi on psrt.code = bsi.code and psrt."time" = bsi."time"
where extract(year from psrt."time") between start_year and end_year;
end;
$$ language plpgsql;

drop function if exists securities_kpis_2;
create or replace function securities_kpis_2(start_year integer, end_year integer)
returns table (code varchar(6), "time" date,
               营业收入同比 numeric(20,4),
               营业利润同比 numeric(20,4),
               净利润同比 numeric(20,4),
               营业收入环比 numeric(20,4),
               营业利润环比 numeric(20,4),
               净利润环比 numeric(20,4),
               经营活动产生的现金流量净额同比 numeric(20,4),
               投资活动产生的现金流量净额同比 numeric(20,4),
               筹资活动产生的现金流量净额同比 numeric(20,4),
               现金及现金等价物净增加额同比 numeric(20,4),
               经营活动产生的现金流量净额环比 numeric(20,4),
               投资活动产生的现金流量净额环比 numeric(20,4),
               筹资活动产生的现金流量净额环比 numeric(20,4),
               现金及现金等价物净增加额环比 numeric(20,4)) as $$
begin
return query
select
  psrt1.code, psrt1."time",
  case when psrt2.营业收入 is not null and psrt2.营业收入 <> 0
       then round((psrt1.营业收入 - psrt2.营业收入) / psrt2.营业收入 * 100, 4)
       else null end 营业收入同比,
  case when psrt2.营业利润 is not null and psrt2.营业利润 <> 0
  then round((psrt1.营业利润 - psrt2.营业利润) / psrt2.营业利润 * 100, 4)
       else null end 营业利润同比,
  case when psrt2.净利润 is not null and psrt2.净利润 <> 0
       then round((psrt1.净利润 - psrt2.净利润) / psrt2.净利润 * 100, 4)
       else null end 净利润同比,

  case when psrt3.营业收入 is not null and psrt3.营业收入 <> 0
       then round((psrt1.营业收入 - psrt3.营业收入) / psrt3.营业收入 * 100, 4)
       else null end 营业收入环比,
  case when psrt3.营业利润 is not null and psrt3.营业利润 <> 0
       then round((psrt1.营业利润 - psrt3.营业利润) / psrt3.营业利润 * 100, 4)
       else null end 营业利润环比,
  case when psrt3.净利润 is not null and psrt3.净利润 <> 0
       then round((psrt1.净利润 - psrt3.净利润) / psrt3.净利润 * 100, 4)
       else null end 净利润环比,

  case when psrt5.经营活动产生的现金流量净额 is not null and psrt5.经营活动产生的现金流量净额 <> 0
       then round((psrt4.经营活动产生的现金流量净额 - psrt5.经营活动产生的现金流量净额) / psrt5.经营活动产生的现金流量净额 * 100, 4)
       else null end 经营活动产生的现金流量净额同比,
  case when psrt5.投资活动产生的现金流量净额 is not null and psrt5.投资活动产生的现金流量净额 <> 0
       then round((psrt4.投资活动产生的现金流量净额 - psrt5.投资活动产生的现金流量净额) / psrt5.投资活动产生的现金流量净额 * 100, 4)
       else null end 投资活动产生的现金流量净额同比,
  case when psrt5.筹资活动产生的现金流量净额 is not null and psrt5.筹资活动产生的现金流量净额 <> 0
       then round((psrt4.筹资活动产生的现金流量净额 - psrt5.筹资活动产生的现金流量净额) / psrt5.筹资活动产生的现金流量净额 * 100, 4)
       else null end 筹资活动产生的现金流量净额同比,
  case when psrt5.现金及现金等价物净增加额 is not null and psrt5.现金及现金等价物净增加额 <> 0
       then round((psrt4.现金及现金等价物净增加额 - psrt5.现金及现金等价物净增加额) / psrt5.现金及现金等价物净增加额 * 100, 4)
       else null end 现金及现金等价物净增加额同比,

  case when psrt6.经营活动产生的现金流量净额 is not null and psrt6.经营活动产生的现金流量净额 <> 0
       then round((psrt4.经营活动产生的现金流量净额 - psrt6.经营活动产生的现金流量净额) / psrt6.经营活动产生的现金流量净额 * 100, 4)
       else null end 经营活动产生的现金流量净额环比,
  case when psrt6.投资活动产生的现金流量净额 is not null and psrt6.投资活动产生的现金流量净额 <> 0
       then round((psrt4.投资活动产生的现金流量净额 - psrt6.投资活动产生的现金流量净额) / psrt6.投资活动产生的现金流量净额 * 100, 4)
       else null end 投资活动产生的现金流量净额环比,
  case when psrt6.筹资活动产生的现金流量净额 is not null and psrt6.筹资活动产生的现金流量净额 <> 0
       then round((psrt4.筹资活动产生的现金流量净额 - psrt6.筹资活动产生的现金流量净额) / psrt6.筹资活动产生的现金流量净额 * 100, 4)
       else null end 筹资活动产生的现金流量净额环比,
  case when psrt6.现金及现金等价物净增加额 is not null and psrt6.现金及现金等价物净增加额 <> 0
       then round((psrt4.现金及现金等价物净增加额 - psrt6.现金及现金等价物净增加额) / psrt6.现金及现金等价物净增加额 * 100, 4)
       else null end 现金及现金等价物净增加额环比
from securities_profit_sheet_running_total psrt1
left join (
select
  t.code, t."time", 营业收入, 营业利润, 净利润
from securities_profit_sheet_running_total t
) psrt2 on psrt1.code = psrt2.code and psrt1."time" = psrt2."time" + interval '1 year'
left join (
select
  t.code, t."time", 营业收入, 营业利润, 净利润
from securities_profit_sheet_running_total t
) psrt3 on psrt1.code = psrt3.code and date_trunc('quarter', psrt1."time"::timestamp) = date_trunc('quarter', psrt3."time"::timestamp) + interval '3 months'
left join (
select
  t.code, t."time", 经营活动产生的现金流量净额, 投资活动产生的现金流量净额, 筹资活动产生的现金流量净额, 现金及现金等价物净增加额
from securities_cash_flow_sheet_running_total t
) psrt4 on psrt1.code = psrt4.code and psrt1."time" = psrt4."time"
left join (
select
  t.code, t."time", 经营活动产生的现金流量净额, 投资活动产生的现金流量净额, 筹资活动产生的现金流量净额, 现金及现金等价物净增加额
from securities_cash_flow_sheet_running_total t
) psrt5 on psrt1.code = psrt5.code and ( psrt1."time" = psrt5."time" + interval '1 year' or psrt5."time" = psrt1."time" - interval '1 year' )
left join (
select
  t.code, t."time", 经营活动产生的现金流量净额, 投资活动产生的现金流量净额, 筹资活动产生的现金流量净额, 现金及现金等价物净增加额
from securities_cash_flow_sheet_running_total t
) psrt6 on psrt1.code = psrt6.code and date_trunc('quarter', psrt1."time"::timestamp) = date_trunc('quarter', psrt6."time"::timestamp) + interval '3 months'
where extract(year from psrt1."time") between start_year and end_year;
end;
$$ language plpgsql;

drop function if exists securities_kpis_3;
create or replace function securities_kpis_3()
returns table (code varchar(6),
               市值 numeric(20,2), 市盈率 numeric(10,4), 市净率 numeric(10,4),
               市盈率vs净利润增长率 numeric(10,4)) as $$
begin
return query
select
  dq.code, dq."time",
  dq.price * ss.总股本 * 10000.0 市值,
  case when psrt.净利润 <> 0 then dq.price * ss.总股本 * 10000.0 / psrt.净利润 else null end 市盈率,
  case when bs.股东权益合计 <> 0 then dq.price * ss.总股本 * 10000.0 / bs.股东权益合计 else null end 市净率,
  case when psrt.净利润 <> 0 and kpi.净利润增长率 <> 0 then dq.price * ss.总股本 * 10000.0 / psrt.净利润 / kpi.净利润增长率 else null end 市盈率vs净利润增长率
from (
  select code, "time", price from securities_day_quote where time = (select max(time) from securities_day_quote)) dq
join (
  select ss1.code, ss1.总股本 from securities_stock_structure ss1
  join (select code, max(time) "time" from securities_stock_structure group by code) ss2 on ss1.code = ss2.code and ss1."time" = ss2."time"
) ss on dq.code = ss.code
join (
  select psrt1.code, psrt1.净利润 from securities_profit_sheet_running_total psrt1
  join (select code, max(time) "time" from securities_profit_sheet_running_total group by code) psrt2 on psrt1.code = psrt2.code and psrt1."time" = psrt2."time"
) psrt on dq.code = psrt.code
join (
  select bsb1.code code, bsb1.股东权益合计 股东权益合计 from securities_balance_sheet_bank bsb1
  join (select code, max(time) "time" from securities_balance_sheet_bank group by code) bsb2 on bsb1.code = bsb2.code and bsb1."time" = bsb2."time"
  union
  select bsg1.code code, bsg1.所有者权益（或股东权益）合计 股东权益合计 from securities_balance_sheet_general bsg1
  join (select code, max(time) "time" from securities_balance_sheet_general group by code) bsg2 on bsg1.code = bsg2.code and bsg1."time" = bsg2."time"
  union
  select bss1.code code, bss1.所有者权益合计 股东权益合计 from securities_balance_sheet_securities bss1
  join (select code, max(time) "time" from securities_balance_sheet_securities group by code) bss2 on bss1.code = bss2.code and bss1."time" = bss2."time"
  union
  select bsi1.code code, bsi1.所有者权益合计 股东权益合计 from securities_balance_sheet_insurance bsi1
  join (select code, max(time) "time" from securities_balance_sheet_insurance group by code) bsi2 on bsi1.code = bsi2.code and bsi1."time" = bsi2."time"
) bs on dq.code = bs.code
join (
select k.code, avg(k.净利润同比) 净利润增长率 from (select code, 净利润同比, row_number() over (partition by code order by "time" desc) row_num from securities_kpi) k
  where k.row_num < 5
  group by k.code
) kpi on dq.code = kpi.code;
end;
$$ language plpgsql;

drop function if exists insert_securities_kpis_1;
create or replace function insert_securities_kpis_1(start_year integer, end_year integer) returns integer as $$
declare
  affected_row_count integer := 0;
  cur_kpi1 cursor for select * from securities_kpis_1(start_year, end_year);
  kpi1_rec record;
begin
perform drop_index_securities_kpi();
open cur_kpi1;
loop
  fetc  h cur_kpi1 into kpi1_rec;
  exit when not found;
  insert into securities_kpi (code, "time", 营业利润vs营业收入, 净利润vs营业收入, 净利润vs利润总额, 净利润vs股东权益合计)
  values (kpi1_rec.code, kpi1_rec."time", kpi1_rec.营业利润vs营业收入, kpi1_rec.净利润vs营业收入, kpi1_rec.净利润vs利润总额, kpi1_rec.净利润vs股东权益合计)
  on conflict (code, "time") do update set
    营业利润vs营业收入   = excluded.营业利润vs营业收入,
    净利润vs营业收入     = excluded.净利润vs营业收入,
    净利润vs利润总额     = excluded.净利润vs利润总额,
    净利润vs股东权益合计 = excluded.净利润vs股东权益合计;
  affected_row_count = affected_row_count + 1;
end loop;
close cur_kpi1;
perform create_index_securities_kpi();
return affected_row_count;
end;
$$ language plpgsql;

drop function if exists insert_securities_kpis_2;
create or replace function insert_securities_kpis_2(start_year integer, end_year integer) returns integer as $$
declare
  affected_row_count integer := 0;
  cur_kpi2 cursor for select * from securities_kpis_2(start_year, end_year);
  kpi2_rec record;
begin
perform drop_index_securities_kpi();
open cur_kpi2;
loop
  fetch cur_kpi2 into kpi2_rec;
  exit when not found;
  insert into securities_kpi (code, "time", 营业收入同比, 营业利润同比, 净利润同比, 营业收入环比, 营业利润环比, 净利润环比,
    经营活动产生的现金流量净额同比, 投资活动产生的现金流量净额同比, 筹资活动产生的现金流量净额同比, 现金及现金等价物净增加额同比,
    经营活动产生的现金流量净额环比, 投资活动产生的现金流量净额环比, 筹资活动产生的现金流量净额环比, 现金及现金等价物净增加额环比)
  values (kpi2_rec.code, kpi2_rec."time", kpi2_rec.营业收入同比, kpi2_rec.营业利润同比, kpi2_rec.净利润同比, kpi2_rec.营业收入环比, kpi2_rec.营业利润环比, kpi2_rec.净利润环比,
    kpi2_rec.经营活动产生的现金流量净额同比, kpi2_rec.投资活动产生的现金流量净额同比, kpi2_rec.筹资活动产生的现金流量净额同比, kpi2_rec.现金及现金等价物净增加额同比,
    kpi2_rec.经营活动产生的现金流量净额环比, kpi2_rec.投资活动产生的现金流量净额环比, kpi2_rec.筹资活动产生的现金流量净额环比, kpi2_rec.现金及现金等价物净增加额环比)
  on conflict (code, "time") do update set
    营业收入同比 = excluded.营业收入同比,
    营业利润同比 = excluded.营业利润同比,
    净利润同比   = excluded.净利润同比,
    营业收入环比 = excluded.营业收入环比,
    营业利润环比 = excluded.营业利润环比,
    净利润环比   = excluded.净利润环比,
    经营活动产生的现金流量净额同比 = excluded.经营活动产生的现金流量净额同比,
    投资活动产生的现金流量净额同比 = excluded.投资活动产生的现金流量净额同比,
    筹资活动产生的现金流量净额同比 = excluded.筹资活动产生的现金流量净额同比,
    现金及现金等价物净增加额同比   = excluded.现金及现金等价物净增加额同比,
    经营活动产生的现金流量净额环比 = excluded.经营活动产生的现金流量净额环比,
    投资活动产生的现金流量净额环比 = excluded.投资活动产生的现金流量净额环比,
    筹资活动产生的现金流量净额环比 = excluded.筹资活动产生的现金流量净额环比,
    现金及现金等价物净增加额环比   = excluded.现金及现金等价物净增加额环比;
  affected_row_count = affected_row_count + 1;
end loop;
close cur_kpi2;
perform create_index_securities_kpi();
return affected_row_count;
end;
$$ language plpgsql;

-- transaction_soldout_subtotal:
-- 已结实盈(清仓个股)，曾经持有，目前清仓的证券
-- 要分期初已持有和期初未持有
drop function if exists transaction_soldout_subtotal;
create or replace function transaction_soldout_subtotal(start_time date, end_time date)
returns table (tss_code varchar(6), tss_amount numeric(20,4)) as $$
  declare count1 int;
  declare count2 int;
  begin
    select count(*) into count1 from securities_holding where time = start_time;
    select count(*) into count2 from securities_holding where time = end_time;
    -- securities_holding应该明确指示证券在start_time和end_time的证券持有状态
    -- 如果在这两个时刻都没有持有任何证券，则code=None，price=cost=vol=0。
    if count1 = 0 or count2 = 0 then
      raise exception 'securities_holding contains not data for the given time range.';
    end if;

    return query
    select  -- 1st select clause: 期初持有，期末清仓
      sd.code,
      st.amount - price * vol amount -- 期间交易金额 - 期初市值
    from securities_holding sd
    join (
      select
        code,
        sum(amount) amount
      from securities_transaction
      where time > start_time and time <= end_time
        and (tname = '证券买入' or tname = '证券卖出' or tname = '红股入账')
        and
          code in (
            select
              code
            from securities_holding
            where time = start_time
              and code not in (
                          select
                            code
                          from securities_holding
                          where time = end_time)
          )
      group by code
    ) st
    on sd.code = st.code
    where
      sd.time = start_time
    union
    select  -- 2nd select clause: 期初、期末均未持有，但期间曾持有
      code,
      sum(amount) amount
    from securities_transaction
    where time > start_time and time <= end_time
      and
        code not in (
          select
            code
          from securities_holding
          where (time = start_time or time = end_time) and code <> 'None')
      and
        (tname = '证券买入' or tname = '证券卖出' or tname = '红股入账')
    group by code;

  end;
$$ LANGUAGE plpgsql;

-- transaction_soldout_total:
-- 已结实盈(清仓汇总)，曾经持有，目前清仓的证券
drop function if exists transaction_soldout_total;
create or replace function transaction_soldout_total(start_time date, end_time date)
returns table (tst_amount numeric(20,4)) as $$
  begin
    return query
    select sum(tss_amount) from transaction_soldout_subtotal(start_time, end_time);
  end;
$$ LANGUAGE plpgsql;

-- transaction_dividend_subtotal
-- 已结实盈(分红个股)，分红
drop function if exists transaction_dividend_subtotal;
create or replace function transaction_dividend_subtotal (in start_time date, in end_time date)
returns table (tds_code varchar(6), tds_amount numeric(20,4)) as $$
  begin
    return query
    select
      code,
      sum(amount) amount
    from securities_transaction
    where
      (time > start_time and time <= end_time)
    and
      (tname = '股息入账' or tname = '股息红利税补缴')
    group by code;
  end;
$$ LANGUAGE plpgsql;

-- transaction_dividend_total
-- 已结实盈(分红汇总)，分红
drop function if exists transaction_dividend_total;
create or replace function transaction_dividend_total (in start_time date, in end_time date)
returns table (tdt_amount numeric(20,4)) as $$
  begin
    return query
    select sum(tds_amount) from transaction_dividend_subtotal(start_time, end_time);
  end;
$$ LANGUAGE plpgsql;

-- transaction_holding_sutotal
-- 浮盈（个股）
drop function if exists transaction_holding_subtotal;
create or replace function transaction_holding_subtotal (in start_time date, in end_time date)
returns table (ths_code varchar(6), ths_amount numeric(20,4)) as $$
  declare count1 int;
  declare count2 int;
  begin
    select count(*) into count1 from securities_holding where time = start_time;
    select count(*) into count2 from securities_holding where time = end_time;
    -- securities_holding应该明确指示证券在start_time和end_time的证券持有状态
    -- 如果在这两个时刻都没有持有任何证券，则code=None，price=cost=vol=0。
    if count1 = 0 or count2 = 0 then
      raise exception 'securities_holding contains not data for the given time range.';
    end if;

    return query
    select
      tr.code,
      sum(tr.amount) amount
    from (
      select  -- 1st select clause: 期初市值
        code,
        - price * vol amount
      from securities_holding
      where time = start_time and code <> 'None'
        and code in (select code from securities_holding where time = end_time)
      union
      select  -- 2nd select clause: 期末市值
        code,
        price * vol amount
      from securities_holding
      where time = end_time and code <> 'None'
      union
      select  -- 3rd select clause: 期间交易金额
        code,
        sum(amount) amount
      from securities_transaction
      where time > start_time and time <= end_time
        and code in (select code from securities_holding where time = end_time)
        and (tname = '证券买入' or tname = '证券卖出' or tname = '红股入账')
      group by code
    ) tr
    group by tr.code;
  end;
$$ LANGUAGE plpgsql;

-- transaction_holding_total
-- 浮盈（汇总）
drop function if exists transaction_holding_total;
create or replace function transaction_holding_total (in start_time date, in end_time date)
returns table (tht_amount numeric(20,4)) as $$
  begin
    return query
    select sum(ths_amount) from transaction_holding_subtotal(start_time, end_time);
  end;
$$ LANGUAGE plpgsql;

-- investment_earning
-- 投资收益（给定时间区间）
drop function if exists investment_earning;
create or replace function investment_earning (in start_time date, in end_time date)
returns table (期初市值 numeric(20,4), 期初现金 numeric(20,4), 期间现金净流入 numeric(20,4), 期末市值 numeric(20,4), 期末现金 numeric(20,4), 期间收益 numeric(20,4)) as $$
  declare count_S0 int;
  declare count_C0 int;
  declare count_S1 int;
  declare count_C1 int;

  declare S0 numeric(20, 4);
  declare C0 numeric(20, 4);
  declare S1 numeric(20, 4);
  declare C1 numeric(20, 4);
  declare Cn numeric(20, 4);

  begin
    select count(*) into count_S0 from securities_holding where time = start_time;
    select count(*) into count_C0 from cash_holding where time = start_time;
    select count(*) into count_S1 from securities_holding where time = end_time;
    select count(*) into count_C1 from cash_holding where time = end_time;
    if count_S0 = 0 or count_S1 = 0 then
      raise exception 'securities_holding contains not data for the given time range.';
    end if;
    if count_C0 = 0 or count_C1 = 0 then
      raise exception 'cash_holding contains not data for the given time range.';
    end if;

    select sum(price * vol) into S0 from securities_holding where time = start_time;
    select sum(price * vol) into S1 from securities_holding where time = end_time;
    select amount into C0 from cash_holding where time = start_time;
    select amount into C1 from cash_holding where time = end_time;
    select sum(amount) into Cn from securities_transaction where (tname='银行转存' or tname='银行转取') and time > start_time and time <= end_time;

    return query
    select S0, C0, Cn, S1, C1, S1 + C1 - Cn - S0 - C0;
  end;
$$ LANGUAGE plpgsql;

-- short_list
-- 条件选股
-- 从给定“分红起始年份”（含）起有不少于给定“分红年数“的证券
-- 市盈率在给定区间的证券（在securities_day_quote的最新日期上）
-- 市净率在给定区间的证券（在securities_day_quote的最新日期上）
-- 净资产收益率在给定区间的证券（在securities_kpi的最新日期上）
-- 根据上年度分红对股价的率比（在securities_day_quote的最新日期上）降序排列取给定row_limit条记录
drop function if exists short_list;
create or replace function short_list (
  in div_inception_year int, -- 分红起始年份
  in div_years int, -- 分红年数
  in per_l numeric(10,2), -- 市盈率下限，基于securities_day_quote中最新日期
  in per_u numeric(10,2), -- 市盈率上限，基于securities_day_quote中最新日期
  in pbr_l numeric(10,2), -- 市净率下限，基于securities_day_quote中最新日期
  in pbr_u numeric(10,2), -- 市净率上限，基于securities_day_quote中最新日期
  in roe_l numeric(10,2), -- 净资产收益率下限，基于securities_kpi中最新日期
  in roe_u numeric(10,2), -- 净资产收益率上限，基于securities_kpi中最新日期
  in row_limit int -- 返回满足条件的证券数量上限
) returns table (
  sl_代码 varchar(6),
  sl_名称 varchar(10),
  "sl_分红比价格 %" numeric(10,2),
  sl_市盈率 numeric(10,2),
  "sl_净资产收益率 %" numeric(10,2),
  sl_市净率 numeric(10,2),
  "sl_分红比盈利 %" numeric(10,2),
  sl_每股盈利（元） numeric(10,2),
  sl_每股分红（元） numeric(10,2)) as $$

  declare quote_date date;
  declare kpi_date date;

  begin
    select time into quote_date from securities_day_quote order by time desc limit 1;
    select time into kpi_date from securities_kpi where extract(month from time) = 12 and extract(day from time) = 31 and extract(year from time) <= (div_inception_year + div_years - 1) order by time desc limit 1;
    return query
    select
      d.code 代码,
      c.name 名称,
      round(d.现金分红/q.price/10.0*100,2) 分红比价格,
      round(q.per, 2) 市盈率,
      round(k.净利润_股东权益合计*100, 2) 净资产收益率,
      round(q.pbr, 2) 市净率,
      round(d.现金分红/10.0/k.每股收益*100, 2) 分红比盈利,
      round(k.每股收益, 2) 每股盈利,
      round(d.现金分红/10.0, 2) 每股分红
    from securities_dividend d
    join securities_day_quote q on q.code = d.code
    join securities_kpi k on k.code = d.code
    join securities_code c on c.code = d.code
    where
      q.time = quote_date and k.time = kpi_date
      and q.price <> 0
      and k.每股收益 <> 0
      and q.per >= per_l and q.per <= per_u
      and q.pbr >= pbr_l and q.pbr <= pbr_u
      and k.净利润_股东权益合计 >= roe_l and k.净利润_股东权益合计 <= roe_u
      and extract(year from d.time) = (div_inception_year + div_years - 1)
      and d.code in (
        select code from (
          select
            code,
            count(time)
          from securities_dividend
          where extract(year from time) >= div_inception_year
          group by code
          having count(time) >= div_years) div_code)
    order by 市盈率, 净资产收益率 desc, 分红比价格 desc, 市净率, 分红比盈利
    limit row_limit;
  end;
$$ LANGUAGE plpgsql;

-- short_list_code
-- 条件选股，仅返回代码和名称
-- 从给定“分红起始年份”（含）起有不少于给定“分红年数“的证券
-- 市盈率在给定区间的证券（在securities_day_quote的最新日期上）
-- 市净率在给定区间的证券（在securities_day_quote的最新日期上）
-- 净资产收益率在给定区间的证券（在securities_kpi的最新日期上）
-- 根据上年度分红对股价的率比（在securities_day_quote的最新日期上）降序排列取给定row_limit条记录
drop function if exists short_list_code;
create or replace function short_list_code (
  in div_inception_year int, -- 分红起始年份
  in div_years int, -- 分红年数
  in per_l numeric(10,2), -- 市盈率下限，基于securities_day_quote中最新日期
  in per_u numeric(10,2), -- 市盈率上限，基于securities_day_quote中最新日期
  in pbr_l numeric(10,2), -- 市净率下限，基于securities_day_quote中最新日期
  in pbr_u numeric(10,2), -- 市净率上限，基于securities_day_quote中最新日期
  in roe_l numeric(10,2), -- 净资产收益率下限，基于securities_kpi中最新日期
  in roe_u numeric(10,2), -- 净资产收益率上限，基于securities_kpi中最新日期
  in row_limit int -- 返回满足条件的证券数量上限
) returns table (
  slc_代码 varchar(6),
  slc_名称 varchar(10)) as $$
  begin
    return query
    select sl_代码, sl_名称 from short_list(div_inception_year, div_years, per_l, per_u, pbr_l, pbr_u, roe_l, roe_u, row_limit);
  end;
$$ LANGUAGE plpgsql;

-- short_list_code_default
-- 条件选股，仅返回代码和名称
-- 市盈率下限缺省设为0.01
-- 市净率下限缺省设为0.01
-- 净资产收益率下限缺省设为0.1
-- 从给定“分红起始年份”（含）起有不少于给定“分红年数“的证券
-- 市盈率在给定区间的证券（在securities_day_quote的最新日期上）
-- 市净率在给定区间的证券（在securities_day_quote的最新日期上）
-- 净资产收益率在给定区间的证券（在securities_kpi的最新日期上）
-- 根据上年度分红对股价的率比（在securities_day_quote的最新日期上）降序排列取给定row_limit条记录
drop function if exists short_list_code_default;
create or replace function short_list_code_default (
  in div_inception_year int, -- 分红起始年份
  in div_years int, -- 分红年数
  in per_u numeric(10,2), -- 市盈率上限，基于securities_day_quote中最新日期
  in pbr_u numeric(10,2), -- 市净率上限，基于securities_day_quote中最新日期
  in roe_u numeric(10,2), -- 净资产收益率上限，基于securities_kpi中最新日期
  in row_limit int -- 返回满足条件的证券数量上限
) returns table (
  slcd_代码 varchar(6),
  slcd_名称 varchar(10)) as $$

  declare per_l numeric(10,2);
  declare pbr_l numeric(10,2);
  declare roe_l numeric(10,2);

  begin
    per_l := 0.01;
    pbr_l := 0.01;
    roe_l := 0.1;

    return query
    select slc_代码, slc_名称 from short_list_code(div_inception_year, div_years, per_l, per_u, pbr_l, pbr_u, roe_l, roe_u, row_limit);
  end;
$$ LANGUAGE plpgsql;

-- short_list__default
-- 条件选股
-- 市盈率下限缺省设为0.01
-- 市净率下限缺省设为0.01
-- 净资产收益率下限缺省设为0.1
-- 从给定“分红起始年份”（含）起有不少于给定“分红年数“的证券
-- 市盈率在给定区间的证券（在securities_day_quote的最新日期上）
-- 市净率在给定区间的证券（在securities_day_quote的最新日期上）
-- 净资产收益率在给定区间的证券（在securities_kpi的最新日期上）
-- 根据上年度分红对股价的率比（在securities_day_quote的最新日期上）降序排列取给定row_limit条记录
drop function if exists short_list_default;
create or replace function short_list_default (
  in div_inception_year int, -- 分红起始年份
  in div_years int, -- 分红年数
  in per_u numeric(10,2), -- 市盈率上限，基于securities_day_quote中最新日期
  in pbr_u numeric(10,2), -- 市净率上限，基于securities_day_quote中最新日期
  in roe_u numeric(10,2), -- 净资产收益率上限，基于securities_kpi中最新日期
  in row_limit int -- 返回满足条件的证券数量上限
) returns table (
  sld_代码 varchar(6),
  sld_名称 varchar(10),
  "sld_分红比价格 %" numeric(10,2),
  sld_市盈率 numeric(10,2),
  "sld_净资产收益率 %" numeric(10,2),
  sld_市净率 numeric(10,2),
  "sld_分红比盈利 %" numeric(10,2),
  sld_每股盈利（元） numeric(10,2),
  sld_每股分红（元） numeric(10,2)) as $$

  declare per_l numeric(10,2);
  declare pbr_l numeric(10,2);
  declare roe_l numeric(10,2);

  begin
    per_l := 0.01;
    pbr_l := 0.01;
    roe_l := 0.1;
    return query
    select * from short_list(div_inception_year, div_years, per_l, per_u, pbr_l, pbr_u, roe_l, roe_u, row_limit);
  end;
$$ LANGUAGE plpgsql;

-- data_status
-- 汇总目前数据库中所收集数据的状态
-- 主要包括数据的时间
drop function if exists data_status;
create or replace function data_status ()
returns table (
  ds_证券数量 int,
  ds_行情日期 date,
  ds_分红年度 date,
  ds_证券持有日期 date,
  ds_现金持有日期 date,
  ds_交易日期 date,
  ds_资产负债_银行 date,
  ds_资产负债_一般 date,
  ds_资产负债_证券 date,
  ds_资产负债_保险 date,
  ds_现金流量_银行 date,
  ds_现金流量_一般 date,
  ds_现金流量_证券 date,
  ds_现金流量_保险 date,
  ds_利润_银行 date,
  ds_利润_一般 date,
  ds_利润_证券 date,
  ds_利润_保险 date,
  ds_股本结构 date,
  ds_关键指标 date) as $$

  declare code_num int;
  declare quote_date date;
  declare div_year date;
  declare sec_hold_date date;
  declare cash_hold_date date;
  declare trans_date date;
  declare balance_bank_date date;
  declare balance_general_date date;
  declare balance_securities_date date;
  declare balance_insurance_date date;
  declare cash_flow_bank_date date;
  declare cash_flow_general_date date;
  declare cash_flow_securities_date date;
  declare cash_flow_insurance_date date;
  declare profit_bank_date date;
  declare profit_general_date date;
  declare profit_securities_date date;
  declare profit_insurance_date date;
  declare stock_structure_date date;
  declare securities_kpi_date date;

  begin
    select count(*) into code_num from securities_code;
    select max(time) into quote_date from securities_day_quote;
    select max(time) into div_year from securities_dividend;
    select max(time) into sec_hold_date from securities_holding;
    select max(time) into cash_hold_date from cash_holding;
    select max(time) into trans_date from securities_transaction;
    select max(time) into balance_bank_date from securities_balance_sheet_bank;
    select max(time) into balance_general_date from securities_balance_sheet_general;
    select max(time) into balance_securities_date from securities_balance_sheet_securities;
    select max(time) into balance_insurance_date from securities_balance_sheet_insurance;
    select max(time) into cash_flow_bank_date from securities_cash_flow_sheet_bank;
    select max(time) into cash_flow_general_date from securities_cash_flow_sheet_general;
    select max(time) into cash_flow_securities_date from securities_cash_flow_sheet_securities;
    select max(time) into cash_flow_insurance_date from securities_cash_flow_sheet_insurance;
    select max(time) into profit_bank_date from securities_profit_sheet_bank;
    select max(time) into profit_general_date from securities_profit_sheet_general;
    select max(time) into profit_securities_date from securities_profit_sheet_securities;
    select max(time) into profit_insurance_date from securities_profit_sheet_insurance;
    select max(time) into stock_structure_date from securities_stock_structure;
    select max(time) into securities_kpi_date from securities_kpi;

    return query
    select
      code_num,
      quote_date,
      div_year,
      sec_hold_date,
      cash_hold_date,
      trans_date,
      balance_bank_date,
      balance_general_date,
      balance_securities_date,
      balance_insurance_date,
      cash_flow_bank_date,
      cash_flow_general_date,
      cash_flow_securities_date,
      cash_flow_insurance_date,
      profit_bank_date,
      profit_general_date,
      profit_securities_date,
      profit_insurance_date,
      stock_structure_date,
      securities_kpi_date;
  end;
$$ LANGUAGE plpgsql;
