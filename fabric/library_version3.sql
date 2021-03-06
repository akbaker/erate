﻿drop table if exists fabric.lib_master4;

select *
into fabric.lib_master4
from analysis.imls_lib_2012;
----17586 records

delete from fabric.lib_master4
where c_out_ty = 'BM' or c_out_ty = 'BS';

--Update matching key
update fabric.lib_master4
set libid = fscskey || '-' || fscs_seq;

--Add number of visits
alter table fabric.lib_master4
add column visits int;

with new_values as(
select fscskey, visits
from analysis.imls_lib_stats
)
update fabric.lib_master4
set visits = new_values.visits
from new_values
where lib_master4.fscskey = new_values.fscskey;

--Add library system name
alter table fabric.lib_master4
add column system_name character varying(100);

with new_values as(
select fscskey, libname
from analysis.imls_lib_stats
)
update fabric.lib_master4
set system_name = new_values.libname
from new_values
where lib_master4.fscskey = new_values.fscskey;

--CAI
select *
from fabric.lib_master4, fabric.imls_cai
where lib_master4.libid = imls_cai.imlsid;


alter table fabric.lib_master4
add column cai int;

with new_values as(
select imlsid, fiber AS cai_fiber
from fabric.imls_cai
)
update fabric.lib_master4
set cai = new_values.cai_fiber
from new_values
where lib_master4.libid = new_values.imlsid;

alter table fabric.lib_master4
add column caiid character varying(10);

with new_values as(
select imlsid, caiid
from fabric.imls_cai
)
update fabric.lib_master4
set caiid = new_values.caiid
from new_values
where lib_master4.libid = new_values.imlsid;

select *
from fabric.lib_master4;

--KANSAS
select *
from fabric.lib_master4, fabric.ks_lib
where lib_master4.libname = upper(ks_lib.library_name)
	and stabr = 'KS';

alter table fabric.lib_master4
add column kansas int;

with new_values as(
select library_name, fiber AS ks_fiber
from fabric.ks_lib
)
update fabric.lib_master4
set kansas = new_values.ks_fiber
from new_values
where libname = upper(new_values.library_name)
	and stabr = 'KS';

--MAINE
alter table fabric.lib_master4
add column me_fscskey character varying(10);

update fabric.lib_master4
set me_fscskey = fscskey || fscs_seq
where stabr = 'ME';

select *
from fabric.lib_master4
where stabr = 'ME';

alter table fabric.lib_master4
add column maine int;

with new_values as(
select fscs_id, fiber AS me_fiber
from fabric.me_ind
where cai_type = 'LIB'
)
update fabric.lib_master4
set maine = new_values.me_fiber
from new_values
where lib_master4.me_fscskey = new_values.fscs_id;

--MISSOURI
select *
from fabric.lib_master4, fabric.mo_lib
where lib_master4.libname = upper(mo_lib.site_name)
	and stabr = 'MO';

alter table fabric.lib_master4
add column missouri int;

with new_values as(
select site_name, fiber as mo_fiber
from fabric.mo_lib
where loc_type = 'LIBRARY'
)
update fabric.lib_master4
set missouri = new_values.mo_fiber
from new_values
where lib_master4.libname = upper(new_values.site_name)
	and stabr = 'MO';

--VERMONT
select *
from fabric.lib_master4, fabric.vt_lib
where lib_master4.libid = vt_lib.library_id
	and stabr = 'VT';

alter table fabric.lib_master4
add column vermont int;

with new_values as(
select library_id, fiber as vt_fiber
from fabric.vt_lib
)
update fabric.lib_master4
set vermont = new_values.vt_fiber
from new_values
where lib_master4.libid = new_values.library_id
	and stabr = 'VT';

--OHIO
select *
from fabric.lib_master4, fabric.oh_lib
where lib_master4.fscskey = oh_lib.fscs
	and lib_master4.libname = oh_lib.library_name;

alter table fabric.lib_master4
add column ohio int;

with new_values as(
select fscs, library_name, fiber as oh_fiber
from fabric.oh_lib
)
update fabric.lib_master4
set ohio = new_values.oh_fiber
from new_values
where lib_master4.fscskey = new_values.fscs
	and lib_master4.libname = new_values.library_name;

--EMAIL SUBMISSIONS
alter table fabric.lib_master4
	drop column if exists grantsburg,
	drop column if exists toledotel,
	drop column if exists wabash,
	drop column if exists peoples_telecom,
	drop column if exists peoples_rural,
	drop column if exists clear_lake,
	drop column if exists com_net,
	drop column if exists alliance,
	drop column if exists us_connect,
	drop column if exists heart_iowa,
	drop column if exists dc,
	drop column if exists blue_ridge,
	drop column if exists dobson,
	drop column if exists west_carolina_tel,
	drop column if exists manawa,
	drop column if exists srtc,
	drop column if exists premier,
	drop column if exists fibercomm,
	drop column if exists h_and_b,
	drop column if exists golden_belt,
	drop column if exists united,
	drop column if exists fontana,
	drop column if exists nextech,
	drop column if exists nemr,
	drop column if exists wilson,
	drop column if exists premier,
	drop column if exists van_horne,
	drop column if exists dumont,
	drop column if exists pioneer,
	drop column if exists webster_calhoun,
	drop column if exists gervais_datavision,
	drop column if exists paul_bunyan;
alter table fabric.lib_master4
	add column grantsburg int,
	add column toledotel int,
	add column wabash int,
	add column peoples_telecom int,
	add column peoples_rural int,
	add column clear_lake int,
	add column com_net int,
	add column alliance int,
	add column us_connect int,
	add column heart_iowa int,
	add column dc int,
	add column blue_ridge int,
	add column dobson int,
	add column west_carolina_tel int,
	add column manawa int,
	add column srtc int,
	add column premier int,
	add column fibercomm int,
	add column h_and_b int,
	add column golden_belt int,
	add column united int,
	add column fontana int,
	add column nextech int,
	add column nemr int,
	add column wilson int,
	add column van_horne int,
	add column dumont int,
	add column pioneer int,
	add column webster_calhoun int,
	add column gervais_datavision int,
	add column paul_bunyan int;

update fabric.lib_master4
set grantsburg = 2
where fscskey = 'WI0120';

update fabric.lib_master4
set toledotel = 2
where libid = 'WA0069-027';

update fabric.lib_master4
set wabash = 2
where libid = 'OH0043-002' or libid = 'OH0043-005' or fscskey = 'OH0083' or fscskey = 'OH0055';

update fabric.lib_master4
set peoples_telecom = 2
where fscskey = 'KS0256';

update fabric.lib_master4
set peoples_rural = 2
where fscskey = 'KY0052' or fscskey = 'KY0090';

update fabric.lib_master4
set clear_lake = 2
where fscskey = 'IA0077' or fscskey = 'IA0084';

update fabric.lib_master4
set com_net = 2
where libid = 'OH0176-002';

update fabric.lib_master4
set alliance = 2
where fscskey = 'IA0108';

update fabric.lib_master4
set heart_iowa = 2
where fscskey = 'IA0200' or fscskey = 'IA0395' or fscskey = 'IA0506' or fscskey = 'IA0243';

update fabric.lib_master4
set dc = 2
where libid = 'DC0001-003' or libid = 'DC0001-005' or libid = 'DC0001-006' or libid = 'DC0001-007'
	or libid = 'DC0001-028' or libid = 'DC0001-004' or libid = 'DC0001-008' or libid = 'DC0001-009'
	or libid = 'DC0001-015' or libid = 'DC0001-010' or libid = 'DC0001-002' or libid = 'DC0001-011'
	or libid = 'DC0001-012' or libid = 'DC0001-030' or libid = 'DC0001-013' or libid = 'DC0001-025'
	or libid = 'DC0001-014' or libid = 'DC0001-016' or libid = 'DC0001-017' or libid = 'DC0001-018'
	or libid = 'DC0001-019' or libid = 'DC0001-021' or libid = 'DC0001-022' or libid = 'DC0001-020'
	or libid = 'DC0001-023';

update fabric.lib_master4
set us_connect = -2
where fscskey = 'CO0094'; 

update fabric.lib_master4
set blue_ridge = 2
where fscskey = 'VA0008';

update fabric.lib_master4
set dobson = 2
where libid = 'OK0070-010';

update fabric.lib_master4
set west_carolina_tel = 2
where libid = 'SC0004-009' or libid = 'SC8003-001' or libid = 'SC8003-002' 
	or libid = 'SC8003-003' or libid = 'SC0028-002';

update fabric.lib_master4
set manawa = 2
where fscskey = 'WI0177';

update fabric.lib_master4
set srtc = 2
where libid = 'TX0086-002' or libid = 'TX0192-002' or libid = 'TX0078-002';

update fabric.lib_master4
set premier = 2
where fscskey = 'IA0184' or fscskey = 'IA0126' or fscskey = 'IA0424' or fscskey = 'IA0530';

update fabric.lib_master4
set fibercomm = 2
where fscskey = 'IA0225';

update fabric.lib_master4
set h_and_b = 2
where fscskey = 'KS0147' or fscskey = 'KS0091' or fscskey = 'KS0079';

update fabric.lib_master4
set golden_belt = 2
where fscskey = 'KS0010' or fscskey = 'KS0041' or fscskey = 'KS0290' or fscskey = 'KS0007'
	or fscskey = 'KS0306' or fscskey = 'KS0019' or fscskey = 'KS0287' or fscskey = 'KS0195'
	or fscskey = 'KS0284';
update fabric.lib_master4
set golden_belt = -2
where fscskey = 'KS0036' or fscskey = 'KS0280' or fscskey = 'KS0170';

update fabric.lib_master4
set united = 2
where fscskey = 'KS0299' or fscskey = 'KS0292';

update fabric.lib_master4
set fontana = 2
where libid = 'NC0008-005' or libid = 'NC0008-002' or libid = 'NC0008-008' or libid = 'NC0008-003' or libid = 'NC0008-004';

update fabric.lib_master4
set nextech = 2
where libid = 'KS0144-002' or libid = 'KS0011-002' or libid = 'KS0034-002' or libid = 'KS0136-002'
	or libid = 'KS0153-002' or libid = 'KS0141-002' or libid = 'KS0053-002' or libid = 'KS0145-002'
	or libid = 'KS0025-002' or libid = 'KS0015-002' or libid = 'KS0142-002' or libid = 'KS0029-002'
	or libid = 'KS0138-002' or libid = 'KS0150-002' or libid = 'KS0038-002' or libid = 'KS0012-002'
	or libid = 'KS0046-002' or libid = 'KS0042-002' or libid = 'KS0005-002' or libid = 'KS0049-002'
	or libid = 'KS0151-002' or libid = 'KS0040-002' or libid = 'KS0037-002' or libid = 'KS0002-002'
	or libid = 'KS0154-002' or libid = 'KS0004-002' or libid = 'KS0016-002' or fscskey = 'KS0150';
update fabric.lib_master4
set nextech = -2
where libid = 'KS0014-002' or libid = 'KS0006-002' or libid = 'KS0137-002' or libid = 'KS0321-002' 
	or libid = 'KS0047-002' or libid = 'KS0009-002' or libid = 'KS0152-002';
	
update fabric.lib_master4
set nemr = 2
where libid = 'MO0061-002' or libid = 'MO0066-002';

update fabric.lib_master4
set wilson = 2
where fscskey = 'KS0021' or fscskey = 'KS0031';

update fabric.lib_master4
set van_horne = 2
where fscskey = 'IA0365';

update fabric.lib_master4
set dumont = 2
where fscskey = 'IA0509' or fscskey = 'IA0344';

update fabric.lib_master4
set pioneer = 2
where libid = 'OR0119-005';

update fabric.lib_master4
set webster_calhoun = 2
where libid = 'IA0556-002' or libid = 'IA0290-002' or libid = 'IA0377-002' or libid = 'IA0263-002'
	or libid = 'IA0310-002' or libid = 'IA0313-002' or libid = 'IA0522-002' or libid = 'IA0185-002';

update fabric.lib_master4
set gervais_datavision = 2
where fscskey = 'OR0104' or fscskey = 'OR0083' or fscskey = 'OR0047' or fscskey = 'OR0036';

update fabric.lib_master4
set paul_bunyan = 2
where libid = 'MN0145-002' or libid = 'MN0145-003' or libid = 'MN0145-005';

-------------------------CORROBORATION SCORE------------------------------
--MAP SCORE
alter table fabric.lib_master4
	drop column if exists score_map;
alter table fabric.lib_master4
	add column score_map int;

with new_values as(
select libid, coalesce(cai,0) + coalesce(kansas,0) + coalesce(maine,0)
	+ coalesce(missouri,0) + coalesce(vermont,0) + coalesce(ohio,0)
	+ coalesce(alliance,0) + coalesce(clear_lake,0) + coalesce(com_net,0)
	+ coalesce(grantsburg,0) + coalesce(peoples_rural,0) + coalesce(peoples_telecom,0)
	+ coalesce(toledotel,0) + coalesce(us_connect,0) + coalesce(wabash,0) 
	+ coalesce(heart_iowa,0) + coalesce(dc,0) + coalesce(blue_ridge,0) + coalesce(dobson,0)
	+ coalesce(west_carolina_tel,0) + coalesce(manawa,0) + coalesce(srtc,0) + coalesce(premier,0)
	+ coalesce(fibercomm,0) + coalesce(h_and_b,0) + coalesce(golden_belt,0) + coalesce(united,0)
	+ coalesce(fontana,0) + coalesce(nextech,0) + coalesce(nemr,0) + coalesce(wilson,0)
	+ coalesce(premier,0) + coalesce(fibercomm,0) + coalesce(van_horne,0) + coalesce(dumont,0)
	+ coalesce(pioneer,0) + coalesce(webster_calhoun,0) + coalesce(gervais_datavision,0) + coalesce(paul_bunyan,0)
	as row_score
from fabric.lib_master4
)
update fabric.lib_master4
set score_map = new_values.row_score
from new_values
where lib_master4.libid = new_values.libid;

alter table fabric.lib_master4
	drop column if exists fiber_map;
alter table fabric.lib_master4
	add column fiber_map int;

update fabric.lib_master4
set fiber_map = 1
where score_map > 0;

update fabric.lib_master4
set fiber_map = 0
where score_map = 0;

update fabric.lib_master4
set fiber_map = -1
where score_map < 0;

select fiber_map, count(*)
from fabric.lib_master4
group by fiber_map
order by fiber_map;

select score_map, count(*)
from fabric.lib_master4
group by score_map
order by score_map;

select *
from fabric.lib_master4;

drop table if exists fabric.libmap;
create table fabric.libmap as(
select fscskey, system_name, libid, libname, c_out_ty AS lib_type, geom, visits, score_map, fiber_map
from fabric.lib_master4
);
copy(select * from fabric.libmap) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber.csv' with delimiter '|' CSV header;

alter table fabric.lib_master4
	drop column if exists fiber_v2,
	drop column if exists fiber_v1;
alter table fabric.lib_master4
	add column fiber_v2 int,
	add column fiber_v1 int;

with new_values as(
select libid, fiber_map
from fabric.lib_master3
)
update fabric.lib_master4
set fiber_v2 = new_values.fiber_map
from new_values
where lib_master4.libid = new_values.libid;

with new_values as(
select libid, fiber_map
from fabric.lib_master2
)
update fabric.lib_master4
set fiber_v1 = new_values.fiber_map
from new_values
where lib_master4.libid = new_values.libid;

drop table if exists fabric.libmap_fiber;
create table fabric.libmap_fiber as(
select fscskey, system_name, libid, libname, c_out_ty AS lib_type, geom, visits, fiber_map AS fiber_v3, fiber_v2, fiber_v1,
	score_map AS score, alliance, blue_ridge, clear_lake, com_net, cai, dc, dobson, fibercomm, fontana, gervais_datavision,
	golden_belt, grantsburg, h_and_b, heart_iowa, kansas, maine, manawa, missouri, nextech, nemr, ohio, paul_bunyan, peoples_rural,
	peoples_telecom, premier, srtc, toledotel, united, us_connect, van_horne, vermont, wabash, webster_calhoun, west_carolina_tel,
	wilson
from fabric.lib_master4
);

copy(select * from fabric.libmap_fiber) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber_publish.csv' with delimiter '|' CSV header;