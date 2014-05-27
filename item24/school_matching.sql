select *
from analysis.nces_pub_full;

alter table analysis.nces_pub_full
drop column if exists ben;

drop table fabric.nces_pub_ben;

select school_id, school_name, leaid, lea_name, lstate, school_loc, tot_students, rev_nces_id, applicant_type, ben, size_sort
into fabric.nces_pub_ben
from analysis.nces_pub_full
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


--ADD COLUMNS
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

