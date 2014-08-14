drop table if exists fabric.lib_master2;

select *
into fabric.lib_master2
from analysis.imls_lib_2012;
----17586 records

delete from fabric.lib_master2
where c_out_ty = 'BM' or c_out_ty = 'BS';

--Update matching key
update fabric.lib_master2
set libid = fscskey || '-' || fscs_seq;

--Add number of visits
alter table fabric.lib_master2
add column visits int;

with new_values as(
select fscskey, visits
from analysis.imls_lib_stats
)
update fabric.lib_master2
set visits = new_values.visits
from new_values
where lib_master2.fscskey = new_values.fscskey;

select libname, system_name
from fabric.lib_master2
order by system_name;

--Add library system name
alter table fabric.lib_master2
add column system_name character varying(100);

with new_values as(
select fscskey, libname
from analysis.imls_lib_stats
)
update fabric.lib_master2
set system_name = new_values.libname
from new_values
where lib_master2.fscskey = new_values.fscskey;

--CAI
select *
from fabric.lib_master2, fabric.imls_cai
where lib_master2.libid = imls_cai.imlsid;


alter table fabric.lib_master2
add column cai int;

with new_values as(
select imlsid, fiber AS cai_fiber
from fabric.imls_cai
)
update fabric.lib_master2
set cai = new_values.cai_fiber
from new_values
where lib_master2.libid = new_values.imlsid;

alter table fabric.lib_master2
add column caiid character varying(10);

with new_values as(
select imlsid, caiid
from fabric.imls_cai
)
update fabric.lib_master2
set caiid = new_values.caiid
from new_values
where lib_master2.libid = new_values.imlsid;

select *
from fabric.lib_master2;

--KANSAS
select *
from fabric.lib_master2, fabric.ks_lib
where lib_master2.libname = upper(ks_lib.library_name)
	and stabr = 'KS';

alter table fabric.lib_master2
add column ks_lib int;

with new_values as(
select library_name, fiber AS ks_fiber
from fabric.ks_lib
)
update fabric.lib_master2
set ks_lib = new_values.ks_fiber
from new_values
where libname = upper(new_values.library_name)
	and stabr = 'KS';

--NEW JERSEY
select *
from fabric.lib_master2, fabric.nj_lib
where lib_master2.caiid = nj_lib.cai_id;

alter table fabric.lib_master2
add column nj_lib int;

with new_values as(
select cai_id, fiber AS nj_fiber
from fabric.nj_lib
)
update fabric.lib_master2
set nj_lib = new_values.nj_fiber
from new_values
where lib_master2.caiid = new_values.cai_id;

--MAINE
alter table fabric.lib_master2
add column me_fscskey character varying(10);

update fabric.lib_master2
set me_fscskey = fscskey || fscs_seq
where stabr = 'ME';

select *
from fabric.lib_master2
where stabr = 'ME';

alter table fabric.lib_master2
add column me_lib int;

with new_values as(
select fscs_id, fiber AS me_fiber
from fabric.me_ind
where cai_type = 'LIB'
)
update fabric.lib_master2
set me_lib = new_values.me_fiber
from new_values
where lib_master2.me_fscskey = new_values.fscs_id;

--MISSOURI
select *
from fabric.lib_master2, fabric.mo_lib
where lib_master2.libname = upper(mo_lib.site_name)
	and stabr = 'MO';

alter table fabric.lib_master2
add column mo_lib int;

with new_values as(
select site_name, fiber as mo_fiber
from fabric.mo_lib
where loc_type = 'LIBRARY'
)
update fabric.lib_master2
set mo_lib = new_values.mo_fiber
from new_values
where lib_master2.libname = upper(new_values.site_name)
	and stabr = 'MO';

--VERMONT
select *
from fabric.lib_master2, fabric.vt_lib
where lib_master2.libid = vt_lib.library_id
	and stabr = 'VT';

alter table fabric.lib_master2
add column vt_lib int;

with new_values as(
select library_id, fiber as vt_fiber
from fabric.vt_lib
)
update fabric.lib_master2
set vt_lib = new_values.vt_fiber
from new_values
where lib_master2.libid = new_values.library_id
	and stabr = 'VT';

--OHIO
select *
from fabric.lib_master2, fabric.oh_lib
where lib_master2.fscskey = oh_lib.fscs
	and lib_master2.libname = oh_lib.library_name;

alter table fabric.lib_master2
add column oh_lib int;

with new_values as(
select fscs, library_name, fiber as oh_fiber
from fabric.oh_lib
)
update fabric.lib_master2
set oh_lib = new_values.oh_fiber
from new_values
where lib_master2.fscskey = new_values.fscs
	and lib_master2.libname = new_values.library_name;

-------------------------CORROBORATION SCORE------------------------------
--MAP SCORE
alter table fabric.lib_master2
	drop column if exists score_map;
alter table fabric.lib_master2
	add column score_map int;

with new_values as(
select libid, coalesce(cai,0) + coalesce(ks_lib,0) + coalesce(me_lib,0)
	+ coalesce(mo_lib,0) + coalesce(vt_lib,0) + coalesce(oh_lib,0)
	as row_score
from fabric.lib_master2
)
update fabric.lib_master2
set score_map = new_values.row_score
from new_values
where lib_master2.libid = new_values.libid;

update fabric.lib_master2 
set score_map =  0
where score_map IS NULL;

alter table fabric.lib_master2
	drop column if exists fiber_map;
alter table fabric.lib_master2
	add column fiber_map int;

update fabric.lib_master2
set fiber_map = 1
where score_map > 0;

update fabric.lib_master2
set fiber_map = 0
where score_map = 0;

update fabric.lib_master2
set fiber_map = -1
where score_map < 0;

select fiber_map, count(*)
from fabric.lib_master2
group by fiber_map
order by fiber_map;

select score_map, count(*)
from fabric.lib_master2
group by score_map
order by score_map;

select *
from fabric.lib_master2;

drop table if exists fabric.libmap_fiber_aug6;
create table fabric.libmap_fiber_aug6 as(
select fscskey, system_name, libid, libname, c_out_ty AS lib_type, geom, visits, score_map, fiber_map
from fabric.lib_master2
);

copy(select * from fabric.libmap_fiber_aug6) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber_aug6.csv' with delimiter '|' CSV header;


---FULL SCORE
alter table fabric.lib_master2
	drop column if exists score;
alter table fabric.lib_master2
	add column score int;
with new_values as(
select libid, coalesce(cai,0) + coalesce(ks_lib,0) + coalesce(nj_lib,0) + coalesce(me_lib,0)
	+ coalesce(mo_lib,0) + coalesce(vt_lib,0) + coalesce(oh_lib,0)
	as row_score
	from fabric.lib_master2
)
update fabric.lib_master2
	set score=new_values.row_score
	from new_values
	where lib_master2.libid = new_values.libid;
	
update fabric.lib_master2
	set score = 0
	where score IS NULL;

select score, count(*)
from fabric.lib_master2
group by score
order by score;

--PIVOT TABLE 
alter table fabric.lib_master2
	drop column if exists max_val;
alter table fabric.lib_master2
	add column max_val int;
update fabric.lib_master2
	set max_val = greatest(cai,ks_lib,nj_lib,me_lib,mo_lib);
select max_val, count(*)
	from fabric.lib_master2
	group by max_val
	order by max_val;

drop table if exists fabric.state_counts_library;

create table fabric.state_counts_library as(
select stab,
	count(*),
	count(case when score = -2 then 1 end) as nofiber_neg2,
	count(case when score = -1 then 1 end) as nofiber_neg1,
	count(case when score = 0 then 1 end) as unknown_0,
	count(case when score = 1 then 1 end) as fiber_pos1,
	count(case when score = 2 then 1 end) as fiber_pos2
	from fabric.lib_master2
	group by stab
	order by stab
);

--NATIONAL COUNTS
drop table if exists fabric.national_counts_library;

create table fabric.national_counts_library as(
select count(case when score < 0 then 1 end) as nofiber,
	count(case when score = 0 then 1 end) as unk,
	count(case when score > 0 then 1 end) as fiber
	from fabric.lib_master2
);

---Public score
alter table fabric.lib_master2
	drop column if exists score_public;
alter table fabric.lib_master2
	add column score_public int;
with new_values as(
select libid, coalesce(cai,0) + coalesce(ks_lib,0) + coalesce(me_lib,0) + coalesce(mo_lib,0) + coalesce(vt_lib,0) 
	+ coalesce(oh_lib,0)
	as row_score
	from fabric.lib_master2
)
update fabric.lib_master2
	set score_public=new_values.row_score
	from new_values
	where lib_master2.libid = new_values.libid;
	
update fabric.lib_master2
	set score_public = 0
	where score_public IS NULL;

select score_public, count(*)
from fabric.lib_master2
group by score_public
order by score_public;

--MAP DATA (JULY 25)
COPY (select stab, fscskey, libid, lib_name, lib_pop, longitude, latitude, fips_state, lib_loc, geom, block_fips, score_public AS fiber from fabric.lib_master2) to '/Users/FCC/Documents/allison/data/fabric/library_fiber.csv' with delimiter '|' CSV header;

--PIVOT TABLE 
drop table if exists fabric.state_counts_library_public;

create table fabric.state_counts_library_public as(
select stab,
	count(*),
	count(case when score_public = -2 then 1 end) as nofiber_neg2,
	count(case when score_public = -1 then 1 end) as nofiber_neg1,
	count(case when score_public = 0 then 1 end) as unknown_0,
	count(case when score_public = 1 then 1 end) as fiber_pos1,
	count(case when score_public = 2 then 1 end) as fiber_pos2
	from fabric.lib_master2
	group by stab
	order by stab
);

--NATIONAL COUNTS
drop table if exists fabric.national_counts_library_public;

create table fabric.national_counts_library_public as(
select count(case when score_public < 0 then 1 end) as nofiber,
	count(case when score_public = 0 then 1 end) as unk,
	count(case when score_public > 0 then 1 end) as fiber
	from fabric.lib_master2
);

--EXPORT TABLES
COPY (SELECT * FROM fabric.state_counts_library) to '/Users/FCC/Documents/allison/data/fabric/counts_library.csv' with delimiter '|' CSV header;
COPY (SELECT * FROM fabric.state_counts_library_public) to '/Users/FCC/Documents/allison/data/fabric/counts_library_public.csv' with delimiter '|' CSV header;
