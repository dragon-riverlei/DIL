drop index if exists  securities_ipo_idx_year;
drop index if exists  securities_dividend_idx_year;
drop index if exists  securities_balance_sheet_bank_idx_year;
drop index if exists  securities_balance_sheet_general_idx_year;
drop index if exists  securities_balance_sheet_securities_idx_year;
drop index if exists  securities_balance_sheet_insurance_idx_year;
drop index if exists  securities_cash_flow_sheet_bank_idx_year;
drop index if exists  securities_cash_flow_sheet_general_idx_year;
drop index if exists  securities_cash_flow_sheet_securities_idx_year;
drop index if exists  securities_cash_flow_sheet_insurance_idx_year;
drop index if exists  securities_profit_sheet_bank_idx_year;
drop index if exists  securities_profit_sheet_general_idx_year;
drop index if exists  securities_profit_sheet_securities_idx_year;
drop index if exists  securities_profit_sheet_insurance_idx_year;
drop index if exists  securities_kpi_idx_year;
drop index if exists  securities_stock_structure_idx_year;
drop index if exists  securities_ipo_idx_month;
drop index if exists  securities_dividend_idx_month;
drop index if exists  securities_balance_sheet_bank_idx_month;
drop index if exists  securities_balance_sheet_general_idx_month;
drop index if exists  securities_balance_sheet_securities_idx_month;
drop index if exists  securities_balance_sheet_insurance_idx_month;
drop index if exists  securities_cash_flow_sheet_bank_idx_month;
drop index if exists  securities_cash_flow_sheet_general_idx_month;
drop index if exists  securities_cash_flow_sheet_securities_idx_month;
drop index if exists  securities_cash_flow_sheet_insurance_idx_month;
drop index if exists  securities_profit_sheet_bank_idx_month;
drop index if exists  securities_profit_sheet_general_idx_month;
drop index if exists  securities_profit_sheet_securities_idx_month;
drop index if exists  securities_profit_sheet_insurance_idx_month;
drop index if exists  securities_kpi_idx_month;
drop index if exists  securities_stock_structure_idx_month;

create index securities_ipo_idx_year on securities_ipo ((extract(year from ipo_time)));
create index securities_dividend_idx_year on securities_dividend ((extract(year from time)));
create index securities_balance_sheet_bank_idx_year on securities_balance_sheet_bank ((extract(year from time)));
create index securities_balance_sheet_general_idx_year on securities_balance_sheet_general ((extract(year from time)));
create index securities_balance_sheet_securities_idx_year on securities_balance_sheet_securities ((extract(year from time)));
create index securities_balance_sheet_insurance_idx_year on securities_balance_sheet_insurance ((extract(year from time)));
create index securities_cash_flow_sheet_bank_idx_year on securities_cash_flow_sheet_bank ((extract(year from time)));
create index securities_cash_flow_sheet_general_idx_year on securities_cash_flow_sheet_general ((extract(year from time)));
create index securities_cash_flow_sheet_securities_idx_year on securities_cash_flow_sheet_securities ((extract(year from time)));
create index securities_cash_flow_sheet_insurance_idx_year on securities_cash_flow_sheet_insurance ((extract(year from time)));
create index securities_profit_sheet_bank_idx_year on securities_profit_sheet_bank ((extract(year from time)));
create index securities_profit_sheet_general_idx_year on securities_profit_sheet_general ((extract(year from time)));
create index securities_profit_sheet_securities_idx_year on securities_profit_sheet_securities ((extract(year from time)));
create index securities_profit_sheet_insurance_idx_year on securities_profit_sheet_insurance ((extract(year from time)));
create index securities_kpi_idx_year on securities_kpi ((extract(year from time)));
create index securities_stock_structure_idx_year on securities_stock_structure ((extract(year from time)));
create index securities_ipo_idx_month on securities_ipo ((extract(month from ipo_time)));
create index securities_dividend_idx_month on securities_dividend ((extract(month from time)));
create index securities_balance_sheet_bank_idx_month on securities_balance_sheet_bank ((extract(month from time)));
create index securities_balance_sheet_general_idx_month on securities_balance_sheet_general ((extract(month from time)));
create index securities_balance_sheet_securities_idx_month on securities_balance_sheet_securities ((extract(month from time)));
create index securities_balance_sheet_insurance_idx_month on securities_balance_sheet_insurance ((extract(month from time)));
create index securities_cash_flow_sheet_bank_idx_month on securities_cash_flow_sheet_bank ((extract(month from time)));
create index securities_cash_flow_sheet_general_idx_month on securities_cash_flow_sheet_general ((extract(month from time)));
create index securities_cash_flow_sheet_securities_idx_month on securities_cash_flow_sheet_securities ((extract(month from time)));
create index securities_cash_flow_sheet_insurance_idx_month on securities_cash_flow_sheet_insurance ((extract(month from time)));
create index securities_profit_sheet_bank_idx_month on securities_profit_sheet_bank ((extract(month from time)));
create index securities_profit_sheet_general_idx_month on securities_profit_sheet_general ((extract(month from time)));
create index securities_profit_sheet_securities_idx_month on securities_profit_sheet_securities ((extract(month from time)));
create index securities_profit_sheet_insurance_idx_month on securities_profit_sheet_insurance ((extract(month from time)));
create index securities_kpi_idx_month on securities_kpi ((extract(month from time)));
create index securities_stock_structure_idx_month on securities_stock_structure ((extract(month from time)));