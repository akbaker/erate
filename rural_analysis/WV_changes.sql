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
where pct_farm < .5;

--COUNTS
select rural_new, rural_old, discount_affected, count(*)
from analysis.nces_pub_wv
group by rural_new, rural_old, discount_affected;