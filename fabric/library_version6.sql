drop table if exists fabric.lib_master7;

select *
into fabric.lib_master7
from analysis.imls_lib_2012;
----17586 records

delete from fabric.lib_master7
where c_out_ty = 'BM' or c_out_ty = 'BS';

--Update matching key
update fabric.lib_master7
set libid = fscskey || '-' || fscs_seq;

--Add number of visits
alter table fabric.lib_master7
add column visits int;

with new_values as(
select fscskey, visits
from analysis.imls_lib_stats
)
update fabric.lib_master7
set visits = new_values.visits
from new_values
where lib_master7.fscskey = new_values.fscskey;

--Add library system name
alter table fabric.lib_master7
add column system_name character varying(100);

with new_values as(
select fscskey, libname
from analysis.imls_lib_stats
)
update fabric.lib_master7
set system_name = new_values.libname
from new_values
where lib_master7.fscskey = new_values.fscskey;

--CAI
select *
from fabric.lib_master7, fabric.imls_cai
where lib_master7.libid = imls_cai.imlsid;


alter table fabric.lib_master7
add column cai int;

with new_values as(
select imlsid, fiber AS cai_fiber
from fabric.imls_cai
)
update fabric.lib_master7
set cai = new_values.cai_fiber
from new_values
where lib_master7.libid = new_values.imlsid;

alter table fabric.lib_master7
add column caiid character varying(10);

with new_values as(
select imlsid, caiid
from fabric.imls_cai
)
update fabric.lib_master7
set caiid = new_values.caiid
from new_values
where lib_master7.libid = new_values.imlsid;

select *
from fabric.lib_master7;

--KANSAS
select *
from fabric.lib_master7, fabric.ks_lib
where lib_master7.libname = upper(ks_lib.library_name)
	and stabr = 'KS';

alter table fabric.lib_master7
add column kansas int;

with new_values as(
select library_name, fiber AS ks_fiber
from fabric.ks_lib
)
update fabric.lib_master7
set kansas = new_values.ks_fiber
from new_values
where libname = upper(new_values.library_name)
	and stabr = 'KS';

--MAINE
alter table fabric.lib_master7
add column me_fscskey character varying(10);

update fabric.lib_master7
set me_fscskey = fscskey || fscs_seq
where stabr = 'ME';

select *
from fabric.lib_master7
where stabr = 'ME';

alter table fabric.lib_master7
add column maine int;

with new_values as(
select fscs_id, fiber AS me_fiber
from fabric.me_ind
where cai_type = 'LIB'
)
update fabric.lib_master7
set maine = new_values.me_fiber
from new_values
where lib_master7.me_fscskey = new_values.fscs_id;

--MISSOURI
select *
from fabric.lib_master7, fabric.mo_lib
where lib_master7.libname = upper(mo_lib.site_name)
	and stabr = 'MO';

alter table fabric.lib_master7
add column missouri int;

with new_values as(
select site_name, fiber as mo_fiber
from fabric.mo_lib
where loc_type = 'LIBRARY'
)
update fabric.lib_master7
set missouri = new_values.mo_fiber
from new_values
where lib_master7.libname = upper(new_values.site_name)
	and stabr = 'MO';

--VERMONT
select *
from fabric.lib_master7, fabric.vt_lib
where lib_master7.libid = vt_lib.library_id
	and stabr = 'VT';

alter table fabric.lib_master7
add column vermont int;

with new_values as(
select library_id, fiber as vt_fiber
from fabric.vt_lib
)
update fabric.lib_master7
set vermont = new_values.vt_fiber
from new_values
where lib_master7.libid = new_values.library_id
	and stabr = 'VT';

--OHIO
select *
from fabric.lib_master7, fabric.oh_lib
where lib_master7.fscskey = oh_lib.fscs
	and lib_master7.libname = oh_lib.library_name;

alter table fabric.lib_master7
add column ohio int;

with new_values as(
select fscs, library_name, fiber as oh_fiber
from fabric.oh_lib
)
update fabric.lib_master7
set ohio = new_values.oh_fiber
from new_values
where lib_master7.fscskey = new_values.fscs
	and lib_master7.libname = new_values.library_name;

--C SPIRE
alter table fabric.lib_master7
	drop column if exists c_spire;
alter table fabric.lib_master7
	add column c_spire int;

update fabric.lib_master7
set c_spire = 9
where fscskey = 'MS0025' or fscskey = 'MS0017';

--IOWA
alter table fabric.lib_master7
	drop column if exists iowa;
alter table fabric.lib_master7
	add column iowa int;

with new_values as(
select part_iii_site, fiber
from fabric.ia_ind
where nces_school_id IS NULL
)
update fabric.lib_master7
set iowa = new_values.fiber
from new_values
where libname = UPPER(part_iii_site)
	and fipsst = '19';

--SOUTH CAROLINA
alter table fabric.lib_master7
	drop column if exists south_carolina;
alter table fabric.lib_master7
	add column south_carolina int;

with new_values as(
select fscs_id, fiber
from fabric.sc_lib
)
update fabric.lib_master7
set south_carolina = new_values.fiber
from new_values
where libid = fscs_id;

--NEW YORK
alter table fabric.lib_master7
drop column if exists new_york;
alter table fabric.lib_master7
add column new_york int;

with new_values as(
select fscs, fiber
from fabric.ny_lib
)
update fabric.lib_master7
set new_york = new_values.fiber
from new_values
where fscskey = fscs;

--EMAIL SUBMISSIONS
alter table fabric.lib_master7
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
	add column xit int,
	add column smrl int,
	add column harrison int,
	add column wilkinson int,
	add column lamar int,
	add column kemper_newton int,
	add column pike int,
	add column columbus_lowndes int;

update fabric.lib_master7
set grantsburg = 9
where fscskey = 'WI0120';

update fabric.lib_master7
set toledotel = 9
where libid = 'WA0069-027';

update fabric.lib_master7
set wabash = 9
where libid = 'OH0043-002' or libid = 'OH0043-005' or fscskey = 'OH0083' or fscskey = 'OH0055';

update fabric.lib_master7
set peoples_telecom = 9
where fscskey = 'KS0256';

update fabric.lib_master7
set peoples_rural = 9
where fscskey = 'KY0052' or fscskey = 'KY0090';

update fabric.lib_master7
set clear_lake = 9
where fscskey = 'IA0077' or fscskey = 'IA0084';

update fabric.lib_master7
set com_net = 9
where libid = 'OH0176-002';

update fabric.lib_master7
set alliance = 9
where fscskey = 'IA0108';

update fabric.lib_master7
set heart_iowa = 9
where fscskey = 'IA0200' or fscskey = 'IA0395' or fscskey = 'IA0506' or fscskey = 'IA0243';

update fabric.lib_master7
set dc = 9
where libid = 'DC0001-003' or libid = 'DC0001-005' or libid = 'DC0001-006' or libid = 'DC0001-007'
	or libid = 'DC0001-028' or libid = 'DC0001-004' or libid = 'DC0001-008' or libid = 'DC0001-009'
	or libid = 'DC0001-015' or libid = 'DC0001-010' or libid = 'DC0001-002' or libid = 'DC0001-011'
	or libid = 'DC0001-012' or libid = 'DC0001-030' or libid = 'DC0001-013' or libid = 'DC0001-025'
	or libid = 'DC0001-014' or libid = 'DC0001-016' or libid = 'DC0001-017' or libid = 'DC0001-018'
	or libid = 'DC0001-019' or libid = 'DC0001-021' or libid = 'DC0001-022' or libid = 'DC0001-020'
	or libid = 'DC0001-023';

update fabric.lib_master7
set us_connect = -9
where fscskey = 'CO0094'; 

update fabric.lib_master7
set blue_ridge = 9
where fscskey = 'VA0008';

update fabric.lib_master7
set dobson = 9
where libid = 'OK0070-010';

update fabric.lib_master7
set west_carolina_tel = 9
where libid = 'SC0004-009' or libid = 'SC8003-001' or libid = 'SC8003-002' 
	or libid = 'SC8003-003' or libid = 'SC0028-002';

update fabric.lib_master7
set manawa = 9
where fscskey = 'WI0177';

update fabric.lib_master7
set srtc = 9
where libid = 'TX0086-002' or libid = 'TX0192-002' or libid = 'TX0078-002';

update fabric.lib_master7
set premier = 9
where fscskey = 'IA0184' or fscskey = 'IA0126' or fscskey = 'IA0424' or fscskey = 'IA0530';

update fabric.lib_master7
set fibercomm = 9
where fscskey = 'IA0225';

update fabric.lib_master7
set h_and_b = 9
where fscskey = 'KS0147' or fscskey = 'KS0091' or fscskey = 'KS0079';

update fabric.lib_master7
set golden_belt = 9
where fscskey = 'KS0010' or fscskey = 'KS0041' or fscskey = 'KS0290' or fscskey = 'KS0007'
	or fscskey = 'KS0306' or fscskey = 'KS0019' or fscskey = 'KS0287' or fscskey = 'KS0195'
	or fscskey = 'KS0284';
update fabric.lib_master7
set golden_belt = -9
where fscskey = 'KS0036' or fscskey = 'KS0280' or fscskey = 'KS0170';

update fabric.lib_master7
set united = 9
where fscskey = 'KS0299' or fscskey = 'KS0292';

update fabric.lib_master7
set fontana = 9
where libid = 'NC0008-005' or libid = 'NC0008-002' or libid = 'NC0008-008' or libid = 'NC0008-003' or libid = 'NC0008-004';

update fabric.lib_master7
set nextech = 9
where libid = 'KS0144-002' or libid = 'KS0011-002' or libid = 'KS0034-002' or libid = 'KS0136-002'
	or libid = 'KS0153-002' or libid = 'KS0141-002' or libid = 'KS0053-002' or libid = 'KS0145-002'
	or libid = 'KS0025-002' or libid = 'KS0015-002' or libid = 'KS0142-002' or libid = 'KS0029-002'
	or libid = 'KS0138-002' or libid = 'KS0150-002' or libid = 'KS0038-002' or libid = 'KS0012-002'
	or libid = 'KS0046-002' or libid = 'KS0042-002' or libid = 'KS0005-002' or libid = 'KS0049-002'
	or libid = 'KS0151-002' or libid = 'KS0040-002' or libid = 'KS0037-002' or libid = 'KS0002-002'
	or libid = 'KS0154-002' or libid = 'KS0004-002' or libid = 'KS0016-002' or fscskey = 'KS0150';
update fabric.lib_master7
set nextech = -9
where libid = 'KS0014-002' or libid = 'KS0006-002' or libid = 'KS0137-002' or libid = 'KS0321-002' 
	or libid = 'KS0047-002' or libid = 'KS0009-002' or libid = 'KS0152-002';
	
update fabric.lib_master7
set nemr = 9
where libid = 'MO0061-002' or libid = 'MO0066-002';

update fabric.lib_master7
set wilson = 9
where fscskey = 'KS0021' or fscskey = 'KS0031';

update fabric.lib_master7
set van_horne = 9
where fscskey = 'IA0365';

update fabric.lib_master7
set dumont = 9
where fscskey = 'IA0509' or fscskey = 'IA0344';

update fabric.lib_master7
set pioneer = 9
where libid = 'OR0119-005';

update fabric.lib_master7
set webster_calhoun = 9
where libid = 'IA0556-002' or libid = 'IA0290-002' or libid = 'IA0377-002' or libid = 'IA0263-002'
	or libid = 'IA0310-002' or libid = 'IA0313-002' or libid = 'IA0522-002' or libid = 'IA0185-002';

update fabric.lib_master7
set gervais_datavision = 9
where fscskey = 'OR0104' or fscskey = 'OR0083' or fscskey = 'OR0047' or fscskey = 'OR0036';

update fabric.lib_master7
set paul_bunyan = 9
where libid = 'MN0145-002' or libid = 'MN0145-003' or libid = 'MN0145-005';

update fabric.lib_master7
set stayton = 9
where fscskey = 'OR0083' or fscskey = 'OR0036';

update fabric.lib_master7
set siskiyou = 9
where libid = 'CA0135-011' or libid = 'CA0135-009' or libid = 'CA0135-011' or libid = 'CA0135-018';

update fabric.lib_master7
set cascade_com = 9
where fscskey = 'IA0465';

update fabric.lib_master7
set rt_comm = -9
where libid = 'WY0013-002' or libid = 'WY0013-004' or libid = 'WY0016-003' or libid = 'WY0004-002'
	or libid = 'WY0004-003' or libid = 'WY0009-002' or libid = 'WY0023-003' or fscskey = 'WY0023';
update fabric.lib_master7
set rt_comm = 9
where fscskey = 'WY0015' or fscskey = 'WY0022';

update fabric.lib_master7
set dubois_telephone = -9
where libid = 'WY0011-009';
update fabric.lib_master7
set dubois_telephone = 9
where libid = 'WY0003-005';

update fabric.lib_master7
set range_telephone = -9
where libid = 'WY0007-002' or libid = 'WY0013-005';

update fabric.lib_master7
set westel = 9
where fscskey = 'IA0170' or fscskey = 'IA0418' or fscskey = 'IA0178' or fscskey = 'IA0419' or fscskey = 'IA0115';

update fabric.lib_master7
set einetwork = 9
where libid = 'PA0042-003' or fscskey = 'PA0051' or fscskey = 'PA0513' or libid = 'PA0050-003'
	or libid = 'PA0034-005' or libid = 'PA0034-003'; 

update fabric.lib_master7
set sunflower = 9
where libid = 'MS0044-004' or libid = 'MS0044-002' or libid = 'MS0044-003' or libid = 'MS0044-006';

update fabric.lib_master7
set carnegie = 9
where fscskey = 'MS0005';

update fabric.lib_master7
set dixie = 9
where libid = 'MS0009-002';
update fabric.lib_master7
set dixie = -9
where libid = 'MS0009-003' or libid = 'MS0009-004' or libid = 'MS0009-005' or libid = 'MS0009-006'
	or libid = 'MS0009-008' or libid = 'MS0009-009' or libid = 'MS0009-007';

update fabric.lib_master7
set pearl_river = -9
where libid = 'MS0039-002' or libid = 'MS0039-003';

update fabric.lib_master7
set jackson_george = 9
where libid = 'MS0020-003' or libid = 'MS0020-004' or libid = 'MS0020-005' or libid = 'MS0020-006' 
	or libid = 'MS0020-007' or libid = 'MS0020-002' or libid = 'MS0020-008' or libid = 'MS0020-009';

update fabric.lib_master7
set bolivar = -9
where libid = 'MS0003-002' or libid = 'MS0003-008' or libid = 'MS0003-004' or libid = 'MS0003-003'
	or libid = 'MS0003-005' or libid = 'MS0003-010' or libid = 'MS0003-006';

update fabric.lib_master7
set waynesboro_wayne = -9
where fscskey = 'MS8002';

update fabric.lib_master7
set marks_quitman = -9
where libid = 'MS0030-002';

update fabric.lib_master7
set corinth = 9
where libid = 'MS0035-002';

update fabric.lib_master7
set tombigbee = -9
where fscskey = 'MS0046';

update fabric.lib_master7
set yazoo = 9
where fscskey = 'MS0042';

update fabric.lib_master7
set madison = 9
where libid = 'MS0029-002' or libid = 'MS0029-004' or libid = 'MS0029-005'; 

update fabric.lib_master7
set mccormack = 9
where libid = 'MO0137-004';

update fabric.lib_master7
set endeavor = 9
where fscskey = 'IN0200' or libid = 'IN0212-005' or libid = 'IN0212-006';
update fabric.lib_master7
set endeavor = -9
where libid = 'IN0196-005';

update fabric.lib_master7
set northwest = -9
where fscskey = 'IA0258' or libid = 'IA0375-002' or libid = 'IA0173-002' or libid = 'IA1076-002' or libid = 'IA0122-002';

update fabric.lib_master7
set ayrshire = -9
where libid = 'IA0259-002';

update fabric.lib_master7
set ctc = 9
where libid = 'MN0145-004';

update fabric.lib_master7
set tallahatchie = 9
where libid = 'MS0045-002';
update fabric.lib_master7
set tallahatchie = -9
where libid = 'MS0045-005';

update fabric.lib_master7
set triangle = 9
where fscskey = 'MT0014' or fscskey = 'MT0036' or fscskey = 'MT0048' or libid = 'MT0030-006' or libid = 'MT0030-009' 
	or fscskey = 'MT0077';
update fabric.lib_master7
set triangle = -9
where fscskey = 'MT0013' or libid = 'MT0030-007' or fscskey = 'MT0065' or fscskey = 'MT0022' or fscskey = 'MT0052'
	or fscskey = 'MT0037' or fscskey = 'MT0005';

update fabric.lib_master7
set mid_mississippi = -9
where libid = 'MS0033-002' or libid = 'MS0033-003' or libid = 'MS0033-004' or libid = 'MS0033-005' or libid = 'MS0033-006'
	or libid = 'MS0033-007' or libid = 'MS0033-008' or libid = 'MS0033-009' or libid = 'MS0033-010' or libid = 'MS0033-011'
	or libid = 'MS0033-012' or libid = 'MS0033-013' or libid = 'MS0033-014';
update fabric.lib_master7
set mid_mississippi = 9
where libid = 'MS0033-000';

update fabric.lib_master7
set cunningham = 9
where fscskey = 'KS0003' or fscskey = 'KS0001';

update fabric.lib_master7
set silver_star = 9
where libid = 'WY0017-008' or libid = 'WY0017-007' or fscskey = 'WY0020' or libid = 'WY0020-003';

update fabric.lib_master7
set xit = 9
where fscskey = 'TX0457' or fscskey = 'TX0390';
update fabric.lib_master7
set xit = -9
where fscskey = 'TX0295' or fscskey = 'TX0381';

update fabric.lib_master7
set smrl = 9
where libid = 'MS0043-002';
update fabric.lib_master7
set smrl = -9
where libid = 'MS0043-003' or libid = 'MS0043-004';

update fabric.lib_master7
set harrison = 9
where libid = 'MS0016-013' or libid = 'MS0016-010' or libid = 'MS0016-004' or libid = 'MS0016-008' 
	or libid = 'MS0016-006' or libid = 'MS0016-007' or libid = 'MS0016-012' or libid = 'MS0016-009'
	or libid = 'MS0016-014';

update fabric.lib_master7
set wilkinson = -9
where libid = 'MS 0052-001' or libid = 'MS 0052-002';

update fabric.lib_master7
set lamar = 9
where libid = 'MS8001-003' or libid = 'MS8001-002' or libid = 'MS8001-001' or libid = 'MS8001-004';

update fabric.lib_master7
set kemper_newton = -9
where libid = 'MS0023-002' or libid = 'MS0023-004' or libid = 'MS0023-006' or libid = 'MS0023-004';

update fabric.lib_master7
set pike = 9
where libid = 'MS0040-003' or libid = 'MS0040-005' or libid = 'MS0040-006' or libid = 'MS0040-007'
	or libid = 'MS0040-002' or libid = 'MS0040-008' or libid = 'MS0040-009' or libid = 'MS0040-010';

update fabric.lib_master7
set columbus_lowndes = -9
where libid = 'MS0028-003' or libid = 'MS0028-004' or libid = 'MS0028-005';
update fabric.lib_master7
set columbus_lowndes = 9
where libid = 'MS0028-002';

alter table fabric.lib_master7
add column bucks int,
add column fidelity int,
add column sierra int,
add column meridian_lauderdale int,
add column central_mississippi int,
add column copiah_jefferson int,
add column harriette int,
add column scmtc int,
add column covington int,
add column yalobusha int,
add column armstrong int,
add column lee_itawamba int,
add column panora int,
add column blackfoot int,
add column logan int,
add column first_regional int,
add column west_liberty int,
add column western_iowa int,
add column twin_valley int,
add column mtc int,
add column comm1_net int,
add column jefferson int,
add column cross_tel int,
add column union_tel int,
add column winthrop int,
add column lemonweir_valley int,
add column la_valle int,
add column richland_grant int,
add column spring_grove_comm int,
add column park_region int,
add column panhandle int;

update fabric.lib_master7
set bucks = 9
where libid = 'PA0309-006' or libid = 'PA0309-004' or libid = 'PA0309-003'
	or libid = 'PA0309-008' or libid = 'PA0309-005' or libid = 'PA0309-009';
update fabric.lib_master7
set bucks = -9
where fscskey = 'PA0312' or fscskey = 'PA0317';

update fabric.lib_master7
set fidelity = 9
where fscskey = 'MO0188';

update fabric.lib_master7
set sierra = 9
where fscskey = 'CA0192' or fscskey = 'CA0064';

update fabric.lib_master7
set meridian_lauderdale = 9
where libid = 'MS0032-002';

update fabric.lib_master7
set central_mississippi = 9
where libid in ('MS0006-002','MS0006-022','MS0006-003','MS0006-011','MS0006-008');

update fabric.lib_master7
set copiah_jefferson = -9
where libid in ('MS0008-006','MS0008-002');

update fabric.lib_master7
set harriette = 9
where libid = 'MS0015-002';

update fabric.lib_master7
set scmtc = 9
where libid = 'IA0189-002';

update fabric.lib_master7
set covington = -9
where libid in ('MS0051-002','MS0051-003','MS0051-001');

update fabric.lib_master7
set yalobusha = 9
where libid = 'MS0002-003';
update fabric.lib_master7
set yalobusha = -9
where libid = 'MS0002-002';

update fabric.lib_master7
set armstrong = 9
where libid = 'MS0018-002';

update fabric.lib_master7
set lee_itawamba = 9
where libid = 'MS0025-002';
update fabric.lib_master7
set lee_itawamba = -9
where libid = 'MS0025-003';

update fabric.lib_master7
set panora = 9
where libid in ('IA0320-002','IA0317-002');

update fabric.lib_master7
set blackfoot = 9
where libid = 'MT0060-002';

update fabric.lib_master7
set logan = 9
where libid = 'KY0067-005';

update fabric.lib_master7
set first_regional = 9
where fscskey = 'MS0013';

update fabric.lib_master7
set west_liberty = 9
where libid in ('IA0462-002','IA0072-002');

update fabric.lib_master7
set western_iowa = 9
where fscskey in ('IA0545','IA0532','IA0325');

update fabric.lib_master7
set twin_valley = 9
where fscskey in ('KS0052','KS0067','KS0107','KS0177','KS0088','KS0266','KS0266','KS0342','KS0342','KS0305','KS0305');

update fabric.lib_master7
set mtc = 9
where libid = 'IA0220-002';

update fabric.lib_master7
set comm1_net = 9
where fscskey in ('IA0094','IA0096','IA0097','IA0093','IA0095');

update fabric.lib_master7
set jefferson = 9
where fscskey = 'IA0304';

update fabric.lib_master7
set cross_tel = 9
where libid in ('OK0066-003','OK0062-013');

update fabric.lib_master7
set union_tel = 9
where libid = 'WI0309-002' or fscskey in ('WI0379','WI0128','WI0254');

update fabric.lib_master7
set winthrop = 9
where libid = 'MN9030-005';

update fabric.lib_master7
set lemonweir_valley = 9
where fscskey = 'WI0221';

update fabric.lib_master7
set la_valle = 9
where fscskey = 'WI0168';

update fabric.lib_master7
set richland_grant = 9
where fscskey in ('WI0111','WI0299');

update fabric.lib_master7
set spring_grove_comm = 9
where fscskey = 'MN9035';

update fabric.lib_master7
set park_region = 9
where fscskey in ('MN0113','MN0109','MN0111');

update fabric.lib_master7
set panhandle = 9
where libid in ('OK0013-002','OK0042-002','OK0010-002');
update fabric.lib_master7
set panhandle = -9
where libid in ('OK0049-002','OK0119-001','TX0290-002','TX0219-002','TX0378-002');


-------------------------CORROBORATION SCORE------------------------------
--MAP SCORE
alter table fabric.lib_master7
	drop column if exists score_map;
alter table fabric.lib_master7
	add column score_map int;

with new_values as(
select libid, coalesce(alliance,0) + coalesce(armstrong,0) + coalesce(ayrshire,0) + coalesce(blackfoot,0) + coalesce(blue_ridge,0) 
	+ coalesce(bolivar,0) + coalesce(bucks,0)
	 + coalesce(c_spire,0) + coalesce(cai,0) + coalesce(carnegie,0) + coalesce(cascade_com,0) + coalesce(central_mississippi,0)
	 + coalesce(clear_lake,0) + coalesce(columbus_lowndes,0) + coalesce(com_net,0) + coalesce(comm1_net,0) + coalesce(copiah_jefferson,0)
	 + coalesce(corinth,0)  + coalesce(covington,0) + coalesce(cross_tel,0) + coalesce (ctc,0) + coalesce(cunningham,0) 
	 + coalesce(dc,0) + coalesce(dixie,0) + coalesce(dobson,0)
	 + coalesce(dubois_telephone,0) + coalesce(dumont,0) + coalesce(einetwork,0) + coalesce(endeavor,0)
	 + coalesce(fibercomm,0) + coalesce(fidelity,0) + coalesce(first_regional,0) + coalesce(fontana,0) 
	 + coalesce(gervais_datavision,0) + coalesce(golden_belt,0)
	 + coalesce(grantsburg,0) + coalesce(h_and_b,0) + coalesce(harriette,0) + coalesce(harrison,0) + coalesce(heart_iowa,0) 
	 + coalesce(iowa,0) + coalesce(jackson_george,0) + coalesce(jefferson,0)
	 + coalesce(kansas,0) + coalesce(kemper_newton,0) + coalesce(la_valle,0) + coalesce(lamar,0) + coalesce(lee_itawamba,0) 
	 + coalesce(lemonweir_valley,0) + coalesce(logan,0) + coalesce(madison,0)  
	 + coalesce(maine,0) + coalesce(manawa,0) 
	 + coalesce(marks_quitman,0) + coalesce(mccormack,0) + coalesce(meridian_lauderdale,0) + coalesce(mid_mississippi,0) 
	 + coalesce(missouri,0) + coalesce(mtc,0) + coalesce(nemr,0) + coalesce(nextech,0)
	 + coalesce(northwest,0) + coalesce(ohio,0) + coalesce(panora,0) + coalesce(paul_bunyan,0) + coalesce(pearl_river,0) 
	 + coalesce(peoples_rural,0) + coalesce(peoples_telecom,0) + coalesce(pike,0) + coalesce(pioneer,0) + coalesce(premier,0) 
	 + coalesce(range_telephone,0) + coalesce(richland_grant,0)
	 + coalesce(rt_comm,0) + coalesce(scmtc,0) + coalesce(siskiyou,0) + coalesce(smrl,0) + coalesce(srtc,0) + coalesce(stayton,0) 
	 + coalesce(sunflower,0)
	 + coalesce(tallahatchie,0) + coalesce(toledotel,0) + coalesce(tombigbee,0) + coalesce(triangle,0) + coalesce(twin_valley,0)
	 + coalesce(union_tel,0) + coalesce(united,0) + coalesce(us_connect,0) + coalesce(van_horne,0)
	 + coalesce(vermont,0) + coalesce(wabash,0) + coalesce(waynesboro_wayne,0) + coalesce(webster_calhoun,0)
	 + coalesce(west_carolina_tel,0) + coalesce(west_liberty,0) + coalesce(westel,0) + coalesce(western_iowa,0) 
	 + coalesce(wilkinson,0) + coalesce(wilson,0) + coalesce(winthrop,0) + coalesce(xit,0) 
	 + coalesce(yalobusha,0) + coalesce(yazoo,0)
	as row_score
from fabric.lib_master7
)
update fabric.lib_master7
set score_map = new_values.row_score
from new_values
where lib_master7.libid = new_values.libid;

alter table fabric.lib_master7
	drop column if exists fiber_map;
alter table fabric.lib_master7
	add column fiber_map int;

update fabric.lib_master7
set fiber_map = 1
where score_map > 0;

update fabric.lib_master7
set fiber_map = 0
where score_map = 0;

update fabric.lib_master7
set fiber_map = -1
where score_map < 0;

select fiber_map, count(*)
from fabric.lib_master7
group by fiber_map
order by fiber_map;

select score_map, count(*)
from fabric.lib_master7
group by score_map
order by score_map;

select *
from fabric.lib_master7;

drop table if exists fabric.libmap;
create table fabric.libmap as(
select fscskey, system_name, libid, libname, c_out_ty AS lib_type, geom, visits, score_map, fiber_map
from fabric.lib_master7
order by score_map
);
copy(select * from fabric.libmap) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber.csv' with delimiter '|' CSV header;

alter table fabric.lib_master7
	drop column if exists fiber_v4,
	drop column if exists fiber_v3,
	drop column if exists fiber_v2,
	drop column if exists fiber_v1;
alter table fabric.lib_master7
	add column fiber_v4 int,
	add column fiber_v3 int,
	add column fiber_v2 int,
	add column fiber_v1 int;

with new_values as(
select libid, fiber_map
from fabric.lib_master5
)
update fabric.lib_master7
set fiber_v4 = new_values.fiber_map
from new_values
where lib_master7.libid = new_values.libid;

with new_values as(
select libid, fiber_map
from fabric.lib_master4
)
update fabric.lib_master7
set fiber_v3 = new_values.fiber_map
from new_values
where lib_master7.libid = new_values.libid;

with new_values as(
select libid, fiber_map
from fabric.lib_master3
)
update fabric.lib_master7
set fiber_v2 = new_values.fiber_map
from new_values
where lib_master7.libid = new_values.libid;

with new_values as(
select libid, fiber_map
from fabric.lib_master2
)
update fabric.lib_master7
set fiber_v1 = new_values.fiber_map
from new_values
where lib_master7.libid = new_values.libid;

drop table if exists fabric.libmap_fiber;
create table fabric.libmap_fiber as(
select fscskey AS fscs_key, system_name, libid AS library_id, libname AS library_name, c_out_ty AS library_type, geom, visits, 
	fiber_map AS fiber_v5, fiber_v4, fiber_v3, fiber_v2, fiber_v1, score_map AS score, 
	alliance, armstrong, ayrshire, blackfoot, blue_ridge, bolivar, bucks, c_spire, cai, carnegie, cascade_com, central_mississippi, 
	clear_lake, columbus_lowndes, com_net, comm1_net, copiah_jefferson, corinth, covington, cross_tel, ctc, cunningham, dc, dixie, 
	dobson, dubois_telephone, dumont, einetwork, endeavor, fibercomm, fidelity, first_regional, fontana,
	gervais_datavision, golden_belt, grantsburg, h_and_b, harriette, harrison, heart_iowa, iowa, jackson_george, jefferson, kansas, 
	kemper_newton, la_valle, lamar, lee_itawamba, lemonweir_valley, logan,
	madison, maine, manawa, marks_quitman, mccormack, meridian_lauderdale, mid_mississippi, missouri, mtc, nemr, nextech, northwest, 
	ohio, panora, paul_bunyan, pearl_river, peoples_rural, peoples_telecom, pike, pioneer, premier, range_telephone, richland_grant,
	rt_comm, scmtc, siskiyou, smrl, srtc, stayton,
	sunflower, tallahatchie, toledotel, tombigbee, triangle, union_tel, united, us_connect, van_horne, vermont, wabash, waynesboro_wayne,
	webster_calhoun, west_carolina_tel, west_liberty, westel, western_iowa, wilkinson, wilson, winthrop, xit, yalobusha, yazoo
from fabric.lib_master7
);

copy(select * from fabric.libmap_fiber) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/library_map_fiber_publish.csv' with delimiter '|' CSV header;