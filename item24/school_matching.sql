select *
from analysis.nces_pub_full;

alter table analysis.nces_pub_full
drop column if exists ben;

drop table fabric.nces_pub_ben;

select school_id, school_name, leaid, lea_name, lstate, school_loc, tot_students, size_sort
into fabric.nces_pub_ben
from analysis.nces_pub_full

select rev_nces_id, count(*)
from fabric.ben_nces_xwalk
group by rev_nces_id
order by count desc;

select rev_nces_id, count(*)
from fabric.ben_nces_xwalk
where char_length(rev_nces_id) = 7 
group by rev_nces_id
order by count desc;

select *
from fabric.ben_nces_xwalk
where rev_nces_id = '1200390';

select *
into fabric.test_district_ben
from fabric.nces_pub_ben 
inner join fabric.ben_nces_xwalk
on nces_pub_ben.leaid = ben_nces_xwalk.rev_nces_id
	and applicant_type = 'District';
--89,695


delete from fabric.test_district_ben
where leaid = '0622710'
	and applicant_name <> 'LOS ANGELES UNIFIED SCHOOL DISTRICT';

delete from fabric.test_district_ben
where leaid = '0620790'
	and applicant_name <> 'LAKESIDE UNION ELEM SCH DIST';

select school_id, count(*) as myCount
from fabric.test_district_ben
group by school_id
order by myCount desc;

select school_id, count(*)
from fabric.test_district_ben
where lea_name <> applicant_name
group by school_id;


OR char_lenth(rev_nces_id) = 12;


left join fabric.ben_nces_xwalk
on ben_nces_xwalk.rev_nces_id = nces_pub_full.leaid;



select school_id, COUNT(*) as myCount
from fabric.nces_pub_ben
where ben IS NOT NULL
group by school_id
order by myCount desc;
--Rows: 118,332
--Schools with BEN: 89,265

select *
from fabric.nces_pub_ben
where school_id = '120039002468';

select *
from fabric.nces_pub_ben
where ben = '16039003'
	and size_sort IS NOT NULL
order by leaid, size_sort;

select *
from fabric.nces_pub_ben
left join fabric.item24_cxns_mar28
on nces_pub_ben.ben = item24_cxns_mar28.ben;

select school_id, count(*)
from fabric.nces_pub_ben
group by school_id 
order by count desc;

select *
from fabric.nces_pub_ben
where school_id = '120039004074'



--ADD COLUMNS
alter table fabric.nces_pub_ben
drop column if exists type_cxn;

alter table fabric.nces_pub_ben
drop column if exists download_speed;

alter table fabric.nces_pub_ben
add column type_cxn character varying(50);

alter table fabric.nces_pub_ben
add column download_speed double precision;


--TEST TABLES
drop table fabric.item24_cxns_mar28_test;

select *
into fabric.item24_cxns_mar28_test
from fabric.item24_cxns_mar28
where ben = '139448';

insert into fabric.item24_cxns_mar28_test
values('2588448', '951687', '139448', 'COSSATOT RIVER SCHOOL DISTRICT', 'Fiber optic/OC-x', 2, 5);

select *
from fabric.item24_cxns_mar28_test
where ben = '139448'
order by download_speed DESC;

select *
from fabric.nces_pub_ben
where ben = '139448'
and size_sort IS NOT NULL
order by leaid, size_sort;

--Technologies
select type_cxn, count(*)
from fabric.item24_cxns_mar28
group by type_cxn
order by type_cxn;

