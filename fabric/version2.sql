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

--CALIFORNIA (HSN K-12)
alter table fabric.master2
	drop column if exists st_cd;
alter table fabric.master2
	add column st_cd character varying(30);
update fabric.master2
	set st_cd = stid || seasch
	where lstate = 'CA';

select st_cd, cds_code, fiber
	from fabric.master2, fabric.cenic
	where master2.st_cd = cds_code
	and lstate = 'CA';

alter table fabric.master2
	drop column if exists ca_ind;
alter table fabric.master2
	add column ca_ind int;
with new_values as(
select cds_code, fiber as ca_fiber
	from fabric.cenic
	order by cds_code
)
update fabric.master2
	set ca_ind = new_values.ca_fiber
	from new_values
	where new_values.cds_code=master2.st_cd
		and lstate = 'CA';

--FLORIDA
alter table fabric.master2
	drop column if exists stid_fl;
alter table fabric.master2
	add column stid_fl character varying(2);
update fabric.master2
	set stid_fl = '0' || stid
	from fabric.fl_ind
	where char_length(stid) = 1
	and lstate = 'FL';
update fabric.master2
	set stid_fl = stid
	from fabric.fl_ind
	where char_length(stid) = 2;
alter table fabric.master2
	drop column if exists sea_fl;
alter table fabric.master2
	add column sea_fl character varying(4);
update fabric.master2
	set sea_fl = '000' || seasch
	where char_length(seasch) = 1
	and lstate = 'FL';
update fabric.master2
	set sea_fl = '00' || seasch
	where char_length(seasch) = 2
	and lstate = 'FL';
update fabric.master2
	set sea_fl = '0' || seasch
	where char_length(seasch) = 3
	and lstate  = 'FL';
update fabric.master2
	set sea_fl = seasch
	where char_length(seasch) = 4
	and lstate = 'FL';
alter table fabric.master2
	drop column if exists scd_fl;
alter table fabric.master2
	add column scd_fl character varying(22);
update fabric.master2
	set scd_fl = stid_fl || ' ' || sea_fl
	where lstate = 'FL';

select scd_fl, school_code, fiber
	from fabric.master2, fabric.fl_ind
	where master2.scd_fl = fl_ind.school_code
		and lstate = 'FL';

alter table fabric.master2
	drop column if exists fl_ind;
alter table fabric.master2
	add column fl_ind int;
with new_values as(
select school_code, fiber as fl_fiber
	from fabric.fl_ind
	order by school_code
)
update fabric.master2
	set fl_ind=new_values.fl_fiber
	from new_values
	where master2.scd_fl=new_values.school_code
		and lstate = 'FL';

--WEST VIRGINIA
select wv_school_id, seasch
	from fabric.master2, fabric.wv_ind
	where master2.seasch=wv_ind.wv_school_id
		and lstate = 'WV';

alter table fabric.master2
	drop column if exists wv_ind;
alter table fabric.master2
	add column wv_ind int;
with new_values as(
select wv_school_id, fiber as wv_fiber
	from fabric.wv_ind
	order by wv_school_id
)
update fabric.master2
	set wv_ind=new_values.wv_fiber
	from new_values
	where master2.seasch=new_values.wv_school_id
		and lstate = 'WV';

--NORTH CAROLINA
alter table fabric.master2
	drop column if exists nc_ind;
alter table fabric.master2
	add column nc_ind int;
update fabric.master2
	set nc_ind = -1
	where (schnam = 'STANFIELD ELEMENTARY' or schnam = 'CHARLES E PERRY ELEMENTARY'
		or coname = 'NASH COUNTY' or coname = 'DAVIDSON COUNTY' or coname = 'FRANKLIN COUNTY'
		or coname = 'WARREN COUNTY' or coname = 'IREDELL COUNTY' or coname = 'CASEWELL COUNTY')
		and lstate = 'NC';
update fabric.master2
	set nc_ind = 1
	where nc_ind is null and lstate = 'NC';

--NEW MEXICO
