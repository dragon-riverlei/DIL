with
  kpi_c3_npr_l5 as (
    select k2.code, k2.归属于母公司股东的净利润同比, k2.row_num from (
      select k1.code, k1.time, k1.归属于母公司股东的净利润同比, row_number() over (partition by k1.code order by k1.time desc) row_num from (
        select k0.code, k0.time, round(k0.归属于母公司股东的净利润同比,2) 归属于母公司股东的净利润同比 from securities_kpi k0
         where k0."time" < now() and extract(month from k0."time") = 12 order by k0.code, k0.time) k1
       where k1.归属于母公司股东的净利润同比 is not null) k2
     where k2.row_num < 6 order by k2.code, k2.time
  )
select
  dq.code, dq."time",
  round(dq.price * ss.总股本 * 10000.0, 2) 市值,
  case when psrt.归属于母公司股东的净利润 <> 0 then round(dq.price * ss.总股本 * 10000.0 / psrt.归属于母公司股东的净利润, 4) else null end 市盈率,
  case when bs.归属于母公司股东的权益 <> 0 then round(dq.price * ss.总股本 * 10000.0 / bs.归属于母公司股东的权益, 4) else null end 市净率,
  case when psrt.归属于母公司股东的净利润 <> 0 and kpi_c3_npr.归属于母公司股东的净利润同比 <> 0 then round(dq.price * ss.总股本 * 10000.0 / psrt.归属于母公司股东的净利润 / kpi_c3_npr.归属于母公司股东的净利润同比, 4) else null end 市盈率vs净利润增长率,
  kpi_c3_npr_l5_arr.净利润过去五年增长率, round(kpi_c3_npr.归属于母公司股东的净利润同比,2) 净利润增长率
from (
  select dq1.code, dq1."time", dq1.price from securities_day_quote dq1 where dq1.time = (select max(dq0.time) from securities_day_quote dq0)) dq
join (
  select ss1.code, ss1.总股本 from securities_stock_structure_sina ss1
  join (select ss0.code, max(ss0.time) "time" from securities_stock_structure_sina ss0 group by ss0.code) ss2 on ss1.code = ss2.code and ss1."time" = ss2."time"
) ss on dq.code = ss.code
join (
  select psrt1.code, psrt1.归属于母公司股东的净利润 from securities_profit_sheet_running_total psrt1
  join (select psrt0.code, max(psrt0.time) "time" from securities_profit_sheet_running_total psrt0 group by psrt0.code) psrt2 on psrt1.code = psrt2.code and psrt1."time" = psrt2."time"
) psrt on dq.code = psrt.code
join (
  select bsb1.code code, bsb1.归属于母公司股东的权益 归属于母公司股东的权益 from securities_balance_sheet_bank bsb1
  join (select bsb0.code, max(bsb0.time) "time" from securities_balance_sheet_bank bsb0 group by bsb0.code) bsb2 on bsb1.code = bsb2.code and bsb1."time" = bsb2."time"
  union
  select bsg1.code code, bsg1.归属于母公司股东权益合计 归属于母公司股东的权益 from securities_balance_sheet_general bsg1
  join (select bsg0.code, max(bsg0.time) "time" from securities_balance_sheet_general bsg0 group by bsg0.code) bsg2 on bsg1.code = bsg2.code and bsg1."time" = bsg2."time"
  union
  select bss1.code code, bss1.归属于母公司所有者权益合计 归属于母公司股东的权益 from securities_balance_sheet_securities bss1
  join (select bss0.code, max(bss0.time) "time" from securities_balance_sheet_securities bss0 group by bss0.code) bss2 on bss1.code = bss2.code and bss1."time" = bss2."time"
  union
  select bsi1.code code, bsi1.归属于母公司的股东权益合计 归属于母公司股东的权益 from securities_balance_sheet_insurance bsi1
  join (select bsi0.code, max(bsi0.time) "time" from securities_balance_sheet_insurance bsi0 group by bsi0.code) bsi2 on bsi1.code = bsi2.code and bsi1."time" = bsi2."time"
) bs on dq.code = bs.code
join (
  select k.code, k.归属于母公司股东的净利润同比 from (
    select k0.code, 归属于母公司股东的净利润同比, row_number() over (partition by k0.code order by k0."time" desc) row_num from securities_kpi k0) k
  where k.row_num = 1
) kpi_c3_npr on dq.code = kpi_c3_npr.code
join (
  select kpi_c3_npr_l5.code, array_to_string(array_agg(kpi_c3_npr_l5.归属于母公司股东的净利润同比), '|') 净利润过去五年增长率 from kpi_c3_npr_l5 group by kpi_c3_npr_l5.code
) kpi_c3_npr_l5_arr on dq.code = kpi_c3_npr_l5_arr.code;


                                                                                                                               QUERY PLAN                                                                                                                                
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=36904.41..43135.60 rows=1 width=203) (actual time=1173.011..1439.663 rows=3449 loops=1)
   Hash Cond: (((ss1.code)::text = (ss0.code)::text) AND (ss1."time" = (max(ss0."time"))))
   CTE kpi_c3_npr_l5
     ->  Sort  (cost=1551.47..1551.84 rows=147 width=51) (actual time=313.713..314.664 rows=14889 loops=1)
           Sort Key: k2.code, k2."time"
           Sort Method: quicksort  Memory: 1548kB
           ->  Subquery Scan on k2  (cost=1531.88..1546.18 rows=147 width=51) (actual time=254.009..266.829 rows=14889 loops=1)
                 Filter: (k2.row_num < 6)
                 Rows Removed by Filter: 6953
                 ->  WindowAgg  (cost=1531.88..1540.68 rows=440 width=51) (actual time=254.007..264.335 rows=21842 loops=1)
                       ->  Sort  (cost=1531.88..1532.98 rows=440 width=43) (actual time=253.992..255.449 rows=21842 loops=1)
                             Sort Key: k0_1.code, k0_1."time" DESC
                             Sort Method: quicksort  Memory: 2475kB
                             ->  Sort  (cost=1507.06..1508.16 rows=440 width=43) (actual time=199.987..201.660 rows=21842 loops=1)
                                   Sort Key: k0_1.code, k0_1."time"
                                   Sort Method: quicksort  Memory: 2475kB
                                   ->  Bitmap Heap Scan on securities_kpi k0_1  (cost=11.72..1487.74 rows=440 width=43) (actual time=2.683..19.027 rows=21842 loops=1)
                                         Recheck Cond: (date_part('month'::text, ("time")::timestamp without time zone) = '12'::double precision)
                                         Filter: ((round("归属于母公司股东的净利润同比", 2) IS NOT NULL) AND ("time" < now()))
                                         Rows Removed by Filter: 3529
                                         Heap Blocks: exact=6757
                                         ->  Bitmap Index Scan on securities_kpi_idx_month  (cost=0.00..11.61 rows=442 width=0) (actual time=1.847..1.847 rows=25371 loops=1)
                                               Index Cond: (date_part('month'::text, ("time")::timestamp without time zone) = '12'::double precision)
   InitPlan 2 (returns $1)
     ->  Aggregate  (cost=2133.34..2133.35 rows=1 width=4) (actual time=17.650..17.650 rows=1 loops=1)
           ->  Seq Scan on securities_day_quote dq0  (cost=0.00..1893.67 rows=95867 width=4) (actual time=0.012..7.539 rows=99414 loops=1)
   ->  Nested Loop  (cost=32009.99..38241.08 rows=6 width=180) (actual time=1157.386..1405.283 rows=49913 loops=1)
         Join Filter: ((dq1.code)::text = (ss1.code)::text)
         ->  Nested Loop  (cost=32009.70..38240.32 rows=1 width=161) (actual time=1157.365..1346.270 rows=3517 loops=1)
               Join Filter: ((dq1.code)::text = (psrt1.code)::text)
               ->  Merge Join  (cost=32009.28..38229.50 rows=3 width=149) (actual time=1157.340..1303.051 rows=3517 loops=1)
                     Merge Cond: ((dq1.code)::text = (psrt0.code)::text)
                     ->  Merge Join  (cost=32008.86..35010.01 rows=3 width=138) (actual time=1157.294..1277.452 rows=3517 loops=1)
                           Merge Cond: ((dq1.code)::text = (bs.code)::text)
                           ->  Nested Loop  (cost=18323.16..21321.38 rows=19 width=90) (actual time=1061.060..1173.245 rows=3517 loops=1)
                                 ->  Merge Join  (cost=18322.74..21203.71 rows=19 width=73) (actual time=1043.375..1111.104 rows=3517 loops=1)
                                       Merge Cond: ((k.code)::text = (kpi_c3_npr_l5.code)::text)
                                       ->  Subquery Scan on k  (cost=18314.51..21189.04 rows=442 width=13) (actual time=719.881..773.152 rows=3517 loops=1)
                                             Filter: (k.row_num = 1)
                                             Rows Removed by Filter: 84930
                                             ->  WindowAgg  (cost=18314.51..20083.45 rows=88447 width=25) (actual time=719.877..766.266 rows=88447 loops=1)
                                                   ->  Sort  (cost=18314.51..18535.63 rows=88447 width=17) (actual time=719.865..728.695 rows=88447 loops=1)
                                                         Sort Key: k0.code, k0."time" DESC
                                                         Sort Method: quicksort  Memory: 8989kB
                                                         ->  Seq Scan on securities_kpi k0  (cost=0.00..11047.47 rows=88447 width=17) (actual time=0.009..32.163 rows=88447 loops=1)
                                       ->  GroupAggregate  (cost=8.23..11.54 rows=147 width=60) (actual time=323.487..333.318 rows=3517 loops=1)
                                             Group Key: kpi_c3_npr_l5.code
                                             ->  Sort  (cost=8.23..8.60 rows=147 width=60) (actual time=323.470..324.693 rows=14889 loops=1)
                                                   Sort Key: kpi_c3_npr_l5.code
                                                   Sort Method: quicksort  Memory: 1082kB
                                                   ->  CTE Scan on kpi_c3_npr_l5  (cost=0.00..2.94 rows=147 width=60) (actual time=313.718..318.240 rows=14889 loops=1)
                                 ->  Index Scan using securities_day_quote_pkey on securities_day_quote dq1  (cost=0.42..6.19 rows=1 width=17) (actual time=0.012..0.012 rows=1 loops=3517)
                                       Index Cond: (((code)::text = (k.code)::text) AND ("time" = $1))
                           ->  Sort  (cost=13685.70..13687.13 rows=569 width=48) (actual time=96.228..96.838 rows=3551 loops=1)
                                 Sort Key: bs.code
                                 Sort Method: quicksort  Memory: 263kB
                                 ->  Subquery Scan on bs  (cost=13648.28..13659.67 rows=569 width=48) (actual time=62.129..63.273 rows=3551 loops=1)
                                       ->  HashAggregate  (cost=13648.28..13653.98 rows=569 width=48) (actual time=62.128..62.731 rows=3551 loops=1)
                                             Group Key: bsb1.code, bsb1."归属于母公司股东的权益"
                                             ->  Append  (cost=41.30..13645.44 rows=569 width=48) (actual time=0.242..60.750 rows=3551 loops=1)
                                                   ->  Hash Join  (cost=41.30..104.54 rows=22 width=15) (actual time=0.241..0.462 rows=28 loops=1)
                                                         Hash Cond: (((bsb1.code)::text = (bsb0.code)::text) AND (bsb1."time" = (max(bsb0."time"))))
                                                         ->  Seq Scan on securities_balance_sheet_bank bsb1  (cost=0.00..59.02 rows=802 width=19) (actual time=0.007..0.086 rows=802 loops=1)
                                                         ->  Hash  (cost=40.88..40.88 rows=28 width=11) (actual time=0.191..0.191 rows=28 loops=1)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 10kB
                                                               ->  GroupAggregate  (cost=0.28..40.60 rows=28 width=11) (actual time=0.022..0.184 rows=28 loops=1)
                                                                     Group Key: bsb0.code
                                                                     ->  Index Only Scan using securities_balance_sheet_bank_pkey on securities_balance_sheet_bank bsb0  (cost=0.28..36.30 rows=802 width=11) (actual time=0.011..0.094 rows=802 loops=1)
                                                                           Heap Fetches: 0
                                                   ->  Hash Join  (cost=3793.95..13382.54 rows=517 width=17) (actual time=25.180..59.075 rows=3488 loops=1)
                                                         Hash Cond: (((bsg1.code)::text = (bsg0.code)::text) AND (bsg1."time" = (max(bsg0."time"))))
                                                         ->  Seq Scan on securities_balance_sheet_general bsg1  (cost=0.00..9045.83 rows=103383 width=21) (actual time=0.005..11.695 rows=103383 loops=1)
                                                         ->  Hash  (cost=3741.72..3741.72 rows=3482 width=11) (actual time=23.236..23.236 rows=3488 loops=1)
                                                               Buckets: 4096  Batches: 1  Memory Usage: 182kB
                                                               ->  GroupAggregate  (cost=0.42..3706.90 rows=3482 width=11) (actual time=0.028..22.509 rows=3488 loops=1)
                                                                     Group Key: bsg0.code
                                                                     ->  Index Only Scan using securities_balance_sheet_general_pkey on securities_balance_sheet_general bsg0  (cost=0.42..3155.16 rows=103383 width=11) (actual time=0.018..11.425 rows=103383 loops=1)
                                                                           Heap Fetches: 0
                                                   ->  Hash Join  (cost=44.14..129.47 rows=26 width=17) (actual time=0.566..0.620 rows=31 loops=1)
                                                         Hash Cond: (((bss1.code)::text = (bss0.code)::text) AND (bss1."time" = (max(bss0."time"))))
                                                         ->  Seq Scan on securities_balance_sheet_securities bss1  (cost=0.00..80.39 rows=939 width=21) (actual time=0.017..0.128 rows=939 loops=1)
                                                         ->  Hash  (cost=43.67..43.67 rows=31 width=11) (actual time=0.275..0.275 rows=31 loops=1)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 10kB
                                                               ->  GroupAggregate  (cost=0.28..43.36 rows=31 width=11) (actual time=0.033..0.267 rows=31 loops=1)
                                                                     Group Key: bss0.code
                                                                     ->  Index Only Scan using securities_balance_sheet_securities_pkey on securities_balance_sheet_securities bss0  (cost=0.28..38.36 rows=939 width=11) (actual time=0.018..0.137 rows=939 loops=1)
                                                                           Heap Fetches: 0
                                                   ->  Hash Join  (cost=10.22..20.36 rows=4 width=13) (actual time=0.141..0.147 rows=4 loops=1)
                                                         Hash Cond: (((bsi1.code)::text = (bsi0.code)::text) AND (bsi1."time" = (max(bsi0."time"))))
                                                         ->  Seq Scan on securities_balance_sheet_insurance bsi1  (cost=0.00..9.39 rows=139 width=17) (actual time=0.009..0.024 rows=139 loops=1)
                                                         ->  Hash  (cost=10.16..10.16 rows=4 width=11) (actual time=0.075..0.075 rows=4 loops=1)
                                                               Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                               ->  HashAggregate  (cost=10.09..10.12 rows=4 width=11) (actual time=0.065..0.066 rows=4 loops=1)
                                                                     Group Key: bsi0.code
                                                                     ->  Seq Scan on securities_balance_sheet_insurance bsi0  (cost=0.00..9.39 rows=139 width=11) (actual time=0.003..0.019 rows=139 loops=1)
                     ->  GroupAggregate  (cost=0.42..3176.07 rows=3471 width=11) (actual time=0.043..21.300 rows=3517 loops=1)
                           Group Key: psrt0.code
                           ->  Index Only Scan using securities_profit_sheet_running_total_pkey on securities_profit_sheet_running_total psrt0  (cost=0.42..2699.12 rows=88447 width=11) (actual time=0.027..10.392 rows=88447 loops=1)
                                 Heap Fetches: 0
               ->  Index Scan using securities_profit_sheet_running_total_pkey on securities_profit_sheet_running_total psrt1  (cost=0.42..3.60 rows=1 width=20) (actual time=0.012..0.012 rows=1 loops=3517)
                     Index Cond: (((code)::text = (psrt0.code)::text) AND ("time" = (max(psrt0."time"))))
         ->  Index Scan using securities_stock_structure_sina_idx_code on securities_stock_structure_sina ss1  (cost=0.29..0.57 rows=15 width=19) (actual time=0.011..0.013 rows=14 loops=3517)
               Index Cond: ((code)::text = (psrt1.code)::text)
   ->  Hash  (cost=1158.18..1158.18 rows=3404 width=11) (actual time=15.583..15.584 rows=3479 loops=1)
         Buckets: 4096  Batches: 1  Memory Usage: 182kB
         ->  HashAggregate  (cost=1090.11..1124.14 rows=3404 width=11) (actual time=14.345..14.881 rows=3479 loops=1)
               Group Key: ss0.code
               ->  Seq Scan on securities_stock_structure_sina ss0  (cost=0.00..840.07 rows=50007 width=11) (actual time=0.012..3.961 rows=50007 loops=1)
 Planning Time: 34.049 ms
 Execution Time: 1442.592 ms
