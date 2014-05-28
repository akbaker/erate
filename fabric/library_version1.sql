﻿select *
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



-------------------------CORROBORATION SCORE------------------------------
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

select score, count(*)
from fabric.lib_master
group by score
order by score;