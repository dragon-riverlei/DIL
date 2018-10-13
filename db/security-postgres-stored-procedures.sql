-- ====================================
-- Stored procedure definitions
-- ====================================

-- year_consecutiveness_with_consecutive_quarters:判断给定表中（必须包含code和time字段）某证券季度连续程度
-- year_consecutiveness_with_consecutive_quarters_balance_sheet:判断balance_sheet表在给季度上连续时年份的连续程度
-- year_consecutiveness_with_consecutive_quarters_cash_flow_sheet:判断cash_flow_sheet表在给季度上连续时年份的连续程度
-- year_consecutiveness_with_consecutive_quarters_profit_sheet:判断profit_sheet表在给季度上连续时年份的连续程度
-- year_consecutiveness:判断给定表中（必须包含code和time字段）某证券在给定月份和日期上的年份连续程度
-- year_consecutiveness_balance_sheet:判断balance_sheet表在给定月份和日期上的年份连续程度
-- year_consecutiveness_cash_flow_sheet:判断cash_flow_sheet表在给定月份和日期上的年份连续程度
-- year_consecutiveness_profit_sheet:判断profit_sheet表在给定月份和日期上的年份连续程度
-- transaction_soldout_subtotal:已结实盈(清仓个股)，曾经持有，目前清仓的证券
-- transaction_soldout_total:已结实盈(清仓汇总)，曾经持有，目前清仓的证券
-- transaction_dividend_subtotal:已结实盈(分红个股)，分红
-- transaction_dividend_total:已结实盈(分红汇总)，分红
-- transaction_holding_subtotal:浮盈（个股）
-- transaction_holding_total:浮盈（汇总）
-- insert_securities_kpi:新增给定日期之后的KPI记录
-- investment_earning:投资收益（给定时间区间）
-- short_list:条件选股，返回详细信息
-- short_list_default:条件选股（使用缺省条件），返回详细信息
-- short_list_code:条件选股，只返回代码和名称
-- short_list_code_default:条件选股（使用缺省条件），只返回代码和名称
-- data_status:汇总目前数据库中所收集数据的状态

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

-- year_consecutiveness_with_consecutive_quarters:
-- 判断给定表（必须包含code和time字段）中季度上连续时年份的连续程度。
--
-- count = 1 代表年份全部连续
-- count = 2 代表年份分为两部分，部分与部分之间不连续，部分内连续
-- ...
-- count = n 代表年份分为n部分，部分与部分之间不连续，部分内连续
drop function if exists year_consecutiveness_with_consecutive_quarters;
create or replace function year_consecutiveness_with_consecutive_quarters(tbl regclass)
returns table (code varchar(6), count bigint) as $$
  begin
  return query execute format('
    with
      code_year as (
        select
          code,
          year
        from (
          select
            distinct code,
            year,
            count(year) quarter_count
          from (
            select
              code,
              to_char(time, ''yyyy'') as year
            from
              %s
          ) t1
          group by
            code,
            year
          order by
            code,
            year
        ) t2
        where
          quarter_count = 4
      ),
      year_row_delta_group_by_code as (
        select
          distinct code,
          delta
        from (
          select
            code,
            cast(year as integer) - row_number() over (
              partition by
                code
              order by
                year
            ) as delta
          from
            code_year
        ) t3
      )

    select
      code,
      count(*)
    from
      year_row_delta_group_by_code
    group by
      code;
  ', tbl);
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness_with_consecutive_quarters_balance_sheet:
-- 判断balance_sheet表在给季度上连续时年份的连续程度
drop function if exists year_consecutiveness_with_consecutive_quarters_balance_sheet;
create or replace function year_consecutiveness_with_consecutive_quarters_balance_sheet()
returns table (code varchar(6), count bigint) as $$
  begin
    return query
    select * from year_consecutiveness_with_consecutive_quarters('securities_balance_sheet_bank')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_balance_sheet_general')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_balance_sheet_securities')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_balance_sheet_insurance');
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness_with_consecutive_quarters_cash_flow_sheet:
-- 判断cash_flow_sheet表在给季度上连续时年份的连续程度
drop function if exists year_consecutiveness_with_consecutive_quarters_cash_flow_sheet;
create or replace function year_consecutiveness_with_consecutive_quarters_cash_flow_sheet()
returns table (code varchar(6), count bigint) as $$
  begin
    return query
    select * from year_consecutiveness_with_consecutive_quarters('securities_cash_flow_sheet_bank')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_cash_flow_sheet_general')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_cash_flow_sheet_securities')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_cash_flow_sheet_insurance');
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness_with_consecutive_quarters_profit_sheet:
-- 判断profit_sheet表在给季度上连续时年份的连续程度
drop function if exists year_consecutiveness_with_consecutive_quarters_profit_sheet;
create or replace function year_consecutiveness_with_consecutive_quarters_profit_sheet()
returns table (code varchar(6), count bigint) as $$
  begin
    return query
    select * from year_consecutiveness_with_consecutive_quarters('securities_profit_sheet_bank')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_profit_sheet_general')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_profit_sheet_securities')
    union
    select * from year_consecutiveness_with_consecutive_quarters('securities_profit_sheet_insurance');
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness:
-- 返回给定表中（必须包含code和time字段）某证券在给定月份和日期上的年份连续程度。
-- count = 1 代表年份在该月份和日期上全部连续
-- count = 2 代表年份分为两部分，部分内连续，但部分与部分之间不连续
-- ...
-- count = n 代表年份分为n部分，部分内连续，但部分与部分之间不连续
drop function if exists year_consecutiveness;
create or replace function year_consecutiveness(tbl regclass, month integer, day integer)
returns table (code varchar(6), count bigint) as $$
  begin
  return query execute format('
    with
      code_year as (
        select
          distinct code,
          year
        from (
          select
            code,
            to_char(time, ''yyyy'') as year
          from
            %s
          where
            extract(''month'' from time) = %s
            and extract(''day'' from time) = %s
        ) t1
      ),
      year_row_delta_group_by_code as (
        select
          distinct code,
          delta
        from (
          select
            code,
            cast(year as integer) - row_number() over (
              partition by
                code
              order by
                year
            ) as delta
          from
            code_year
        ) t2
      )

    select
      code,
      count(*)
    from
      year_row_delta_group_by_code
    group by
      code;
  ', tbl, month, day);
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness_balance_sheet:
-- 判断balance_sheet表在给定月份和日期上的年份连续程度。
drop function if exists year_consecutiveness_balance_sheet;
create or replace function year_consecutiveness_balance_sheet(month integer, day integer)
returns table (code varchar(6), count bigint) as $$
  begin
    return query
    select * from year_consecutiveness('securities_balance_sheet_bank', month, day)
    union
    select * from year_consecutiveness('securities_balance_sheet_general', month, day)
    union
    select * from year_consecutiveness('securities_balance_sheet_securities', month, day)
    union
    select * from year_consecutiveness('securities_balance_sheet_insurance', month, day);
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness_cash_flow_sheet:
-- 判断cash_flow_sheet表在给定月份和日期上的年份连续程度。
drop function if exists year_consecutiveness_cash_flow_sheet;
create or replace function year_consecutiveness_cash_flow_sheet(month integer, day integer)
returns table (code varchar(6), count bigint) as $$
  begin
    return query
    select * from year_consecutiveness('securities_cash_flow_sheet_bank', month, day)
    union
    select * from year_consecutiveness('securities_cash_flow_sheet_general', month, day)
    union
    select * from year_consecutiveness('securities_cash_flow_sheet_securities', month, day)
    union
    select * from year_consecutiveness('securities_cash_flow_sheet_insurance', month, day);
  end;
$$ LANGUAGE plpgsql;

-- year_consecutiveness_profit_sheet:
-- 判断profit_sheet表在给定月份和日期上的年份连续程度。
drop function if exists year_consecutiveness_profit_sheet;
create or replace function year_consecutiveness_profit_sheet(month integer, day integer)
returns table (code varchar(6), count bigint) as $$
  begin
    return query
    select * from year_consecutiveness('securities_profit_sheet_bank', month, day)
    union
    select * from year_consecutiveness('securities_profit_sheet_general', month, day)
    union
    select * from year_consecutiveness('securities_profit_sheet_securities', month, day)
    union
    select * from year_consecutiveness('securities_profit_sheet_insurance', month, day);
  end;
$$ LANGUAGE plpgsql;

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

-- insert_securities_kpi:新增给定日期之后的KPI记录
drop function if exists insert_securities_kpi;
create or replace function insert_securities_kpi (in start_time date) returns void as $$
  begin
    insert into securities_kpi
    -- return query
    -- 银行 kpis
    select
      bb.code as code,
      bb.time as time,
      pb.三、营业利润/pb.一、营业收入 as 营业利润_营业总收入,
      pb.五、净利润/pb.一、营业收入 as 净利润_营业总收入,
      pb.五、净利润/pb.四、利润总额 as 净利润_利润总额,
      pb.五、净利润/bb.股东权益合计 as 净利润_股东权益合计,
      pb.五、净利润/ss.总股本/10000 as 每股收益
    from securities_balance_sheet_bank bb
    join securities_profit_sheet_bank pb on bb.time = pb.time and bb.code = pb.code
    join securities_stock_structure ss on bb.time = ss.time and bb.code = ss.code
    where
      pb.一、营业收入 <> 0
      and pb.四、利润总额 <> 0
      and bb.股东权益合计 <> 0
      and bb.time > start_time
    union
    -- 一般行业 kpis
    select
      bg.code as code,
      bg.time as time,
      pg.三、营业利润/pg.一、营业总收入 as 营业利润_营业总收入,
      pg.五、净利润/pg.一、营业总收入 as 净利润_营业总收入,
      pg.五、净利润/pg.四、利润总额 as 净利润_利润总额,
      pg.五、净利润/bg.所有者权益（或股东权益）合计 as 净利润_股东权益合计,
      pg.五、净利润/ss.总股本/10000 as 每股收益
    from securities_balance_sheet_general bg
    join securities_profit_sheet_general pg on bg.time = pg.time and bg.code = pg.code
    join securities_stock_structure ss on bg.time = ss.time and bg.code = ss.code
    where
      pg.一、营业总收入 <> 0
      and pg.四、利润总额 <> 0
      and bg.所有者权益（或股东权益）合计 <> 0
      and bg.time > start_time
    union
    -- 证券 kpis
    select
      bs.code as code,
      bs.time as time,
      ps.三、营业利润/ps.一、营业收入 as 营业利润_营业总收入,
      ps.五、净利润/ps.一、营业收入 as 净利润_营业总收入,
      ps.五、净利润/ps.四、利润总额 as 净利润_利润总额,
      ps.五、净利润/bs.所有者权益合计 as 净利润_股东权益合计,
      ps.五、净利润/ss.总股本/10000 as 每股收益
    from securities_balance_sheet_securities bs
    join securities_profit_sheet_securities ps on bs.time = ps.time and bs.code = ps.code
    join securities_stock_structure ss on bs.time = ss.time and bs.code = ss.code
    where
      ps.一、营业收入 <> 0
      and ps.四、利润总额 <> 0
      and bs.所有者权益合计 <> 0
      and bs.time > start_time
    union
    -- 保险 kpis
    select
      bi.code as code,
      bi.time as time,
      pi.三、营业利润/pi.一、营业收入 as 营业利润_营业总收入,
      pi.五、净利润/pi.一、营业收入 as 净利润_营业总收入,
      pi.五、净利润/pi.四、利润总额 as 净利润_利润总额,
      pi.五、净利润/bi.所有者权益合计 as 净利润_股东权益合计,
      pi.五、净利润/ss.总股本/10000 as 每股收益
    from securities_balance_sheet_insurance bi
    join securities_profit_sheet_insurance pi on bi.time = pi.time and bi.code = pi.code
    join securities_stock_structure ss on bs.time = ss.time and bi.code = ss.code
    where
      pi.一、营业收入 <> 0
      and pi.四、利润总额 <> 0
      and bi.所有者权益合计 > 0
      and bi.time > start_time;
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
-- 净资产收益率在给定区间的证券（在securities_major_financial_kpi的最新日期上）
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
  sl_分红比价格 numeric(10,2),
  sl_市盈率 numeric(10,2),
  sl_净资产收益率 numeric(10,2),
  sl_市净率 numeric(10,2),
  sl_分红比盈利 numeric(10,2),
  sl_每股盈利 numeric(10,2),
  sl_每股分红 numeric(10,2)) as $$

  declare quote_date date;
  declare kpi_date date;

  begin
    select time into quote_date from securities_day_quote order by time desc limit 1;
    select time into kpi_date from securities_kpi where extract(month from time) = 12 and extract(day from time) = 31 and extract(year from time) <= (div_inception_year + div_years - 1) order by time desc limit 1;
    return query
    select
      d.code 代码,
      c.name 名称,
      d.现金分红/q.price/10.0 分红比价格,
      q.per 市盈率,
      k.净利润_股东权益合计 净资产收益率,
      q.pbr 市净率,
      d.现金分红/10.0/d.eps 分红比盈利,
      d.eps 每股盈利,
      d.现金分红/10.0 每股分红
    from securities_dividend d
    join securities_day_quote q on q.code = d.code
    join securities_kpi k on k.code = d.code
    join securities_code c on c.code = d.code
    where
      q.time = quote_date and k.time = kpi_date
      and q.price <> 0
      and d.eps <> 0
      and q.per >= per_l and q.per <= per_u
      and q.pbr >= pbr_l and q.pbr <= pbr_u
      and k.净利润_股东权益合计 >= roe_l and k.净利润_股东权益合计 <= roe_u
      and d.year = (div_inception_year + div_years - 1)
      and d.code in (
        select code from (
          select
            code,
            count(year)
          from securities_dividend
          where year >= div_inception_year
          group by code
          having count(year) >= div_years) div_code)
    order by 分红比价格 desc, 市盈率, 净资产收益率 desc,  市净率, 分红比盈利
    limit row_limit;
  end;
$$ LANGUAGE plpgsql;
