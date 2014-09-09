drop table if exists fabric.lib_master5;

select *
into fabric.lib_master5
from analysis.imls_lib_2012;
----17586 records

delete from fabric.lib_master5
where c_out_ty = 'BM' or c_out_ty = 'BS';

--Update matching key
update fabric.lib_master5
set libid = fscskey || '-' || fscs_seq;

--Add number of visits
alter table fabric.lib_master5
add column visits int;

with new_values as(
select fscskey, visits
from analysis.imls_lib_stats
)
update fabric.lib_master5
set visits = new_values.visits
from new_values
where lib_master5.fscskey = new_values.fscskey;

--Add library system name
alter table fabric.lib_master5
add column system_name character varying(100);

with new_values as(
select fscskey, libname
from analysis.imls_lib_stats
)
update fabric.lib_master5
set system_name = new_values.libname
from new_values
where lib_master5.fscskey = new_values.fscskey;

--CAI
select *
from fabric.lib_master5, fabric.imls_cai
where lib_master5.libid = imls_cai.imlsid;


alter table fabric.lib_master5
add column cai int;

with new_values as(
select imlsid, fiber AS cai_fiber
from fabric.imls_cai
)
update fabric.lib_master5
set cai = new_values.cai_fiber
from new_values
where lib_master5.libid = new_values.imlsid;

alter table fabric.lib_master5
add column caiid character varying(10);

with new_values as(
select imlsid, caiid
from fabric.imls_cai
)
update fabric.lib_master5
set caiid = new_values.caiid
from new_values
where lib_master5.libid = new_values.imlsid;

select *
from fabric.lib_master5;

--KANSAS
select *
from fabric.lib_master5, fabric.ks_lib
where lib_master5.libname = upper(ks_lib.library_name)
	and stabr = 'KS';

alter table fabric.lib_master5
add column kansas int;

with new_values as(
select library_name, fiber AS ks_fiber
from fabric.ks_lib
)
update fabric.lib_master5
set kansas = new_values.ks_fiber
from new_values
where libname = upper(new_values.library_name)
	and stabr = 'KS';

--MAINE
alter table fabric.lib_master5
add column me_fscskey character varying(10);

update fabric.lib_master5
set me_fscskey = fscskey || fscs_seq
where stabr = 'ME';

select *
from fabric.lib_master5
where stabr = 'ME';

alter table fabric.lib_master5
add column maine int;

with new_values as(
select fscs_id, fiber AS me_fiber
from fabric.me_ind
where cai_type = 'LIB'
)
update fabric.lib_master5
set maine = new_values.me_fiber
from new_values
where lib_master5.me_fscskey = new_values.fscs_id;

--MISSOURI
select *
from fabric.lib_master5, fabric.mo_lib
where lib_master5.libname = upper(mo_lib.site_name)
	and stabr = 'MO';

alter table fabric.lib_master5
add column missouri int;

with new_values as(
select site_name, fiber as mo_fiber
from fabric.mo_lib
where loc_type = 'LIBRARY'
)
update fabric.lib_master5
set missouri = new_values.mo_fiber
from new_values
where lib_master5.libname = upper(new_values.site_name)
	and stabr = 'MO';

--VERMONT
select *
from fabric.lib_master5, fabric.vt_lib
where lib_master5.libid = vt_lib.library_id
	and stabr = 'VT';

alter table fabric.lib_master5
add column vermont int;

with new_values as(
select library_id, fiber as vt_fiber
from fabric.vt_lib
)
update fabric.lib_master5
set vermont = new_values.vt_fiber
from new_values
where lib_master5.libid = new_values.library_id
	and stabr = 'VT';

--OHIO
select *
from fabric.lib_master5, fabric.oh_lib
where lib_master5.fscskey = oh_lib.fscs
	and lib_master5.libname = oh_lib.library_name;

alter table fabric.lib_master5
add column ohio int;

with new_values as(
select fscs, library_name, fiber as oh_fiber
from fabric.oh_lib
)
update fabric.lib_master5
set ohio = new_values.oh_fiber
from new_values
where lib_master5.fscskey = new_values.fscs
	and lib_master5.libname = new_values.library_name;

--C SPIRE
alter table fabric.lib_master5
	drop column if exists c_spire;
alter table fabric.lib_master5
	add column c_spire int;

update fabric.lib_master5
set c_spire = 2
where fscskey = 'MS0025' or fscskey = 'MS0017';

--IOWA
alter table fabric.lib_master5
	drop column if exists iowa;
alter table fabric.lib_master5
	add column iowa int;

with new_values as(
select part_iii_site, fiber
from fabric.ia_ind
where nces_school_id IS NULL
)
update fabric.lib_master5
set iowa = new_values.fiber
from new_values
where libname = UPPER(part_iii_site)
	and fipsst = '19';

--EMAIL SUBMISSIONS
alter table fabric.lib_master5
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
	add column paul_bunyan int,
	add column stayton int,
	add column siskiyou int,
	add column cascade_com int,
	add column rt_comm int,
	add column dubois_telephone int,
	add column range_telephone int,
	add column westel int,
	add column einetwork int,
	add column sunflower int,
	add column carnegie int,
	add column dixie int,
	add column pearl_river int,
	add column jackson_george int,
	add column bolivar int,
	add column waynesboro_wayne int,
	add column marks_quitman int,
	add column corinth int,
	add column tombigbee int,
	add column yazoo int,
	add column madison int,
	add column mccormack int,
	add column endeavor int,
	add column northwest int,
	add column ayrshire int,
	add column ctc int,
	add column tallahatchie int,
	add column triangle int,
	add column mid_mississippi int,
	add column cunningham int,
	add column silver_star int,
	add column xit int;

update fabric.lib_master5
set grantsburg = 2
where fscskey = 'WI0120';

update fabric.lib_master5
set toledotel = 2
where libid = 'WA0069-027';

update fabric.lib_master5
set wabash = 2
where libid = 'OH0043-002' or libid = 'OH0043-005' or fscskey = 'OH0083' or fscskey = 'OH0055';

update fabric.lib_master5
set peoples_telecom = 2
where fscskey = 'KS0256';

update fabric.lib_master5
set peoples_rural = 2
where fscskey = 'KY0052' or fscskey = 'KY0090';

update fabric.lib_master5
set clear_lake = 2
where fscskey = 'IA0077' or fscskey = 'IA0084';

update fabric.lib_master5
set com_net = 2
where libid = 'OH0176-002';

update fabric.lib_master5
set alliance = 2
where fscskey = 'IA0108';

update fabric.lib_master5
set heart_iowa = 2
where fscskey = 'IA0200' or fscskey = 'IA0395' or fscskey = 'IA0506' or fscskey = 'IA0243';

update fabric.lib_master5
set dc = 2
where libid = 'DC0001-003' or libid = 'DC0001-005' or libid = 'DC0001-006' or libid = 'DC0001-007'
	or libid = 'DC0001-028' or libid = 'DC0001-004' or libid = 'DC0001-008' or libid = 'DC0001-009'
	or libid = 'DC0001-015' or libid = 'DC0001-010' or libid = 'DC0001-002' or libid = 'DC0001-011'
	or libid = 'DC0001-012' or libid = 'DC0001-030' or libid = 'DC0001-013' or libid = 'DC0001-025'
	or libid = 'DC0001-014' or libid = 'DC0001-016' or libid = 'DC0001-017' or libid = 'DC0001-018'
	or libid = 'DC0001-019' or libid = 'DC0001-021' or libid = 'DC0001-022' or libid = 'DC0001-020'
	or libid = 'DC0001-023';

update fabric.lib_master5
set us_connect = -2
where fscskey = 'CO0094'; 

update fabric.lib_master5
set blue_ridge = 2
where fscskey = 'VA0008';

update fabric.lib_master5
set dobson = 2
where libid = 'OK0070-010';

update fabric.lib_master5
set west_carolina_tel = 2
where libid = 'SC0004-009' or libid = 'SC8003-001' or libid = 'SC8003-002' 
	or libid = 'SC8003-003' or libid = 'SC0028-002';

update fabric.lib_master5
set manawa = 2
where fscskey = 'WI0177';

update fabric.lib_master5
set srtc = 2
where libid = 'TX0086-002' or libid = 'TX0192-002' or libid = 'TX0078-002';

update fabric.lib_master5
set premier = 2
where fscskey = 'IA0184' or fscskey = 'IA0126' or fscskey = 'IA0424' or fscskey = 'IA0530';

update fabric.lib_master5
set fibercomm = 2
where fscskey = 'IA0225';

update fabric.lib_master5
set h_and_b = 2
where fscskey = 'KS0147' or fscskey = 'KS0091' or fscskey = 'KS0079';

update fabric.lib_master5
set golden_belt = 2
where fscskey = 'KS0010' or fscskey = 'KS0041' or fscskey = 'KS0290' or fscskey = 'KS0007'
	or fscskey = 'KS0306' or fscskey = 'KS0019' or fscskey = 'KS0287' or fscskey = 'KS0195'
	or fscskey = 'KS0284';
update fabric.lib_master5
set golden_belt = -2
where fscskey = 'KS0036' or fscskey = 'KS0280' or fscskey = 'KS0170';

update fabric.lib_master5
set united = 2
where fscskey = 'KS0299' or fscskey = 'KS0292';

update fabric.lib_master5
set fontana = 2
where libid = 'NC0008-005' or libid = 'NC0008-002' or libid = 'NC0008-008' or libid = 'NC0008-003' or libid = 'NC0008-004';

update fabric.lib_master5
set nextech = 2
where libid = 'KS0144-002' or libid = 'KS0011-002' or libid = 'KS0034-002' or libid = 'KS0136-002'
	or libid = 'KS0153-002' or libid = 'KS0141-002' or libid = 'KS0053-002' or libid = 'KS0145-002'
	or libid = 'KS0025-002' or libid = 'KS0015-002' or libid = 'KS0142-002' or libid = 'KS0029-002'
	or libid = 'KS0138-002' or libid = 'KS0150-002' or libid = 'KS0038-002' or libid = 'KS0012-002'
	or libid = 'KS0046-002' or libid = 'KS0042-002' or libid = 'KS0005-002' or libid = 'KS0049-002'
	or libid = 'KS0151-002' or libid = 'KS0040-002' or libid = 'KS0037-002' or libid = 'KS0002-002'
	or libid = 'KS0154-002' or libid = 'KS0004-002' or libid = 'KS0016-002' or fscskey = 'KS0150';
update fabric.lib_master5
set nextech = -2
where libid = 'KS0014-002' or libid = 'KS0006-002' or libid = 'KS0137-002' or libid = 'KS0321-002' 
	or libid = 'KS0047-002' or libid = 'KS0009-002' or libid = 'KS0152-002';
	
update fabric.lib_master5
set nemr = 2
where libid = 'MO0061-002' or libid = 'MO0066-002';

update fabric.lib_master5
set wilson = 2
where fscskey = 'KS0021' or fscskey = 'KS0031';

update fabric.lib_master5
set van_horne = 2
where fscskey = 'IA0365';

update fabric.lib_master5
set dumont = 2
where fscskey = 'IA0509' or fscskey = 'IA0344';

update fabric.lib_master5
set pioneer = 2
where libid = 'OR0119-005';

update fabric.lib_master5
set webster_calhoun = 2
where libid = 'IA0556-002' or libid = 'IA0290-002' or libid = 'IA0377-002' or libid = 'IA0263-002'
	or libid = 'IA0310-002' or libid = 'IA0313-002' or libid = 'IA0522-002' or libid = 'IA0185-002';

update fabric.lib_master5
set gervais_datavision = 2
where fscskey = 'OR0104' or fscskey = 'OR0083' or fscskey = 'OR0047' or fscskey = 'OR0036';

update fabric.lib_master5
set paul_bunyan = 2
where libid = 'MN0145-002' or libid = 'MN0145-003' or libid = 'MN0145-005';

update fabric.lib_master5
set stayton = 2
where fscskey = 'OR0083' or fscskey = 'OR0036';

update fabric.lib_master5
set siskiyou = 2
where libid = 'CA0135-011' or libid = 'CA0135-009' or libid = 'CA0135-011' or libid = 'CA0135-018';

update fabric.lib_master5
set cascade_com = 2
where fscskey = 'IA0465';

update fabric.lib_master5
set rt_comm = -2
where libid = 'WY0013-002' or libid = 'WY0013-004' or libid = 'WY0016-003' or libid = 'WY0004-002'
	or libid = 'WY0004-003' or libid = 'WY0009-002' or libid = 'WY0023-003' or fscskey = 'WY0023';
update fabric.lib_master5
set rt_comm = 2
where fscskey = 'WY0015' or fscskey = 'WY0022';

update fabric.lib_master5
set dubois_telephone = -2
where libid = 'WY0011-009';
update fabric.lib_master5
set dubois_telephone = 2
where libid = 'WY0003-005';

update fabric.lib_master5
set range_telephone = -2
where libid = 'WY0007-002' or libid = 'WY0013-005';

update fabric.lib_master5
set westel = 2
where fscskey = 'IA0170' or fscskey = 'IA0418' or fscskey = 'IA0178' or fscskey = 'IA0419' or fscskey = 'IA0115';

update fabric.lib_master5
set einetwork = 2
where libid = 'PA0042-003' or fscskey = 'PA0051' or fscskey = 'PA0513' or libid = 'PA0050-003'
	or libid = 'PA0034-005' or libid = 'PA0034-003'; 

update fabric.lib_master5
set sunflower = 2
where libid = 'MS0044-004' or libid = 'MS0044-002' or libid = 'MS0044-003' or libid = 'MS0044-006';

update fabric.lib_master5
set carnegie = 2
where fscskey = 'MS0005';

update fabric.lib_master5
set dixie = 2
where libid = 'MS0009-002';
update fabric.lib_master5
set dixie = -2
where libid = 'MS0009-003' or libid = 'MS0009-004' or libid = 'MS0009-005' or libid = 'MS0009-006'
	or libid = 'MS0009-008' or libid = 'MS0009-009' or libid = 'MS0009-007';

update fabric.lib_master5
set pearl_river = 2
where libid = 'MS0039-002' or libid = 'MS0039-003';

update fabric.lib_master5
set jackson_george = 2
where libid = 'MS0020-003' or libid = 'MS0020-004' or libid = 'MS0020-005' or libid = 'MS0020-006' 
	or libid = 'MS0020-007' or libid = 'MS0020-002' or libid = 'MS0020-008' or libid = 'MS0020-009';

update fabric.lib_master5
set bolivar = -2
where libid = 'MS0003-002' or libid = 'MS0003-008' or libid = 'MS0003-004' or libid = 'MS0003-003'
	or libid = 'MS0003-005' or libid = 'MS0003-010' or libid = 'MS0003-006';

update fabric.lib_master5
set waynesboro_wayne = -2
where fscskey = 'MS8002';

update fabric.lib_master5
set marks_quitman = -2
where libid = 'MS0030-002';

update fabric.lib_master5
set corinth = 2
where libid = 'MS0035-002';

update fabric.lib_master5
set tombigbee = -2
where fscskey = 'MS0046';

update fabric.lib_master5
set yazoo = 2
where fscskey = 'MS0042';

update fabric.lib_master5
set madison = 2
where libid = 'MS0029-002' or libid = 'MS0029-004' or libid = 'MS0029-005'; 

update fabric.lib_master5
set mccormack = 2
where libid = 'MO0137-004';

update fabric.lib_master5
set endeavor = 2
where fscskey = 'IN0200' or libid = 'IN0212-005' or libid = 'IN0212-006';
update fabric.lib_master5
set endeavor = -2
where libid = 'IN0196-005';

update fabric.lib_master5
set northwest = -2
where fscskey = 'IA0258' or libid = 'IA0375-002' or libid = 'IA0173-002' or libid = 'IA1076-002' or libid = 'IA0122-002';

update fabric.lib_master5
set ayrshire = -2
where libid = 'IA0259-002';

update fabric.lib_master5
set ctc = 2
where libid = 'MN0145-004';

update fabric.lib_master5
set tallahatchie = 2
where libid = 'MS0045-002';
update fabric.lib_master5
set tallahatchie = -2
where libid = 'MS0045-005';

update fabric.lib_master5
set triangle = 2
where fscskey = 'MT0014' or fscskey = 'MT0036' or fscskey = 'MT0048' or libid = 'MT0030-006' or libid = 'MT0030-009' 
	or fscskey = 'MT0077';
update fabric.lib_master5
set triangle = -2
where fscskey = 'MT0013' or libid = 'MT0030-007' or fscskey = 'MT0065' or fscskey = 'MT0022' or fscskey = 'MT0052'
	or fscskey = 'MT0037' or fscskey = 'MT0005';

update fabric.lib_master5
set mid_mississippi = -2 
where libid = 'MS0033-002' or libid = 'MS0033-003' or libid = 'MS0033-004' or libid = 'MS0033-005' or libid = 'MS0033-006'
	or libid = 'MS0033-007' or libid = 'MS0033-008' or libid = 'MS0033-009' or libid = 'MS0033-010' or libid = 'MS0033-011'
	or libid = 'MS0033-012' or libid = 'MS0033-013' or libid = 'MS0033-014';
update fabric.lib_master5
set mid_mississippi = 2
where libid = 'MS0033-000';

update fabric.lib_master5
set cunningham = 2
where fscskey = 'KS0003' or fscskey = 'KS0001';

update fabric.lib_master5
set silver_star = 2
where libid = 'WY0017-008' or libid = 'WY0017-007' or fscskey = 'WY0020' or libid = 'WY0020-003';

update fabric.lib_master5
set xit = 2
where fscskey = 'TX0457' or fscskey = 'TX0390';
update fabric.lib_master5
set xit = -2
where fscskey = 'TX0295' or fscskey = 'TX0381';


-------------------------CORROBORATION SCORE------------------------------
--MAP SCORE
alter table fabric.lib_master5
	drop column if exists score_map;
alter table fabric.lib_master5
	add column score_map int;

with new_values as(
select libid, coalesce(alliance,0) + coalesce(ayrshire,0) + coalesce(blue_ridge,0) + coalesce(bolivar,0)
	 + coalesce(c_spire,0) + coalesce(cai,0) + coalesce(carnegie,0) + coalesce(cascade_com,0) + coalesce(clear_lake,0)
	 + coalesce(com_net,0) + coalesce(corinth,0) + coalesce (ctc,0) + coalesce(cunningham,0) + coalesce(dc,0) + coalesce(dixie,0) 
	 + coalesce(dobson,0)
	 + coalesce(dubois_telephone,0) + coalesce(dumont,0) + coalesce(einetwork,0) + coalesce(endeavor,0)
	 + coalesce(fibercomm,0) + coalesce(fontana,0) + coalesce(gervais_datavision,0) + coalesce(golden_belt,0)
	 + coalesce(grantsburg,0) + coalesce(h_and_b,0) + coalesce(heart_iowa,0) + coalesce(iowa,0)
	 + coalesce(jackson_george,0) + coalesce(kansas,0) + coalesce(madison,0)  + coalesce(maine,0) + coalesce(manawa,0) 
	 + coalesce(marks_quitman,0) + coalesce(mccormack,0) + coalesce(mid_mississippi,0) + coalesce(missouri,0) + coalesce(nemr,0) 
	 + coalesce(nextech,0)
	 + coalesce(northwest,0) + coalesce(ohio,0) + coalesce(paul_bunyan,0) + coalesce(pearl_river,0) + coalesce(peoples_rural,0)
	 + coalesce(peoples_telecom,0) + coalesce(pioneer,0) + coalesce(premier,0) + coalesce(range_telephone,0)
	 + coalesce(rt_comm,0) + coalesce(siskiyou,0) + coalesce(srtc,0) + coalesce(stayton,0) + coalesce(sunflower,0)
	 + coalesce(tallahatchie,0) + coalesce(toledotel,0) + coalesce(tombigbee,0) + coalesce(triangle,0)
	 + coalesce(united,0) + coalesce(us_connect,0) + coalesce(van_horne,0)
	 + coalesce(vermont,0) + coalesce(wabash,0) + coalesce(waynesboro_wayne,0) + coalesce(webster_calhoun,0)
	 + coalesce(west_carolina_tel,0) + coalesce(westel,0) + coalesce(wilson,0) + coalesce(xit,0) + coalesce(yazoo,0)
	as row_score
from fabric.lib_master5
)
update fabric.lib_master5
set score_map = new_values.row_score
from new_values
where lib_master5.libid = new_values.libid;

alter table fabric.lib_master5
	drop column if exists fiber_map;
alter table fabric.lib_master5
	add column fiber_map int;

update fabric.lib_master5
set fiber_map = 1
where score_map > 0;

update fabric.lib_master5
set fiber_map = 0
where score_map = 0;

update fabric.lib_master5
set fiber_map = -1
where score_map < 0;

select fiber_map, count(*)
from fabric.lib_master5
group by fiber_map
order by fiber_map;

select score_map, count(*)
from fabric.lib_master5
group by score_map
order by score_map;

select *
from fabric.lib_master5;

drop table if exists fabric.libmap;
create table fabric.libmap as(
select fscskey, system_name, libid, libname, c_out_ty AS lib_type, geom, visits, score_map, fiber_map
from fabric.lib_master5
);
copy(select * from fabric.libmap) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber.csv' with delimiter '|' CSV header;

alter table fabric.lib_master5
	drop column if exists fiber_v2,
	drop column if exists fiber_v1;
alter table fabric.lib_master5
	add column fiber_v2 int,
	add column fiber_v1 int;

with new_values as(
select libid, fiber_map
from fabric.lib_master3
)
update fabric.lib_master5
set fiber_v2 = new_values.fiber_map
from new_values
where lib_master5.libid = new_values.libid;

with new_values as(
select libid, fiber_map
from fabric.lib_master2
)
update fabric.lib_master5
set fiber_v1 = new_values.fiber_map
from new_values
where lib_master5.libid = new_values.libid;

drop table if exists fabric.libmap_fiber;
create table fabric.libmap_fiber as(
select fscskey, system_name, libid, libname, c_out_ty AS lib_type, geom, visits, fiber_map AS fiber_v3, fiber_v2, fiber_v1,
	score_map AS score, alliance, blue_ridge, clear_lake, com_net, cai, dc, dobson, fibercomm, fontana, gervais_datavision,
	golden_belt, grantsburg, h_and_b, heart_iowa, kansas, maine, manawa, missouri, nextech, nemr, ohio, paul_bunyan, peoples_rural,
	peoples_telecom, premier, srtc, toledotel, united, us_connect, van_horne, vermont, wabash, webster_calhoun, west_carolina_tel,
	wilson
from fabric.lib_master5
);

copy(select * from fabric.libmap_fiber) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber_publish.csv' with delimiter '|' CSV header;