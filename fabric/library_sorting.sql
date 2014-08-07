--JOIN ON FRN: CHECK LINE/LOCATION COUNTS
select frn, count(*) as num_libraries
into fabric.block4_lib_count
from fabric.block4_may22_libonly
group by frn
order by frn;

select frn, sum(num_lines) as num_lines
into fabric.item24_cxns_lib_count
from fabric.item24_cxns_mar28
group by frn
order by frn;

select block4_lib_count.frn, num_libraries, num_lines
into fabric.block4_lib_check_counts
from fabric.block4_lib_count
left join fabric.item24_cxns_lib_count
on block4_lib_count.frn = item24_cxns_lib_count.frn
where num_lines >= num_libraries;

--JOIN ON FRN: KEEP ONLY LIBRARIES WITH CXNS
select funding_year, f471_appnum, block4_may22_libonly.frn, block5_item22, sub_worksheet, entity_rcv_svc_num,
	entity_rcv_name, entity_rcv_type, nces_code, rural_urban, student_count, student_nslp_count, 
	nslp_eligible_pct, discount_pct, weighted_product, prek_adult_juvenile_flag, alt_discount_mechanism_flag,
	num_libraries, num_lines
into fabric.block4_cxns_libonly
from fabric.block4_may22_libonly, fabric.block4_lib_check_counts
where block4_may22_libonly.frn = block4_lib_check_counts.frn;

--CREATE COLUMN FOR SORTING
alter table fabric.block4_cxns_libonly
drop column if exists size_sort;

alter table fabric.block4_cxns_libonly
add column size_sort int;

--CREATE COLUMNS FOR ASSIGNING CXNS
alter table fabric.block4_cxns_libonly
drop column if exists type_cxn;

alter table fabric.block4_cxns_libonly
add column type_cxn character varying(50);

alter table fabric.block4_cxns_libonly
drop column if exists download_speed;

alter table fabric.block4_cxns_libonly
add column download_speed double precision;

--RANGE OF SPEEDS
select download_speed, count(*)
from fabric.block4_cxns_libonly
group by download_speed
order by download_speed;

--CREATE BINS
alter table fabric.block4_cxns_libonly
drop column if exists bin;

alter table fabric.block4_cxns_libonly
add column bin int;

update fabric.block4_cxns_libonly
set bin = 1
where download_speed < 1.5;

update fabric.block4_cxns_libonly
set bin = 2
where download_speed >= 1.5 and download_speed < 5;

update fabric.block4_cxns_libonly
set bin = 3
where download_speed >= 5 and download_speed < 10;

update fabric.block4_cxns_libonly
set bin = 4
where download_speed >= 10 and download_speed < 25;

update fabric.block4_cxns_libonly
set bin = 5
where download_speed >= 25 and download_speed < 100;

update fabric.block4_cxns_libonly
set bin = 6
where download_speed >= 100 and download_speed < 1000;

update fabric.block4_cxns_libonly
set bin = 7
where download_speed >= 1000;

select bin, count(*)
from fabric.block4_cxns_libonly
group by bin
order by bin;

--DROP OUTLIER
select *
from fabric.block4_cxns_libonly
order by download_speed desc;

delete from fabric.block4_cxns_libonly
where frn = '2562206';

--CREATE DECILES
alter table fabric.block4_cxns_libonly
drop column if exists decile;

alter table fabric.block4_cxns_libonly
add column decile int;

with new_values as(
SELECT frn, size_sort, download_speed, ntile(10) 
	over (order by download_speed) as decile
FROM fabric.block4_cxns_libonly
)
update fabric.block4_cxns_libonly
set decile = new_values.decile
from new_values
where block4_cxns_libonly.frn = new_values.frn 
	and block4_cxns_libonly.size_sort = new_values.size_sort;

--CREATE MEDIAN FUCNTION
CREATE FUNCTION _final_median(anyarray) RETURNS float8 AS $$ 
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE VAL IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM 
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)  
  ) q2;
$$ LANGUAGE sql IMMUTABLE;
 
CREATE AGGREGATE median(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=_final_median,
  INITCOND='{}'
);

--FIND MEDIAN SPEED FOR EACH DECILE
select decile, median(download_speed) AS median_value, avg(download_speed) AS avg_value
from fabric.block4_cxns_libonly
group by decile
order by decile;

--COUNT OBSERVATIONS
select count(*)
from fabric.block4_cxns_libonly;
