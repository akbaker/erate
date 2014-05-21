--CREATE MASTER TABLE
drop table if exists fabric.master2;

create table fabric.master2 as
select ncessch, fipst, leaid, schno, stid, seasch, leanm, schnam, lstree, lcity, lstate, lzip, lzip4, type, 
	status, latcod, loncod, conum, coname, cdcode, bies, level, chartr, member, geom
from analysis.nces_public_2011;

alter table fabric.master2
	add constraint fabric_master2_pkey primary key (ncessch),
	add constraint enforce_dims_geom check (st_ndims(geom) = 2),
	add constraint enforce_geotype_geom check (geometrytype(geom) = 'POINT'::text OR geom IS NULL),
	add constraint enforce_srid_geom check (st_srid(geom) = 4326);

--VIEW TABLE
select *
from fabric.master2;

--CAI 
select ncessch, nces_id, fiber
from fabric.master2, analysis.shp_cai2013_clean
where shp_cai2013_clean.nces_id = master2.ncessch;

alter table fabric.master2
	drop column if exists cai1;
alter table fabric.master2
	add column cai1 int;
with new_values as(
select nces_id, fiber as cai_fiber
	from analysis.shp_cai2013_clean
	order by nces_id
)
update fabric.master2
	set cai1 = new_values.cai_fiber
	from new_values
	where new_values.nces_id=master2.ncessch;
update fabric.master2
	set cai1 = -1
	where cai1 = 0;

select seasch, nces_id, fiber
from fabric.master2, analysis.shp_cai2013_clean
where shp_cai2013_clean.nces_id = master2.seasch;

alter table fabric.master2
	drop column if exists cai2;
alter table fabric.master2
	add column cai2 int;
with new_values as(
select nces_id, fiber as cai_fiber
	from analysis.shp_cai2013_clean
	order by nces_id
)
update fabric.master2
	set cai2 = new_values.cai_fiber
	from new_values
	where new_values.nces_id=master2.seasch;
update fabric.master2
	set cai2 = -1
	where cai2 = 0;

select stid, nces_id, fiber
from fabric.master2, analysis.shp_cai2013_clean
where shp_cai2013_clean.nces_id = master2.stid;

alter table fabric.master2
	drop column if exists cai3;
alter table fabric.master2
	add column cai3 int;
with new_values as(
select nces_id, fiber as cai_fiber
	from analysis.shp_cai2013_clean
	order by nces_id
)
update fabric.master2
	set cai3 = new_values.cai_fiber
	from new_values
	where new_values.nces_id=master2.stid;
update fabric.master2
	set cai3 = -1
	where cai3 = 0;

alter table fabric.master2
	add column cai int;
update fabric.master2
	set cai = cai1
	where cai1 is not null;
update fabric.master2
	set cai = cai2
	where cai2 is not null;
update fabric.master2
	set cai = cai3
	where cai3 is not null;
update fabric.master2
	set cai = 0
	where cai is null;

select cai, count(*)
from fabric.master2
group by cai;

--VERIZON
select *
from fabric.master2, analysis.verizon_sch
where master2.schnam = verizon_sch.school_name
	and master2.lcity = verizon_sch.school_city
	and master2.lstate = verizon_sch.state;

alter table fabric.master2
	drop column if exists verizon;
alter table fabric.master2
	add column verizon int;
with new_values as(
select school_name, school_city, state, fiber as verizon_fiber
	from analysis.verizon_sch
)
update fabric.master2
	set verizon = new_values.verizon_fiber
	from new_values
	where master2.schnam = new_values.school_name
		and master2.lcity = new_values.school_city
		and master2.lstate = new_values.state;