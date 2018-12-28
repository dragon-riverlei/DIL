drop function if exists drop_index_{table};
create or replace function drop_index_{table}() returns void as $$
begin
drop index if exists {table}_idx_year;
drop index if exists {table}_idx_month;
end;
$$ language plpgsql;

drop function if exists create_index_{table};
create or replace function create_index_{table}() returns void as $$
begin
create index {table}_idx_year on {table} ((extract(year from time)));
create index {table}_idx_month on {table} ((extract(month from time)));
end;
$$ language plpgsql;

