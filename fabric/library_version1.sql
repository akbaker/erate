drop table if exists fabric.lib_master;

select *
into fabric.lib_master
from analysis.imls_lib;
----17598 records

--CAI
alter table fabric.lib_master
add column cai int;

with new_values as(
select imlsid, fiber AS cai_fiber
from fabric.imls_cai
)
update fabric.lib_master
set cai = new_values.cai_fiber
from new_values
where lib_master.lib_id = new_values.imlsid;

alter table fabric.lib_master
add column caiid character varying(10);

with new_values as(
select imlsid, caiid
from fabric.imls_cai
)
update fabric.lib_master
set caiid = new_values.caiid
from new_values
where lib_master.lib_id = new_values.imlsid;

select *
from fabric.lib_master;

--KANSAS
select *
from fabric.lib_master, fabric.ks_lib
where lib_master.lib_name = upper(ks_lib.library_name)
	and stab = 'KS';

alter table fabric.lib_master
add column ks_lib int;

with new_values as(
select library_name, fiber AS ks_fiber
from fabric.ks_lib
)
update fabric.lib_master
set ks_lib = new_values.ks_fiber
from new_values
where lib_name = upper(new_values.library_name)
	and stab = 'KS';

--NEW JERSEY
select *
from fabric.lib_master, fabric.nj_lib
where lib_master.caiid = nj_lib.cai_id;

alter table fabric.lib_master
add column nj_lib int;

with new_values as(
select cai_id, fiber AS nj_fiber
from fabric.nj_lib
)
update fabric.lib_master
set nj_lib = new_values.nj_fiber
from new_values
where lib_master.caiid = new_values.cai_id;

--MAINE
alter table fabric.lib_master
add column me_fscsseq character varying(3);

update fabric.lib_master
set me_fscsseq = fscsseq::text
where stab = 'ME';

update fabric.lib_master
set me_fscsseq = '00' || me_fscsseq
where char_length(me_fscsseq) = 1;

update fabric.lib_master
set me_fscsseq = '0' || me_fscsseq
where char_length(me_fscsseq) = 2;

alter table fabric.lib_master
add column me_fscskey character varying(10);

update fabric.lib_master
set me_fscskey = fscskey || me_fscsseq
where stab = 'ME';

alter table fabric.lib_master
add column me_lib int;

with new_values as(
select fscs_id, fiber AS me_fiber
from fabric.me_ind
where cai_type = 'LIB'
)
update fabric.lib_master
set me_lib = new_values.me_fiber
from new_values
where lib_master.me_fscskey = new_values.fscs_id;

--MISSOURI
select *
from fabric.lib_master, fabric.mo_lib
where lib_master.lib_name = upper(mo_lib.site_name)
	and stab = 'MO';

alter table fabric.lib_master
add column mo_lib int;

with new_values as(
select site_name, fiber as mo_fiber
from fabric.mo_lib
where loc_type = 'LIBRARY'
)
update fabric.lib_master
set mo_lib = new_values.mo_fiber
from new_values
where lib_master.lib_name = upper(new_values.site_name)
	and stab = 'MO';

--VERMONT
select *
from fabric.lib_master, fabric.vt_lib
where lib_master.lib_id = vt_lib.library_id
	and stab = 'VT';

alter table fabric.lib_master
add column vt_lib int;

with new_values as(
select library_id, fiber as vt_fiber
from fabric.vt_lib
)
update fabric.lib_master
set vt_lib = new_values.vt_fiber
from new_values
where lib_master.lib_id = new_values.library_id
	and stab = 'VT';



-------------------------CORROBORATION SCORE------------------------------
---Full score
alter table fabric.lib_master
	drop column if exists score;
alter table fabric.lib_master
	add column score int;
with new_values as(
select lib_id, coalesce(cai,0) + coalesce(ks_lib,0) + coalesce(nj_lib,0) + coalesce(me_lib,0)
	+ coalesce(mo_lib,0)
	as row_score
	from fabric.lib_master
)
update fabric.lib_master
	set score=new_values.row_score
	from new_values
	where lib_master.lib_id = new_values.lib_id;
	
update fabric.lib_master
	set score = 0
	where score IS NULL;

select score, count(*)
from fabric.lib_master
group by score
order by score;

--PIVOT TABLE 
alter table fabric.lib_master
	drop column if exists max_val;
alter table fabric.lib_master
	add column max_val int;
update fabric.lib_master
	set max_val = greatest(cai,ks_lib,nj_lib,me_lib,mo_lib);
select max_val, count(*)
	from fabric.lib_master
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
	from fabric.lib_master
	group by stab
	order by stab
);

--NATIONAL COUNTS
drop table if exists fabric.national_counts_library;

create table fabric.national_counts_library as(
select count(case when score < 0 then 1 end) as nofiber,
	count(case when score = 0 then 1 end) as unk,
	count(case when score > 0 then 1 end) as fiber
	from fabric.lib_master
);

---Public score
alter table fabric.lib_master
	drop column if exists score_public;
alter table fabric.lib_master
	add column score_public int;
with new_values as(
select lib_id, coalesce(cai,0) + coalesce(ks_lib,0) + coalesce(me_lib,0) + coalesce(mo_lib,0)
	as row_score
	from fabric.lib_master
)
update fabric.lib_master
	set score_public=new_values.row_score
	from new_values
	where lib_master.lib_id = new_values.lib_id;
	
update fabric.lib_master
	set score_public = 0
	where score_public IS NULL;

select score_public, count(*)
from fabric.lib_master
group by score_public
order by score_public;

--MAP DATA (JULY 25)
COPY (select stab, fscskey, lib_id, lib_name, lib_pop, longitude, latitude, fips_state, lib_loc, geom, block_fips, score_public AS fiber from fabric.lib_master) to '/Users/FCC/Documents/allison/data/fabric/library_fiber.csv' with delimiter '|' CSV header;

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
	from fabric.lib_master
	group by stab
	order by stab
);

--NATIONAL COUNTS
drop table if exists fabric.national_counts_library_public;

create table fabric.national_counts_library_public as(
select count(case when score_public < 0 then 1 end) as nofiber,
	count(case when score_public = 0 then 1 end) as unk,
	count(case when score_public > 0 then 1 end) as fiber
	from fabric.lib_master
);

--EXPORT TABLES
COPY (SELECT * FROM fabric.state_counts_library) to '/Users/FCC/Documents/allison/data/fabric/counts_library.csv' with delimiter '|' CSV header;
COPY (SELECT * FROM fabric.state_counts_library_public) to '/Users/FCC/Documents/allison/data/fabric/counts_library_public.csv' with delimiter '|' CSV header;
