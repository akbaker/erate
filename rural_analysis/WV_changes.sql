--CREATE WV ONLY TABLE
select *
into analysis.nces_pub_wv
from analysis.nces_pub_full
where lstate = 'WV';

--MARK CURRENT RURAL SCHOOLS
select leaid, MAX(school_loc) as ruralest_code
into analysis.temp_wv_ruralflag
from analysis.nces_pub_wv
group by leaid
order by leaid;

alter table analysis.temp_wv_ruralflag
add column rural_new int;

update analysis.temp_wv_ruralflag
set rural_new = 1
where ruralest_code > 40;

alter table analysis.nces_pub_wv
add column rural_new int;

with new_values as(
select leaid, rural_new AS flag
from analysis.temp_wv_ruralflag
)
update analysis.nces_pub_wv
set rural_new = new_values.flag
from new_values
where nces_pub_wv.leaid = new_values.leaid;

select rural_new, count(*)
from analysis.nces_pub_wv
group by rural_new;

--MARK FORMER RURAL SCHOOLS
alter table analysis.nces_pub_wv
add column rural_old int;

update analysis.nces_pub_wv
set rural_old = 1
where school_loc > 40;

update analysis.nces_pub_wv
set rural_old = 0
where school_loc < 40;

--MARK IF DISCOUNT AFFECTED
alter table analysis.nces_pub_wv
drop column if exists pct_farm;

alter table analysis.nces_pub_wv
add column pct_farm float;

update analysis.nces_pub_wv
set pct_farm = (free_lunch::float + reduc_lunch::float) / tot_students::float
where tot_students > 0;

alter table analysis.nces_pub_wv
add column discount_affected int;

update analysis.nces_pub_wv
set discount_affected = 1
where pct_farm < .495
	and tot_students <> 0;

update analysis.nces_pub_wv
set discount_affected = 0
where pct_farm >= .495
	and tot_students <> 0;

--COUNTS
select count(*)
from analysis.nces_pub_wv;

select rural_new, discount_affected, avg(pct_farm), count(*)
from analysis.nces_pub_wv
group by rural_new, discount_affected
order by rural_new, discount_affected;

select rural_old, discount_affected, avg(pct_farm), count(*)
from analysis.nces_pub_wv
group by rural_old, discount_affected
order by rural_old, discount_affected;

select leaid, SUM(rural_old), SUM(rural_new)
from analysis.nces_pub_wv
where discount_affected = 1
group by leaid
order by leaid;

select leaid, count(*)
from analysis.nces_pub_wv
group by leaid
order by leaid;

--CHECK CENSUS
select school_id, pub1011_priv0910_nces_census.ncessch, rural_new, rural_old, discount_affected, rural
from analysis.nces_pub_wv
left join census2010.pub1011_priv0910_nces_census
on nces_pub_wv.school_id = pub1011_priv0910_nces_census.ncessch;

--TABLE (6/9/2014)
-----Overall counts
select SUM(tot_students) AS tot_students, count(*) AS tot_schools
from analysis.nces_pub_full
where lstate = 'WV';

select leaid, count(*) AS tot_districts
from analysis.nces_pub_full
where lstate = 'WV'
group by leaid;

------Create table
alter table analysis.nces_pub_full
add column pct_farm float;

update analysis.nces_pub_full
set pct_farm = (free_lunch::float + reduc_lunch::float) / tot_students::float
where tot_students > 0;

drop table if exists analysis.nces_pub_WVtable_current;

select school_id, leaid, school_loc, pub1011_priv0910_nces_census.rural, pct_farm, tot_students, lstate
into analysis.nces_pub_WVtable_current
from analysis.nces_pub_full
left join census2010.pub1011_priv0910_nces_census
on nces_pub_full.school_id = pub1011_priv0910_nces_census.ncessch;

------Current def. of rural
select count(*) AS rural_schools
from analysis.nces_pub_WVtable_current
where lstate = 'WV' and rural = 1;

select leaid, SUM(rural) AS rural_schools, count(*) AS schools
from analysis.nces_pub_WVtable_current
where lstate = 'WV'
group by leaid
order by rural_schools;

select rural, count(*)
from analysis.nces_pub_WVtable_current
where lstate = 'WV'
group by rural;

-----New def. of rural
select count(*) AS rural_schools
from analysis.nces_pub_WVtable_current
where lstate = 'WV' and school_loc > 40;

alter table analysis.nces_pub_WVtable_current
add column rural_new int;

update analysis.nces_pub_WVtable_current
set rural_new = 1
where school_loc > 40;

update analysis.nces_pub_WVtable_current
set rural_new = 0
where school_loc < 40;

select leaid, SUM(rural_new) AS rural_schools, count(*) AS schools
from analysis.nces_pub_WVtable_current
where lstate = 'WV'
group by leaid
order by rural_schools;

------rural districts
alter table analysis.nces_pub_WVtable_current
add column rural_dist_current int;

alter table analysis.nces_pub_WVtable_current
add column rural_dist_new int;

with new_values as(
select leaid, MAX(rural) AS current_dist
from analysis.nces_pub_WVtable_current
where lstate = 'WV'
group by leaid
)
update analysis.nces_pub_WVtable_current
set rural_dist_current = new_values.current_dist
from new_values
where nces_pub_WVtable_current.leaid = new_values.leaid;

with new_values as(
select leaid, MAX(rural_new) AS new_dist
from analysis.nces_pub_WVtable_current
where lstate = 'WV'
group by leaid
)
update analysis.nces_pub_WVtable_current
set rural_dist_new = new_values.new_dist
from new_values
where nces_pub_WVtable_current.leaid = new_values.leaid;

select *
from analysis.nces_pub_WVtable_current
where lstate = 'WV';

------discounts rates
select leaid, MAX(rural_dist_current) AS current, MAX(rural_dist_new) AS new, count(*)
from analysis.nces_pub_WVtable_current
where lstate = 'WV'
group by leaid
order by current, new;

select count(*) AS schools, SUM(tot_students) AS students
from analysis.nces_pub_WVtable_current
where lstate = 'WV' and rural_dist_current = 0 and rural_dist_new = 1 and pct_farm < .495;