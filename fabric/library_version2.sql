drop table if exists fabric.lib_master3;

select *
into fabric.lib_master3
from analysis.imls_lib_2012;
----17586 records

delete from fabric.lib_master3
where c_out_ty = 'BM' or c_out_ty = 'BS';

--Update matching key
update fabric.lib_master3
set libid = fscskey || '-' || fscs_seq;

--Add number of visits
alter table fabric.lib_master3
add column visits int;

with new_values as(
select fscskey, visits
from analysis.imls_lib_stats
)
update fabric.lib_master3
set visits = new_values.visits
from new_values
where lib_master3.fscskey = new_values.fscskey;

--Add library system name
alter table fabric.lib_master3
add column system_name character varying(100);

with new_values as(
select fscskey, libname
from analysis.imls_lib_stats
)
update fabric.lib_master3
set system_name = new_values.libname
from new_values
where lib_master3.fscskey = new_values.fscskey;

--CAI
select *
from fabric.lib_master3, fabric.imls_cai
where lib_master3.libid = imls_cai.imlsid;


alter table fabric.lib_master3
add column cai int;

with new_values as(
select imlsid, fiber AS cai_fiber
from fabric.imls_cai
)
update fabric.lib_master3
set cai = new_values.cai_fiber
from new_values
where lib_master3.libid = new_values.imlsid;

alter table fabric.lib_master3
add column caiid character varying(10);

with new_values as(
select imlsid, caiid
from fabric.imls_cai
)
update fabric.lib_master3
set caiid = new_values.caiid
from new_values
where lib_master3.libid = new_values.imlsid;

select *
from fabric.lib_master3;

--KANSAS
select *
from fabric.lib_master3, fabric.ks_lib
where lib_master3.libname = upper(ks_lib.library_name)
	and stabr = 'KS';

alter table fabric.lib_master3
add column ks_lib int;

with new_values as(
select library_name, fiber AS ks_fiber
from fabric.ks_lib
)
update fabric.lib_master3
set ks_lib = new_values.ks_fiber
from new_values
where libname = upper(new_values.library_name)
	and stabr = 'KS';

--MAINE
alter table fabric.lib_master3
add column me_fscskey character varying(10);

update fabric.lib_master3
set me_fscskey = fscskey || fscs_seq
where stabr = 'ME';

select *
from fabric.lib_master3
where stabr = 'ME';

alter table fabric.lib_master3
add column me_lib int;

with new_values as(
select fscs_id, fiber AS me_fiber
from fabric.me_ind
where cai_type = 'LIB'
)
update fabric.lib_master3
set me_lib = new_values.me_fiber
from new_values
where lib_master3.me_fscskey = new_values.fscs_id;

--MISSOURI
select *
from fabric.lib_master3, fabric.mo_lib
where lib_master3.libname = upper(mo_lib.site_name)
	and stabr = 'MO';

alter table fabric.lib_master3
add column mo_lib int;

with new_values as(
select site_name, fiber as mo_fiber
from fabric.mo_lib
where loc_type = 'LIBRARY'
)
update fabric.lib_master3
set mo_lib = new_values.mo_fiber
from new_values
where lib_master3.libname = upper(new_values.site_name)
	and stabr = 'MO';

--VERMONT
select *
from fabric.lib_master3, fabric.vt_lib
where lib_master3.libid = vt_lib.library_id
	and stabr = 'VT';

alter table fabric.lib_master3
add column vt_lib int;

with new_values as(
select library_id, fiber as vt_fiber
from fabric.vt_lib
)
update fabric.lib_master3
set vt_lib = new_values.vt_fiber
from new_values
where lib_master3.libid = new_values.library_id
	and stabr = 'VT';

--OHIO
select *
from fabric.lib_master3, fabric.oh_lib
where lib_master3.fscskey = oh_lib.fscs
	and lib_master3.libname = oh_lib.library_name;

alter table fabric.lib_master3
add column oh_lib int;

with new_values as(
select fscs, library_name, fiber as oh_fiber
from fabric.oh_lib
)
update fabric.lib_master3
set oh_lib = new_values.oh_fiber
from new_values
where lib_master3.fscskey = new_values.fscs
	and lib_master3.libname = new_values.library_name;

--EMAIL SUBMISSIONS
alter table fabric.lib_master3
add column email int;

update fabric.lib_master3
set email = 2
where fscskey = 'WI0120';

update fabric.lib_master3
set email = 2
where libid = 'WA0069-027';

update fabric.lib_master3
set email = 2
where libid = 'OH0043-002' or libid = 'OH0043-005' or fscskey = 'OH0083' or fscskey = 'OH0055';

update fabric.lib_master3
set email = 2
where fscskey = 'KS0256';

update fabric.lib_master3
set email = 2
where fscskey = 'KY0052' or fscskey = 'KY0090';

update fabric.lib_master3
set email = 2
where fscskey = 'IA0077' or fscskey = 'IA0084';

-------------------------CORROBORATION SCORE------------------------------
--MAP SCORE
alter table fabric.lib_master3
	drop column if exists score_map;
alter table fabric.lib_master3
	add column score_map int;

with new_values as(
select libid, coalesce(cai,0) + coalesce(ks_lib,0) + coalesce(me_lib,0)
	+ coalesce(mo_lib,0) + coalesce(vt_lib,0) + coalesce(oh_lib,0)
	+ coalesce(email,0)
	as row_score
from fabric.lib_master3
)
update fabric.lib_master3
set score_map = new_values.row_score
from new_values
where lib_master3.libid = new_values.libid;

update fabric.lib_master3 
set score_map =  0
where score_map IS NULL;

alter table fabric.lib_master3
	drop column if exists fiber_map;
alter table fabric.lib_master3
	add column fiber_map int;

update fabric.lib_master3
set fiber_map = 1
where score_map > 0;

update fabric.lib_master3
set fiber_map = 0
where score_map = 0;

update fabric.lib_master3
set fiber_map = -1
where score_map < 0;

select fiber_map, count(*)
from fabric.lib_master3
group by fiber_map
order by fiber_map;

select score_map, count(*)
from fabric.lib_master3
group by score_map
order by score_map;

select *
from fabric.lib_master3;

drop table if exists fabric.libmap_fiber;
create table fabric.libmap_fiber as(
select lib_master3.fscskey, lib_master3.system_name, lib_master3.libid, lib_master3.libname, lib_master3.c_out_ty AS lib_type, 
	lib_master3.geom, lib_master3.visits, lib_master3.cai, lib_master3.ks_lib AS kansas, lib_master3.me_lib AS maine, 
	lib_master3.mo_lib AS missouri, lib_master3.vt_lib AS vermont, lib_master3.oh_lib AS ohio, email,
	lib_master3.score_map AS score, lib_master2.fiber_map AS fiber_v1, lib_master3.fiber_map AS fiber_v2
from fabric.lib_master3
left join fabric.lib_master2
on lib_master3.libid = lib_master2.libid
);

copy(select * from fabric.libmap_fiber) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber.csv' with delimiter '|' CSV header;
