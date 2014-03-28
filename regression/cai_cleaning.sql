--count number of schools in dataset (any type)
select count(*)
	from analysis.shp_cai2013_clean
	where caicat = '1';

--delete all non-school obs.
delete from analysis.shp_cai2013_clean
	where caicat <> '1';

select count(*)
	from analysis.shp_cai2013_clean;
----obs: 131,522

--delete schools with unknown BB service status
delete from analysis.shp_cai2013_clean
	where bbservice = 'U';
----obs: 75,172

select count(*)
	from analysis.shp_cai2013_clean;

--delete inconsistent observations (i.e., no BB service, but tech specified or BB service, but no tech)
delete from analysis.shp_cai2013_clean
	where bbservice = 'N' and transtech > 0;
----obs: 75,085

delete from analysis.shp_cai2013_clean
	where bbservice = 'Y' and transtech = -999;
delete from analysis.shp_cai2013_clean
	where bbservice = 'Y' and transtech = 0;
----obs: 54,849

--delete observations where caiid is null
delete from analysis.shp_cai2013_clean
	where caiid is null;
delete from analysis.shp_cai2013_clean
	where caiid = '<Null>';
delete from analysis.shp_cai2013_clean
	where caiid = 'ZZZZ';
delete from analysis.shp_cai2013_clean
	where caiid = '9999';
delete from analysis.shp_cai2013_clean
	where caiid = '-9999';
----obs: 50,618

select caiid, count(*)
	from analysis.shp_cai2013_clean
	group by caiid
	order by count desc;

select statecode, count(*)
	from analysis.shp_cai2013_clean
	group by statecode
	order by statecode asc;

--Create fiber indicator
alter table analysis.shp_cai2013_clean
	add column fiber integer;

update analysis.shp_cai2013_clean
	set fiber = 0
	where transtech <> 50;
update analysis.shp_cai2013_clean
	set fiber = 1
	where transtech = 50;

select fiber, count(*)
	from analysis.shp_cai2013_clean
	group by fiber;

--list duplicates
create table analysis.dup_cai as
select caiid, count(*) as mycount
	from analysis.shp_cai2013_clean
	group by caiid
	order by count(*) desc;

--delete all observations with duplicate NCES IDs
select count(*) from analysis.dup_cai where mycount = 1;
delete from analysis.dup_cai where mycount = 1;
select count(*) from analysis.dup_cai;
---699 NCES IDs have duplicates

--Delete dups from cleaning table
select shp_cai2013_clean.caiid
from analysis.shp_cai2013_clean, analysis.dup_cai
	where shp_cai2013_clean.caiid=dup_cai.caiid;
delete from analysis.shp_cai2013_clean using analysis.dup_cai
	where shp_cai2013_clean.caiid=dup_cai.caiid;
----obs: 48,144

--Compare matches for NCES ID and State ID (Ensure caiid has 12 characters)
alter table analysis.shp_cai2013_clean
	add column nces_id character(12);

update analysis.shp_cai2013_clean
	set nces_id = '0' || caiid
	where char_length(caiid) = 11;

update analysis.shp_cai2013_clean
	set nces_id = caiid
	where char_length(caiid) = 12;

select count(*)
	from analysis.shp_cai2013_clean
	inner join analysis.nces_pub_full
	on shp_cai2013_clean.nces_id=nces_pub_full.school_id;
----obs: 41,506

--Compare caiid and seasch (add leading zero to 11-character seasch codes)
alter table analysis.nces_pub_full
	add column state_schid character(12);

update analysis.nces_pub_full
	set state_schid = '0' || seasch
	where char_length(seasch) = 11;
	
select  count(*)
	from analysis.shp_cai2013_clean
	inner join analysis.nces_pub_full
	on shp_cai2013_clean.caiid= nces_pub_full.state_schid;
----obs: 133

--Match both conditions at the same time
select count(*)
	from analysis.shp_cai2013_clean
	inner join analysis.nces_pub_full
	on shp_cai2013_clean.nces_id=nces_pub_full.school_id 
		or shp_cai2013_clean.caiid= nces_pub_full.state_schid;
----obs: 41,639
