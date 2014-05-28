--Check 
select download_speed, count(*)
from fabric.item24_cxns_mar28
group by download_speed
order by download_speed desc;


--CREATE MERGED TABLE
drop table fabric.nces_pub_ben;

select school_id, school_name, leaid, lea_name, lstate, school_loc, tot_students, size_sort, 
	applicant_name, applicant_type, ben
into fabric.nces_pub_ben
from analysis.nces_pub_full
inner join fabric.ben_nces_xwalk
on nces_pub_full.leaid = ben_nces_xwalk.rev_nces_id
	and applicant_type = 'District'
	and lea_name <> applicant_name;

delete from fabric.nces_pub_ben
where leaid = '0622710'
	and applicant_name <> 'LOS ANGELES UNIFIED SCHOOL DISTRICT';

select school_id, count(*) as count
into fabric.ben_dups
from fabric.nces_pub_ben
group by school_id
order by count desc;

select nces_pub_ben.school_id, school_name, leaid, lea_name, lstate, school_loc, tot_students, size_sort,
	applicant_name, applicant_type, ben, count
into fabric.nces_pub_ben_final
from fabric.nces_pub_ben
left join fabric.ben_dups
on nces_pub_ben.school_id = ben_dups.school_id;

delete from  fabric.nces_pub_ben_final
where count > 1;

--ADD COLUMNS
alter table fabric.nces_pub_ben_final
drop column if exists type_cxn;

alter table fabric.nces_pub_ben_final
drop column if exists download_speed;

alter table fabric.nces_pub_ben_final
add column type_cxn character varying(50);

alter table fabric.nces_pub_ben_final
add column download_speed double precision;

--CHECK TABLE
select *
from fabric.nces_pub_ben_final;

select count(*)
from fabric.nces_pub_ben_final
where download_speed is not null;

select type_cxn, count(*)
from fabric.nces_pub_ben_final
group by type_cxn;

--COST PER STUDENT
alter table fabric.nces_pub_ben_final
add column speed_per_student double precision;

update fabric.nces_pub_ben_final
set speed_per_student = download_speed / tot_students;

select speed_per_student, count(*)
from fabric.nces_pub_ben_final
group by speed_per_student
order by speed_per_student desc;

--DELETE OBSERVATIONS 
delete from fabric.nces_pub_ben_final
where type_cxn IS NULL;

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


--ASSIGN SCHOOL DISTRICT MEDIAN TO ALL SCHOOLS IN DISTRICT
select leaid, median(download_speed) AS median_value
from fabric.nces_pub_ben_final
group by leaid
order by leaid;

alter table fabric.nces_pub_ben_final
add column med_download_speed double precision;

with new_values as(
select leaid, median(download_speed) AS median_value
from fabric.nces_pub_ben_final
group by leaid
)
update fabric.nces_pub_ben_final
set med_download_speed = new_values.median_value
from new_values
where nces_pub_ben_final.leaid = new_values.leaid;

--GENERATE PER STUDENT SPEED USING MEDIAN
alter table fabric.nces_pub_ben_final
add column perstudent_download_speed_med double precision;

update fabric.nces_pub_ben_final
set perstudent_download_speed_med = med_download_speed / tot_students;

--SUMMARY STATS
select count(*), min(perstudent_download_speed_med), max(perstudent_download_speed_med), 
	min(med_download_speed), max(med_download_speed)
from fabric.nces_pub_ben_final
where med_download_speed is not null;

--CREATE DECILES
alter table fabric.nces_pub_ben_final
add column decile int;

with new_values as(
SELECT school_id, perstudent_download_speed_med, ntile(10) 
	over (order by perstudent_download_speed_med) as decile
FROM fabric.nces_pub_ben_final
)
update fabric.nces_pub_ben_final
set decile = new_values.decile
from new_values
where nces_pub_ben_final.school_id = new_values.school_id;

--FIND MEDIAN PER STUDENT DOWNLOAD SPEED FOR EACH DECILE
select decile, median(perstudent_download_speed_med) AS median_value, avg(perstudent_download_speed_med) AS avg_value
from fabric.nces_pub_ben_final
group by decile
order by decile;

alter table fabric.nces_pub_ben_final
add column decile_med_perstu_download double precision;

alter table fabric.nces_pub_ben_final
add column decile_avg_perstu_download double precision;

with new_values as(
select decile, median(perstudent_download_speed_med) AS median_value
from fabric.nces_pub_ben_final
group by decile
)
update fabric.nces_pub_ben_final
set decile_med_perstu_download = new_values.median_value
from new_values
where nces_pub_ben_final.decile = new_values.decile;

with new_values as(
select decile, avg(perstudent_download_speed_med) AS avg_value
from fabric.nces_pub_ben_final
group by decile
)
update fabric.nces_pub_ben_final
set decile_avg_perstu_download = new_values.avg_value
from new_values
where nces_pub_ben_final.decile = new_values.decile;

--OUTPUT TABLE 
COPY (SELECT * FROM fabric.nces_pub_ben_final WHERE type_cxn IS NOT NULL) to '/Users/FCC/Documents/allison/data/fabric/school_speeds.csv' with delimiter '|' CSV header;

--COMPRESSED TABLE
select decile, max(decile_med_perstu_download), max(decile_avg_perstu_download)
from fabric.nces_pub_ben_final
group by decile
order by decile;