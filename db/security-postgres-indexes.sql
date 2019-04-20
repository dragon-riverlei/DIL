drop function if exists drop_index_securities_ipo;
create or replace function drop_index_securities_ipo() returns void as $$
begin
drop index if exists securities_ipo_idx_year;
drop index if exists securities_ipo_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_ipo;
create or replace function create_index_securities_ipo() returns void as $$
begin
create index securities_ipo_idx_year on securities_ipo ((extract(year from ipo_time)));
create index securities_ipo_idx_month on securities_ipo ((extract(month from ipo_time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_dividend;
create or replace function drop_index_securities_dividend() returns void as $$
begin
drop index if exists securities_dividend_idx_year;
drop index if exists securities_dividend_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_dividend;
create or replace function create_index_securities_dividend() returns void as $$
begin
create index securities_dividend_idx_year on securities_dividend ((extract(year from time)));
create index securities_dividend_idx_month on securities_dividend ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_balance_sheet_bank;
create or replace function drop_index_securities_balance_sheet_bank() returns void as $$
begin
drop index if exists securities_balance_sheet_bank_idx_year;
drop index if exists securities_balance_sheet_bank_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_balance_sheet_bank;
create or replace function create_index_securities_balance_sheet_bank() returns void as $$
begin
create index securities_balance_sheet_bank_idx_year on securities_balance_sheet_bank ((extract(year from time)));
create index securities_balance_sheet_bank_idx_month on securities_balance_sheet_bank ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_balance_sheet_general;
create or replace function drop_index_securities_balance_sheet_general() returns void as $$
begin
drop index if exists securities_balance_sheet_general_idx_year;
drop index if exists securities_balance_sheet_general_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_balance_sheet_general;
create or replace function create_index_securities_balance_sheet_general() returns void as $$
begin
create index securities_balance_sheet_general_idx_year on securities_balance_sheet_general ((extract(year from time)));
create index securities_balance_sheet_general_idx_month on securities_balance_sheet_general ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_balance_sheet_securities;
create or replace function drop_index_securities_balance_sheet_securities() returns void as $$
begin
drop index if exists securities_balance_sheet_securities_idx_year;
drop index if exists securities_balance_sheet_securities_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_balance_sheet_securities;
create or replace function create_index_securities_balance_sheet_securities() returns void as $$
begin
create index securities_balance_sheet_securities_idx_year on securities_balance_sheet_securities ((extract(year from time)));
create index securities_balance_sheet_securities_idx_month on securities_balance_sheet_securities ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_balance_sheet_insurance;
create or replace function drop_index_securities_balance_sheet_insurance() returns void as $$
begin
drop index if exists securities_balance_sheet_insurance_idx_year;
drop index if exists securities_balance_sheet_insurance_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_balance_sheet_insurance;
create or replace function create_index_securities_balance_sheet_insurance() returns void as $$
begin
create index securities_balance_sheet_insurance_idx_year on securities_balance_sheet_insurance ((extract(year from time)));
create index securities_balance_sheet_insurance_idx_month on securities_balance_sheet_insurance ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_cash_flow_sheet_bank;
create or replace function drop_index_securities_cash_flow_sheet_bank() returns void as $$
begin
drop index if exists securities_cash_flow_sheet_bank_idx_year;
drop index if exists securities_cash_flow_sheet_bank_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_cash_flow_sheet_bank;
create or replace function create_index_securities_cash_flow_sheet_bank() returns void as $$
begin
create index securities_cash_flow_sheet_bank_idx_year on securities_cash_flow_sheet_bank ((extract(year from time)));
create index securities_cash_flow_sheet_bank_idx_month on securities_cash_flow_sheet_bank ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_cash_flow_sheet_general;
create or replace function drop_index_securities_cash_flow_sheet_general() returns void as $$
begin
drop index if exists securities_cash_flow_sheet_general_idx_year;
drop index if exists securities_cash_flow_sheet_general_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_cash_flow_sheet_general;
create or replace function create_index_securities_cash_flow_sheet_general() returns void as $$
begin
create index securities_cash_flow_sheet_general_idx_year on securities_cash_flow_sheet_general ((extract(year from time)));
create index securities_cash_flow_sheet_general_idx_month on securities_cash_flow_sheet_general ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_cash_flow_sheet_securities;
create or replace function drop_index_securities_cash_flow_sheet_securities() returns void as $$
begin
drop index if exists securities_cash_flow_sheet_securities_idx_year;
drop index if exists securities_cash_flow_sheet_securities_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_cash_flow_sheet_securities;
create or replace function create_index_securities_cash_flow_sheet_securities() returns void as $$
begin
create index securities_cash_flow_sheet_securities_idx_year on securities_cash_flow_sheet_securities ((extract(year from time)));
create index securities_cash_flow_sheet_securities_idx_month on securities_cash_flow_sheet_securities ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_cash_flow_sheet_insurance;
create or replace function drop_index_securities_cash_flow_sheet_insurance() returns void as $$
begin
drop index if exists securities_cash_flow_sheet_insurance_idx_year;
drop index if exists securities_cash_flow_sheet_insurance_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_cash_flow_sheet_insurance;
create or replace function create_index_securities_cash_flow_sheet_insurance() returns void as $$
begin
create index securities_cash_flow_sheet_insurance_idx_year on securities_cash_flow_sheet_insurance ((extract(year from time)));
create index securities_cash_flow_sheet_insurance_idx_month on securities_cash_flow_sheet_insurance ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_profit_sheet_bank;
create or replace function drop_index_securities_profit_sheet_bank() returns void as $$
begin
drop index if exists securities_profit_sheet_bank_idx_year;
drop index if exists securities_profit_sheet_bank_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_profit_sheet_bank;
create or replace function create_index_securities_profit_sheet_bank() returns void as $$
begin
create index securities_profit_sheet_bank_idx_year on securities_profit_sheet_bank ((extract(year from time)));
create index securities_profit_sheet_bank_idx_month on securities_profit_sheet_bank ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_profit_sheet_general;
create or replace function drop_index_securities_profit_sheet_general() returns void as $$
begin
drop index if exists securities_profit_sheet_general_idx_year;
drop index if exists securities_profit_sheet_general_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_profit_sheet_general;
create or replace function create_index_securities_profit_sheet_general() returns void as $$
begin
create index securities_profit_sheet_general_idx_year on securities_profit_sheet_general ((extract(year from time)));
create index securities_profit_sheet_general_idx_month on securities_profit_sheet_general ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_profit_sheet_securities;
create or replace function drop_index_securities_profit_sheet_securities() returns void as $$
begin
drop index if exists securities_profit_sheet_securities_idx_year;
drop index if exists securities_profit_sheet_securities_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_profit_sheet_securities;
create or replace function create_index_securities_profit_sheet_securities() returns void as $$
begin
create index securities_profit_sheet_securities_idx_year on securities_profit_sheet_securities ((extract(year from time)));
create index securities_profit_sheet_securities_idx_month on securities_profit_sheet_securities ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_profit_sheet_insurance;
create or replace function drop_index_securities_profit_sheet_insurance() returns void as $$
begin
drop index if exists securities_profit_sheet_insurance_idx_year;
drop index if exists securities_profit_sheet_insurance_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_profit_sheet_insurance;
create or replace function create_index_securities_profit_sheet_insurance() returns void as $$
begin
create index securities_profit_sheet_insurance_idx_year on securities_profit_sheet_insurance ((extract(year from time)));
create index securities_profit_sheet_insurance_idx_month on securities_profit_sheet_insurance ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_cash_flow_sheet_running_total;
create or replace function drop_index_securities_cash_flow_sheet_running_total() returns void as $$
begin
drop index if exists securities_cash_flow_sheet_running_total_idx_year;
drop index if exists securities_cash_flow_sheet_running_total_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_cash_flow_sheet_running_total;
create or replace function create_index_securities_cash_flow_sheet_running_total() returns void as $$
begin
create index securities_cash_flow_sheet_running_total_idx_year on securities_cash_flow_sheet_running_total ((extract(year from time)));
create index securities_cash_flow_sheet_running_total_idx_month on securities_cash_flow_sheet_running_total ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_profit_sheet_running_total;
create or replace function drop_index_securities_profit_sheet_running_total() returns void as $$
begin
drop index if exists securities_profit_sheet_running_total_idx_year;
drop index if exists securities_profit_sheet_running_total_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_profit_sheet_running_total;
create or replace function create_index_securities_profit_sheet_running_total() returns void as $$
begin
create index securities_profit_sheet_running_total_idx_year on securities_profit_sheet_running_total ((extract(year from time)));
create index securities_profit_sheet_running_total_idx_month on securities_profit_sheet_running_total ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_kpi;
create or replace function drop_index_securities_kpi() returns void as $$
begin
drop index if exists securities_kpi_idx_year;
drop index if exists securities_kpi_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_kpi;
create or replace function create_index_securities_kpi() returns void as $$
begin
create index securities_kpi_idx_year on securities_kpi ((extract(year from time)));
create index securities_kpi_idx_month on securities_kpi ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_index_securities_stock_structure;
create or replace function drop_index_securities_stock_structure() returns void as $$
begin
drop index if exists securities_stock_structure_idx_year;
drop index if exists securities_stock_structure_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_securities_stock_structure;
create or replace function create_index_securities_stock_structure() returns void as $$
begin
create index securities_stock_structure_idx_year on securities_stock_structure ((extract(year from time)));
create index securities_stock_structure_idx_month on securities_stock_structure ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists create_index_securities_stock_structure_sina;
create or replace function create_index_securities_stock_structure_sina() returns void as $$
begin
create index securities_stock_structure_sina_idx_year on securities_stock_structure_sina ((extract(year from time)));
create index securities_stock_structure_sina_idx_month on securities_stock_structure_sina ((extract(month from time)));
end;
$$ language plpgsql;

drop function if exists drop_all_indexes;
create or replace function drop_all_indexes() returns void as $$
begin
perform drop_index_securities_ipo();
perform drop_index_securities_dividend();
perform drop_index_securities_balance_sheet_bank();
perform drop_index_securities_balance_sheet_general();
perform drop_index_securities_balance_sheet_securities();
perform drop_index_securities_balance_sheet_insurance();
perform drop_index_securities_cash_flow_sheet_bank();
perform drop_index_securities_cash_flow_sheet_general();
perform drop_index_securities_cash_flow_sheet_securities();
perform drop_index_securities_cash_flow_sheet_insurance();
perform drop_index_securities_profit_sheet_bank();
perform drop_index_securities_profit_sheet_general();
perform drop_index_securities_profit_sheet_securities();
perform drop_index_securities_profit_sheet_insurance();
perform drop_index_securities_cash_flow_sheet_running_total();
perform drop_index_securities_profit_sheet_running_total();
perform drop_index_securities_kpi();
perform drop_index_securities_stock_structure();
end;
$$ language plpgsql;

drop function if exists create_all_indexes;
create or replace function create_all_indexes() returns void as $$
begin
perform create_index_securities_ipo();
perform create_index_securities_dividend();
perform create_index_securities_balance_sheet_bank();
perform create_index_securities_balance_sheet_general();
perform create_index_securities_balance_sheet_securities();
perform create_index_securities_balance_sheet_insurance();
perform create_index_securities_cash_flow_sheet_bank();
perform create_index_securities_cash_flow_sheet_general();
perform create_index_securities_cash_flow_sheet_securities();
perform create_index_securities_cash_flow_sheet_insurance();
perform create_index_securities_profit_sheet_bank();
perform create_index_securities_profit_sheet_general();
perform create_index_securities_profit_sheet_securities();
perform create_index_securities_profit_sheet_insurance();
perform create_index_securities_cash_flow_sheet_running_total();
perform create_index_securities_profit_sheet_running_total();
perform create_index_securities_kpi();
perform create_index_securities_stock_structure();
end;
$$ language plpgsql;
