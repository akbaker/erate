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
select master2.ncessch, nm_ind.nces_id
	from fabric.master2, fabric.nm_ind
	where master2.ncessch=nm_ind.nces_id
		and lstate = 'NM';

alter table fabric.master2
	drop column if exists nm_ind;
alter table fabric.master2
	add column nm_ind int;
with new_values as(
select nces_id, fiber as nm_fiber
	from fabric.nm_ind
	order by nces_id
)
update fabric.master2
	set nm_ind=new_values.nm_fiber
	from new_values
	where master2.ncessch=new_values.nces_id
		and lstate = 'NM';

--MAINE
select master2.ncessch, me_ind.nces_id
	from fabric.master2, fabric.me_ind
	where master2.ncessch=me_ind.nces_id
		and lstate = 'ME';

alter table fabric.master2
	drop column if exists me_ind;
alter table fabric.master2
	add column me_ind int;
with new_values as(
select nces_id, fiber as me_fiber
	from fabric.me_ind
	order by nces_id
)
update fabric.master2
	set me_ind=new_values.me_fiber
	from new_values
	where master2.ncessch=new_values.nces_id
		and lstate = 'ME';

--NEW JERSEY
alter table fabric.master2
	drop column if exists stid_nj;
alter table fabric.master2
	add column stid_nj character(6);
alter table fabric.master2
	drop column if exists seasch_nj;
alter table fabric.master2
	add column seasch_nj character(3);
update fabric.master2
	set stid_nj = stid
	where char_length(stid) = 6
	and lstate = 'NJ';
update fabric.master2
	set stid_nj = '0' || stid
	where char_length(stid) = 5
	and lstate = 'NJ';
update fabric.master2
	set seasch_nj = seasch
	where char_length(seasch) = 3
	and lstate = 'NJ';
update fabric.master2
	set seasch_nj = '0' || seasch
	where char_length(seasch) = 2
	and lstate = 'NJ';
alter table fabric.master2
	add column school_code_nj character(9);
update fabric.master2
	set school_code_nj = stid_nj || seasch_nj;

select school_code_nj, nj_ind.school_id
	from fabric.master2, fabric.nj_ind
	where master2.school_code_nj=nj_ind.school_id
		and lstate = 'NJ';

alter table fabric.master2
	add column nj_ind int;
with new_values as(
select school_id, fiber as nj_fiber
	from fabric.nj_ind
	order by school_id
)
update fabric.master2
	set nj_ind=new_values.nj_fiber
	from new_values
	where master2.school_code_nj=new_values.school_id
		and lstate = 'NJ';

--TEXAS
alter table fabric.master2
	drop column if exists tx_ind;
alter table fabric.master2
	add column tx_ind int;
update fabric.master2
	set tx_ind = 1
	where leanm = 'ROUND ROCK ISD'
		and lstate = 'TX';
update fabric.master2
	set tx_ind = 1
	where leanm = 'PALESTINE ISD'
		and lstate = 'TX';

--MONTANA
select master2.schnam, mt_ind.school_name
	from fabric.master2, fabric.mt_ind
	where master2.schnam = upper(mt_ind.school_name)
		and master2.leanm = upper(mt_ind.district_name)
		and lstate='MT';

alter table fabric.master2
	drop column if exists mt_ind;
alter table fabric.master2
	add column mt_ind int;
with new_values as(
select school_name, district_name, fiber as mt_fiber
	from fabric.mt_ind
)
update fabric.master2
	set mt_ind=new_values.mt_fiber
	from new_values
	where master2.schnam = upper(new_values.school_name)
		and master2.leanm = upper(new_values.district_name)
		and lstate = 'MT';

update fabric.master2
	set mt_ind = -1
	where lstate = 'MT' and (schnam = 'POLARIS SCHOOL' or schnam = 'PLENTY COUPS HIGH SCHOOL' 
		or schnam = 'LUTHER SCHOOL' or schnam = 'HAMMOND SCHOOL' or schnam = 'HAWKS HOME SCHOOL' 
		or schnam = 'BENTON LAKE SCHOOL' or schnam = 'KINSEY SCHOOL' or ncessch = '302088000624' 
		or schnam = 'WEST GLACIER SCHOOL' or schnam = 'MALMBORG SCHOOL' or schnam = 'PASS CREEK SCHOOL' 
		or schnam = 'KESTER SCHOOL' or schnam = 'BABB SCHOOL' or schnam = 'EAST GLACIER PARK' 
		or schnam = 'GLENDALE SCHOOL' or schnam = 'CARDWELL SCHOOL' or ncessch = '300009800325' 
		or schnam = 'SAGE CREEK ELEMENTARY' or schnam = 'YAAK SCHOOL' or ncessch = '302067000619' 
		or ncessch = '302067000166' or ncessch = '300093201025' or ncessch = '300093201024' or ncessch = '300093301026'
		or ncessch = '301719000538' or ncessch = '301719000251' or schnam = 'FISHTAIL SCHOOL'
		or schnam = 'LUSTRE SCHOOL' or schnam = 'MORIN SCHOOL' or schnam = 'PRAIRIE ELK COLONY SCHOOL'
		or schnam = 'RIMROCK COLONY SCHOOL' or schnam = 'MIAMI COLONY SCHOOL' or schnam = 'MIDWAY COLONY SCHOOL'
		or schnam = 'KING COLONY SCHOOL' or schnam = 'FAIRHAVEN COLONY SCHOOL' or schnam = 'CASCADE COLONY SCHOOL'
		or schnam = 'DEERFIELD COLONY SCHOOL' or schnam = 'NORTH HARLEM COLONY SCHOOL' or schnam = 'SPRING CREEK COLONY SCHOOL');

--SUNESYS
select sunesys.rev_appname, leanm, appstate, lstate
	from fabric.sunesys, fabric.master2
	where rev_appname=leanm
		and appstate=lstate
		and apptype = 'District';

alter table fabric.master2
	add column sunesys int;
with new_values as(
select sunesys.rev_appname, appstate, apptype, fiber as sunesys_fiber
	from fabric.sunesys
)
update fabric.master2
	set sunesys=new_values.sunesys_fiber
	from new_values
	where leanm=new_values.rev_appname
		and lstate=new_values.appstate
		and apptype = 'District';

--OHIO
select schnam, building_name, fiber, lcity, building_city
from fabric.master2, fabric.oh_ind
where master2.schnam = upper(oh_ind.building_name)
	and master2.lcity = upper(oh_ind.building_city)
	and lstate = 'OH';

alter table fabric.master2
	drop column if exists oh_ind;
alter table fabric.master2
	add column oh_ind int;
with new_values as(
select building_name, building_city, fiber as oh_fiber
from fabric.oh_ind
)
update fabric.master2
	set oh_ind = new_values.oh_fiber
	from new_values
	where master2.schnam = upper(new_values.building_name)
	and master2.lcity = upper(new_values.building_city)
	and master2.lstate = 'OH';

--H&B CABLE
alter table fabric.master
	drop column if exists hb_cable;
alter table fabric.master
	add column hb_cable int;
update fabric.master
	set hb_cable = 1
	where school_id = '200034901970' or school_id = '200034902028' or school_id = '200034901992'
		or school_id = '200582000731' or school_id = '200582000732' or school_id = '200582000733'
		or school_id = '200465000912' or school_id = '200465000914' or school_id = '200465000913';

--FAT BEAM
alter table fabric.master
	drop column if exists fatbeam;
alter table fabric.master
	add column fatbeam int;
update fabric.master
	set fatbeam = 1
	where leaid = '5301140' or leaid = '5303510' or leaid = '5304950' or leaid = '5308670' or leaid = '5310110'
		or leaid = '3005280' or leaid = '3005310' or leaid = '1600780' or leaid = '5305370' or leaid = '5302940'
		or leaid = '1602670';

--GEORGIA
select schnam, school_name, lcity, city, fiber
from fabric.master2, fabric.ga_ind
where master2.schnam = upper(ga_ind.school_name)
	and master2.lcity = upper(ga_ind.city);

alter table fabric.master2
	drop column if exists ga_ind;
alter table fabric.master2
	add column ga_ind int;
with new_values as(
select school_name, city, fiber AS ga_fiber
from fabric.ga_ind
)
update fabric.master2
set ga_ind = new_values.ga_fiber
from new_values
where master2.schnam = upper(new_values.school_name)
	and lcity = upper(new_values.city)
	and lstate = 'GA';

--BIE
select school_code, seasch, fiber
from fabric.master2, fabric.bie_ind
where seasch = school_code;

alter table fabric.master2
	drop column if exists bie_ind;
alter table fabric.master2
	add column bie_ind int;
with new_values as(
select school_code, fiber AS bie_fiber
from fabric.bie_ind
)
update fabric.master2
set bie_ind = new_values.bie_fiber
from new_values
where master2.seasch = new_values.school_code;

--NAVAJO
select ncessch, nces_id, fiber
from fabric.master2, fabric.navajo_schools
where master2.ncessch=navajo_schools.nces_id;

alter table fabric.master2
	drop column if exists navajo;
alter table fabric.master2
	add column navajo int;
with new_values as(
select nces_id, fiber as navajo_fiber
	from fabric.navajo_schools
	order by nces_id
)
update fabric.master2
	set navajo = new_values.navajo_fiber
	from new_values
	where new_values.nces_id=master2.ncessch;

--ARIZONA
alter table fabric.master2
	drop column if exists az_ind;
alter table fabric.master2
	add column az_ind int;
update fabric.master2
	set az_ind = 1
	where leanm = 'NOGALES UNIFIED DISTRICT'
		and lstate = 'AZ';

--TEXAS
alter table fabric.master2
	drop column if exists tx_ind;
alter table fabric.master2
	add column tx_ind int;
update fabric.master2
	set tx_ind = 1
	where leanm = 'ROUND ROCK ISD'
		and lstate = 'TX';
update fabric.master2
	set tx_ind = 1
	where leanm = 'PALESTINE ISD'
		and lstate = 'TX';

--------------------------------CORROBORATION SCORING----------------------------------

