DROP TABLE IF EXISTS fabric.master;

--Create master table
create table fabric.master as
select school_id, fips_state, leaid, stid, seasch, lea_name, school_name, lstreet, lcity, 
	lstate, lzip5, school_type, school_status, school_loc, latitude, longitude, county_name, cong_dist, 
	county_fips, school_lvl, tot_students, geom, state_schid, school_code_fl, school_code_nj, ncessch
from analysis.nces_pub_full;
alter table fabric.master
	add constraint fabric_master_pkey primary key (school_id),
	add constraint enforce_dims_geom CHECK (st_ndims(geom) = 2),
	add CONSTRAINT enforce_geotype_geom CHECK (geometrytype(geom) = 'POINT'::text OR geom IS NULL),
	add CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4326);
alter table fabric.master
	add column st_cd character varying(30);
update fabric.master
	set st_cd = stid || seasch
	where lstate = 'CA';
select max(length(st_cd)) from fabric.master;
	

--Clean CAI data
alter table fabric.master
	add column cai1 int;
with new_values as(
select nces_id, fiber as cai_fiber
	from analysis.shp_cai2013_clean
	order by nces_id
)
update fabric.master
	set cai1 = new_values.cai_fiber
	from new_values
	where new_values.nces_id=master.school_id;

alter table fabric.master
	add column cai2 int;
with new_values as(
select nces_id, fiber as cai2_fiber
	from analysis.shp_cai2013_clean
	order by nces_id
)
update fabric.master
	set cai2 = new_values.cai2_fiber
	from new_values
	where new_values.nces_id=master.state_schid;

alter table fabric.master
	add column cai int;
update fabric.master
	set cai = cai1
	where cai1 is not null;
update fabric.master
	set cai = cai2
	where cai2 is not null;

--Verizon data
-----check matches
select count(*)
	from fabric.master, analysis.verizon_sch
	where master.school_name = verizon_sch.school_name
		and master.lcity = verizon_sch.school_city
		and master.lzip5 = verizon_sch.school_zip;

----add column
alter table fabric.master 
	add column verizon int;
with new_values as(
select school_name, school_city, school_zip, fiber as verizon_fiber
	from analysis.verizon_sch
	order by school_id
)
update fabric.master
	set verizon = new_values.verizon_fiber
	from new_values
	where new_values.school_name = master.school_name
		and new_values.school_city = master.lcity
		and new_values.school_zip = master.lzip5;

--CA K-12 HSN
----Check matches
select st_cd, cds_code
	from fabric.master, fabric.cenic
	where master.st_cd=cds_code
	and lstate = 'CA'
	order by st_cd;
----match: 9610

----Add to column
alter table fabric.master
	add column ca_hsn int;
with new_values as(
select cds_code, fiber as cahsn_fiber
	from fabric.cenic
	order by cds_code
)
update fabric.master
	set ca_hsn = new_values.cahsn_fiber
	from new_values
	where new_values.cds_code=master.st_cd
		and lstate = 'CA';

--FLORIDA
----check matches
select school_code_fl, school_code
	from fabric.master, fabric.fl_ind
	where master.school_code_fl=fl_ind.school_code
	and lstate = 'FL'
	order by school_code;

----Add to column
alter table fabric.master
	add column fl_ind int;
with new_values as(
select school_code, fiber as fl_fiber
	from fabric.fl_ind
	order by school_code
)
update fabric.master
	set fl_ind=new_values.fl_fiber
	from new_values
	where master.school_code_fl=new_values.school_code
		and lstate = 'FL';

--WEST VIRGINA
----check matches
select wv_school_id, seasch
	from fabric.master, fabric.wv_ind
	where master.seasch=wv_ind.wv_school_id
	and lstate = 'WV';

----add fiber column
alter table fabric.master
	add column wv_ind int;
with new_values as(
select wv_school_id, fiber as wv_fiber
	from fabric.wv_ind
	order by wv_school_id
)
update fabric.master
	set wv_ind=new_values.wv_fiber
	from new_values
	where master.seasch=new_values.wv_school_id
		and lstate = 'WV';

--NORTH CAROLINA
alter table fabric.master
	add column nc_ind int;
update fabric.master
	set nc_ind = 0
	where (school_name = 'STANFIELD ELEMENTARY' or school_name = 'CHARLES E PERRY ELEMENTARY'
		or county_name = 'NASH COUNTY' or county_name = 'DAVIDSON COUNTY' or county_name = 'FRANKLIN COUNTY'
		or county_name = 'WARREN COUNTY' or county_name = 'IREDELL COUNTY' or county_name = 'CASEWELL COUNTY')
		and lstate = 'NC';
update fabric.master
	set nc_ind = 1
	where nc_ind is null and lstate = 'NC';

--NEW MEXICO
---check matches
select master.school_id, nm_ind.nces_id
	from fabric.master, fabric.nm_ind
	where master.school_id=nm_ind.nces_id
		and lstate = 'NM'
	order by master.school_id;

--add fiber column
alter table fabric.master
	add column nm_ind int;
with new_values as(
select nces_id, fiber as nm_fiber
	from fabric.nm_ind
	order by nces_id
)
update fabric.master
	set nm_ind=new_values.nm_fiber
	from new_values
	where master.school_id=new_values.nces_id
		and lstate = 'NM';

--MAINE
----check matches
select master.school_id, me_ind.nces_id
	from fabric.master, fabric.me_ind
	where master.school_id=me_ind.nces_id
		and lstate = 'ME'
	order by master.school_id;

----add fiber column
alter table fabric.master
	add column me_ind int;
with new_values as(
select nces_id, fiber as me_fiber
	from fabric.me_ind
	order by nces_id
)
update fabric.master
	set me_ind=new_values.me_fiber
	from new_values
	where master.school_id=new_values.nces_id
		and lstate = 'ME';

--NEW JERSEY
----check matches
select school_code_nj, nj_ind.school_id
	from fabric.master, fabric.nj_ind
	where master.school_code_nj=nj_ind.school_id
		and lstate = 'NJ';

----add fiber column
alter table fabric.master
	add column nj_ind int;
with new_values as(
select school_id, fiber as nj_fiber
	from fabric.nj_ind
	order by school_id
)
update fabric.master
	set nj_ind=new_values.nj_fiber
	from new_values
	where master.school_code_nj=new_values.school_id
		and lstate = 'NJ';

--ITEM 24
----check matches
select nces_pub_full.school_id, master.school_id
	from analysis.nces_pub_full, fabric.master
	where nces_pub_full.school_id=master.school_id;

----add fiber column
alter table fabric.master
	add column item24 int;
with new_values as(
select school_id, fiber_item24
	from analysis.nces_pub_full
	order by school_id
)
update fabric.master
	set item24=new_values.fiber_item24
	from new_values
	where master.school_id=new_values.school_id;
update fabric.master
	set item24=0
	where item24 is null;

------------------------------------------------------
----MAXIMUM VALUE
alter table fabric.master
	drop column if exists max_val;
alter table fabric.master
	add column max_val int;
update fabric.master
	set max_val = greatest(cai,verizon,ca_hsn,fl_ind, nj_ind, wv_ind, nc_ind, nm_ind, me_ind, item24);

----CORROBORATION SCORING
alter table fabric.master
	drop column if exists score;
alter table fabric.master
	add column score int;
with new_values as(
select school_id, coalesce(cai,0) + coalesce(verizon,0) + coalesce(ca_hsn,0) + coalesce(fl_ind,0) + coalesce(nj_ind,0) 
	+ coalesce(wv_ind,0) + coalesce(nc_ind,0) + coalesce(nm_ind,0) + coalesce(me_ind,0) + coalesce(item24,0) as row_score
	from fabric.master
)
update fabric.master
	set score=new_values.row_score
	from new_values
	where master.school_id = new_values.school_id;
	

select school_id, cai, verizon, ca_hsn, fl_ind, nj_ind, wv_ind, nc_ind, nm_ind, me_ind, item24, score
	from fabric.master
	where lstate = 'NJ' or lstate = 'CA' or lstate = 'FL' or lstate = 'WV' or lstate = 'NC'
		or lstate = 'NM' or lstate = 'ME'
	order by school_id;

select score, count(*)
	from fabric.master
	group by score
	order by score;

select lstate, score, count(*)
	from fabric.master
	group by lstate, score
	order by lstate, score;

select lstate, school_id, cai, verizon, ca_hsn, fl_ind, nj_ind, wv_ind, nc_ind, nm_ind, me_ind, item24, score
	from fabric.master
	where score = 3
	order by lstate;

----PIVOT TABLE
select lstate,
	count(case when score = -1 then max_val end) as nofiber_neg1,
	count(case when score = 0 then max_val end) as unknown_0,
	count(case when score = 1 then max_val end) as fiber_pos1,
	count(case when score = 2 then max_val end) as fiber_pos2,
	count(case when score = 3 then max_val end) as fiber_pos3,
	count(case when score = 4 then max_val end) as fiber_pos4
	from fabric.master
	group by lstate
	order by lstate;

---EXPORT FILE
COPY (SELECT * FROM fabric.master) to '/Users/FCC/Documents/allison/data/fabric/master.csv' with delimiter '|' CSV header;