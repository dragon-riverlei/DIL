drop function if exists strategy_intervaled_active_time_series;
create or replace function strategy_intervaled_active_time_series(_interval interval, _start_time date, _codes varchar(6)[] default null)
returns table (code varchar(6), "time" date, price numeric(10,4)) as $$
begin
if array_length(_codes, 1) <> 0 then
  return query
  select tt.*, sdp.close_price from (
    select t.code, generate_series(min, max, _interval)::date "time" from (
      select sdp1.code, min(sdp1.time), max(sdp1.time) from securities_day_price sdp1 where sdp1.time > _start_time and _codes @> array[sdp1.code] group by sdp1.code
    ) t
    intersect
    select sdp2.code, sdp2.time from securities_day_price sdp2
  ) tt join securities_day_price sdp on tt.code = sdp.code and tt.time = sdp.time;
else
  return query
  select tt.*, sdp.close_price from (
    select t.code, generate_series(min, max, _interval)::date "time" from (
      select sdp1.code, min(sdp1.time), max(sdp1.time) from securities_day_price sdp1 where sdp1.time > _start_time group by sdp1.code
    ) t
    intersect
    select sdp2.code, sdp2.time from securities_day_price sdp2
  ) tt join securities_day_price sdp on tt.code = sdp.code and tt.time = sdp.time;
end if;
end;
$$ LANGUAGE plpgsql;

drop function if exists strategy_intervaled_active_time_cash_volume_series;
create or replace function strategy_intervaled_active_time_cash_volume_series(
  _interval interval, _start_time date, _cash numeric(10,2), _volume numeric(12,2), _codes varchar(6)[] default null)
returns table (code varchar(6), "time" date, price numeric(10,4),
               transaction_type varchar(30), cash numeric(10,2), volume numeric(12,2)) as $$
begin
if array_length(_codes, 1) <> 0 then
  return query
  select * from (
    select tc.code, tc."time", null::numeric(10,4), '存入现金'::varchar(30), _cash, 0.00 from strategy_intervaled_active_time_series(_interval, _start_time, _codes) tc
    union all
    select ts.code, ts."time", ts.price, '买入股份'::varchar(30), 0.00, _volume from strategy_intervaled_active_time_series(_interval, _start_time, _codes) ts
  ) ats;
else
  return query
  select * from (
    select tc.code, tc."time", null::numeric(10,4), '存入现金'::varchar(30), _cash, 0.00 from strategy_intervaled_active_time_series(_interval, _start_time) tc
     union all
    select ts.code, ts."time", ts.price, '买入股份'::varchar(30), 0.00, _volume from strategy_intervaled_active_time_series(_interval, _start_time) ts
  ) ats;
end if;
end;
$$ LANGUAGE plpgsql;

drop function if exists strategy_passive_time_cash_volume_series;
create or replace function strategy_passive_time_cash_volume_series(_start_time date, _codes varchar(6)[] default null)
returns table (code varchar(6), "time" date, price numeric(10,4),
               transaction_type varchar(30), cash numeric(10,2), volume numeric(12,2)) as $$
begin
if array_length(_codes, 1) <> 0 then
  return query
  select * from (
    select
      dvdc.code,
      除权除息日,
      0.0000 price,
      '股票分红'::varchar(30) transaction_type,
      case when 现金分红 is null then 0.00 else 现金分红 end cash,
      0.00 volume
    from securities_dividend dvdc
    where
      dvdc.code not in (select dvd.code from securities_dividend dvd group by dvd.code, dvd.除权除息日 having count(*) > 1 order by dvd.code)
      and _codes @> array[dvdc.code]
      and 方案进度 = '实施分配'
      and dvdc.time > _start_time
    union all
    select
      dvdv.code,
      除权除息日,
      0.0000 price,
      '股票送转'::varchar(30) transaction_type,
      0.00 cash,
      case when 送转总比例 is null then 0.00 else 送转总比例 end volume
    from securities_dividend dvdv
    where
      dvdv.code not in (select dvd.code from securities_dividend dvd group by dvd.code, dvd.除权除息日 having count(*) > 1 order by dvd.code)
      and _codes @> array[dvdv.code]
      and 方案进度 = '实施分配'
      and dvdv.time > _start_time
  ) pts;
else
  return query
  select * from (
    select
      dvdc.code,
      除权除息日,
      0.0000 price,
      '股票分红'::varchar(30) transaction_type,
      case when 现金分红 is null then 0.00 else 现金分红 end cash,
      0.00 volume
    from securities_dividend dvdc
    where
      dvdc.code not in (select dvd.code from securities_dividend dvd group by dvd.code, dvd.除权除息日 having count(*) > 1 order by dvd.code)
      and 方案进度 = '实施分配' and dvdc.time > _start_time
    union all
    select
      dvdv.code,
      除权除息日,
      0.0000 price,
      '股票送转'::varchar(30) transaction_type,
      0.00 cash,
      case when 送转总比例 is null then 0.00 else 送转总比例 end volume
    from securities_dividend dvdv
    where
      dvdv.code not in (select dvd.code from securities_dividend dvd group by dvd.code, dvd.除权除息日 having count(*) > 1 order by dvd.code)
      and 方案进度 = '实施分配' and dvdv.time > _start_time
  ) pts;
end if;
end;
$$ LANGUAGE plpgsql;

drop function if exists merge_active_passive_series;
create or replace function merge_active_passive_series(
  _package_id integer, _start_time date, _interval interval, _cash numeric(10,2), _volume numeric(12,2), _codes varchar(6)[] default null)
returns table (package_id integer, code varchar(6), transaction_type varchar(30),
               "time" date, cash numeric(10,2), cash_balance numeric(20,2),
               price numeric(10,4), volume numeric(12,2), volume_balance numeric(20,2)) as $$
begin
return query
select
  s.package_id,
  s.code,
  s.transaction_type,
  s.time,
  s.cash,
  s.cash_balance,
  s.price,
  s.volume,
  s.volume_balance from (
    select _package_id package_id, ts.* from (
      select
        ats.code, ats.transaction_type, ats.time, ats.cash, 0.00::numeric(20,2) cash_balance, ats.price, ats.volume, 0.00::numeric(20,2) volume_balance
      from strategy_intervaled_active_time_cash_volume_series(_interval, _start_time, _cash, _volume, _codes) ats
      union all
      select
        pts.code, pts.transaction_type, pts.time, pts.cash, 0.00::numeric(20,2) cash_balance, pts.price, pts.volume, 0.00::numeric(20,2) volume_balance
      from strategy_passive_time_cash_volume_series(_start_time, _codes) pts
    ) ts
) s;
end;
$$ LANGUAGE plpgsql;

drop function if exists sort_transation_type;
create or replace function sort_transation_type(_transaction_type varchar(30))
returns integer as $$
declare
  transaction_types varchar(30)[] := array['存入现金', '股票分红', '买入股份', '股票送转'];
begin
return (
  select gs.i from (
    select generate_series(array_lower(transaction_types,1), array_upper(transaction_types,1)) i
  ) gs where (transaction_types)[i] = _transaction_type limit 1
);
end;
$$ LANGUAGE plpgsql;


drop function if exists strategy_1_series;
create or replace function strategy_1_series(_start_time date, _codes varchar(6)[] default null)
returns setof securities_strategy_deduction as $$
declare
  _strategy_id constant integer := 1;
  _package_id constant integer := 0;
  _interval constant interval := '4 weeks';
  _cash constant numeric(20,2) := 100000.00;
  _volume constant numeric(20,2) := 0.00;
  _pre_code varchar(6) := null;
  _pre_cash_balance numeric(20,2) := 0.00;
  _pre_volume_balance numeric(20,2) := 0.00;
  _rec record;
  _cursor cursor for
    select * from merge_active_passive_series(_package_id, _start_time, _interval, _cash, _volume, _codes) order by code, time, sort_transation_type(transaction_type);
begin
  open _cursor;
  loop
    fetch _cursor into _rec;
    exit when not found;
    if _pre_code is null or _pre_code <> _rec.code then
      _pre_cash_balance = 0.00;
      _pre_volume_balance = 0.00;
      _pre_code = _rec.code;
    end if;
    return next (
      _strategy_id, _rec.package_id::integer, _rec.code::varchar(6), _rec.time, _rec.transaction_type::varchar(30),
      case
        when _rec.transaction_type = '存入现金' then _rec.cash
        when _rec.transaction_type = '买入股份' then - floor(_pre_cash_balance / (100 * _rec.price)) * 100 * _rec.price
        when _rec.transaction_type = '股票分红' then floor(_pre_volume_balance / 10) * _rec.cash
        when _rec.transaction_type = '股票送转' then 0.00
      end::numeric(20,2), -- cash
      case
        when _rec.transaction_type = '存入现金' then _pre_cash_balance + _rec.cash
        when _rec.transaction_type = '买入股份' then _pre_cash_balance - floor(_pre_cash_balance / (100 * _rec.price)) * 100 * _rec.price
        when _rec.transaction_type = '股票分红' then _pre_cash_balance + floor(_pre_volume_balance / 10) * _rec.cash
        when _rec.transaction_type = '股票送转' then _pre_cash_balance
      end::numeric(20,2), -- cash_balance
      _rec.price::numeric(10,4),
      case
        when _rec.transaction_type = '存入现金' then 0.00
        when _rec.transaction_type = '买入股份' then floor(_pre_cash_balance / (100 * _rec.price)) * 100
        when _rec.transaction_type = '股票分红' then 0.00
        when _rec.transaction_type = '股票送转' then floor(_pre_volume_balance / 10) * _rec.volume
      end::numeric(20,2), -- volume
      case
        when _rec.transaction_type = '存入现金' then _pre_volume_balance
        when _rec.transaction_type = '买入股份' then _pre_volume_balance + floor(_pre_cash_balance / (100 * _rec.price)) * 100
        when _rec.transaction_type = '股票分红' then _pre_volume_balance
        when _rec.transaction_type = '股票送转' then _pre_volume_balance + floor(_pre_volume_balance / 10) * _rec.volume
      end::numeric(20,2) --  volume_balance
    );
    case
      when _rec.transaction_type = '存入现金' then
        _pre_cash_balance := _pre_cash_balance + _rec.cash;
      when _rec.transaction_type = '买入股份' then
        _pre_volume_balance := _pre_volume_balance + floor(_pre_cash_balance / (100 * _rec.price)) * 100;
        _pre_cash_balance := _pre_cash_balance - floor(_pre_cash_balance / (100 * _rec.price)) * 100 * _rec.price;
      when _rec.transaction_type = '股票分红' then
        _pre_cash_balance := _pre_cash_balance + floor(_pre_volume_balance / 10) * _rec.cash;
      when _rec.transaction_type = '股票送转' then
        _pre_cash_balance := _rec.cash_balance;
        _pre_volume_balance := _pre_volume_balance + floor(_pre_volume_balance / 10) * _rec.volume;
    end case;
  end loop;
  close _cursor;
  return;
end;
$$ LANGUAGE plpgsql;

drop function if exists insert_strategy_1_series;
create or replace function insert_strategy_1_series(_start_time date, _codes varchar(6)[] default null)
returns void as $$
begin
insert into securities_strategy_deduction select * from strategy_1_series(_start_time, _codes);
end;
$$ LANGUAGE plpgsql;

drop function if exists strategy_outcome;
create or replace function strategy_outcome(_strategy_id integer, _package_id integer, _start_time date, _end_time date, _codes varchar(6)[] default null)
returns table (strategy_id integer, package_id integer, code varchar(6), name varchar(10), start_time date, end_time date, income numeric(20,2), outcome numeric(20,2), "ratio%" numeric(10,2)) as $$
begin
if array_length(_codes, 1) <> 0 then
  return query
  select sdi.strategy_id, sdi.package_id, sdi.code, sc.name, _start_time, _end_time,
        sdi.income, round(sdo.outcome,2) outcome, round(sdo.outcome/sdi.income*100,2) "ratio%" from (
    select sd.strategy_id, sd.package_id, sd.code, round(sum(sd.cash),2) income
    from securities_strategy_deduction sd
    where
      sd.strategy_id = _strategy_id
      and sd.package_id = _package_id
      and sd.time between _start_time and _end_time
      and _codes @> array[sd.code]
      and sd.transaction_type = '存入现金'
    group by sd.strategy_id, sd.package_id, sd.code
  ) sdi
  join (
    select
      sd.strategy_id, sd.package_id, sd.code, sd.time, sd.cash_balance, sd.volume_balance,
      sd.volume_balance * dq.price + sd.cash_balance outcome from (
      select
        sd0.strategy_id, sd0.package_id, sd0.code, sd0.time, sd0.cash_balance, sd0.volume_balance,
        row_number() over (partition by sd0.strategy_id, sd0.package_id, sd0.code order by sd0.time desc)
      from securities_strategy_deduction sd0
    ) sd join securities_day_quote dq on sd.code = dq.code
    where sd.row_number = 1
  ) sdo on sdi.strategy_id = sdo.strategy_id and sdi.package_id = sdo.package_id and sdi.code = sdo.code
  join securities_code sc on sc.code = sdi.code;
else
  return query
  select sdi.strategy_id, sdi.package_id, sdi.code, sc.name, _start_time, _end_time,
        sdi.income, round(sdo.outcome,2) outcome, round(sdo.outcome/sdi.income*100,2) "ratio%" from (
    select sd.strategy_id, sd.package_id, sd.code, round(sum(sd.cash),2) income
    from securities_strategy_deduction sd
    where
      sd.strategy_id = _strategy_id
      and sd.package_id = _package_id
      and sd.time between _start_time and _end_time
      and sd.transaction_type = '存入现金'
    group by sd.strategy_id, sd.package_id, sd.code
  ) sdi
  join (
    select
      sd.strategy_id, sd.package_id, sd.code, sd.time, sd.cash_balance, sd.volume_balance,
      sd.volume_balance * dq.price + sd.cash_balance outcome from (
      select
        sd0.strategy_id, sd0.package_id, sd0.code, sd0.time, sd0.cash_balance, sd0.volume_balance,
        row_number() over (partition by sd0.strategy_id, sd0.package_id, sd0.code order by sd0.time desc)
      from securities_strategy_deduction sd0
    ) sd join securities_day_quote dq on sd.code = dq.code
    where sd.row_number = 1
  ) sdo on sdi.strategy_id = sdo.strategy_id and sdi.package_id = sdo.package_id and sdi.code = sdo.code
  join securities_code sc on sc.code = sdi.code;
end if;
end;
$$ LANGUAGE plpgsql;
