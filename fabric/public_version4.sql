--CREATE MASTER TABLE
drop table if exists fabric.master5;

create table fabric.master5 as
select ncessch, fipst, leaid, schno, stid, seasch, leanm, schnam, lstree, lcity, lstate, lzip, lzip4, type, 
	status, ulocal, latcod, loncod, conum, coname, cdcode, bies, level, chartr, member, geom
from analysis.nces_public_2011;

--VIEW TABLE
select *
from fabric.master5;

--CAI 
update analysis.cai_dec2013
set caiid = '0' || caiid
where length(caiid) = 11;

select fiber, count(*)
from fabric.master5, analysis.cai_dec2013
where cai_dec2013.caiid = master5.ncessch
	and lstate = 'AK'
group by fiber;

alter table fabric.master5
	drop column if exists cai1;
alter table fabric.master5
	add column cai1 int;
with new_values as(
select caiid, fiber as cai_fiber
	from analysis.cai_dec2013
)
update fabric.master5
	set cai1 = new_values.cai_fiber
	from new_values
	where new_values.caiid=master5.ncessch;

select seasch, caiid, lstate, statecode, fiber
from fabric.master5, analysis.cai_dec2013
where cai_dec2013.caiid = master5.seasch
	and lstate = statecode;

alter table fabric.master5
	drop column if exists cai2;
alter table fabric.master5
	add column cai2 int;
with new_values as(
select caiid, statecode, fiber as cai_fiber
	from analysis.cai_dec2013
)
update fabric.master5
	set cai2 = new_values.cai_fiber
	from new_values
	where new_values.caiid=master5.seasch
		and statecode=lstate;

select stid, caiid, lstate, statecode fiber
from fabric.master5, analysis.cai_dec2013
where cai_dec2013.caiid = master5.stid
	and statecode = lstate;

alter table fabric.master5
	drop column if exists cai3;
alter table fabric.master5
	add column cai3 int;
with new_values as(
select caiid, statecode, fiber as cai_fiber
	from analysis.cai_dec2013
)
update fabric.master5
	set cai3 = new_values.cai_fiber
	from new_values
	where new_values.caiid=master5.stid
		and statecode = lstate;

alter table fabric.master5
	add column cai int;
update fabric.master5
	set cai = cai1
	where cai1 is not null;
update fabric.master5
	set cai = cai2
	where cai2 is not null;
update fabric.master5
	set cai = cai3
	where cai3 is not null;

select cai, count(*)
from fabric.master5
group by cai;

--CALIFORNIA (HSN K-12)
alter table fabric.master5
	drop column if exists st_cd;
alter table fabric.master5
	add column st_cd character varying(30);
update fabric.master5
	set st_cd = stid || seasch
	where lstate = 'CA';

select st_cd, cds_code, fiber
	from fabric.master5, fabric.cenic
	where master5.st_cd = cds_code
	and lstate = 'CA';

alter table fabric.master5
	drop column if exists california;
alter table fabric.master5
	add column california int;
with new_values as(
select cds_code, fiber as ca_fiber
	from fabric.cenic
	order by cds_code
)
update fabric.master5
	set california = new_values.ca_fiber
	from new_values
	where new_values.cds_code=master5.st_cd
		and lstate = 'CA';

--FLORIDA
alter table fabric.master5
	drop column if exists stid_fl;
alter table fabric.master5
	add column stid_fl character varying(2);
update fabric.master5
	set stid_fl = '0' || stid
	from fabric.fl_ind
	where char_length(stid) = 1
	and lstate = 'FL';
update fabric.master5
	set stid_fl = stid
	from fabric.fl_ind
	where char_length(stid) = 2;
alter table fabric.master5
	drop column if exists sea_fl;
alter table fabric.master5
	add column sea_fl character varying(4);
update fabric.master5
	set sea_fl = '000' || seasch
	where char_length(seasch) = 1
	and lstate = 'FL';
update fabric.master5
	set sea_fl = '00' || seasch
	where char_length(seasch) = 2
	and lstate = 'FL';
update fabric.master5
	set sea_fl = '0' || seasch
	where char_length(seasch) = 3
	and lstate  = 'FL';
update fabric.master5
	set sea_fl = seasch
	where char_length(seasch) = 4
	and lstate = 'FL';
alter table fabric.master5
	drop column if exists scd_fl;
alter table fabric.master5
	add column scd_fl character varying(22);
update fabric.master5
	set scd_fl = stid_fl || ' ' || sea_fl
	where lstate = 'FL';

alter table fabric.master5
	drop column if exists florida;
alter table fabric.master5
	add column florida int;
with new_values as(
select school_code, fiber as fl_fiber
	from fabric.fl_ind
	order by school_code
)
update fabric.master5
	set florida=new_values.fl_fiber
	from new_values
	where master5.scd_fl=new_values.school_code
		and lstate = 'FL';

--WEST VIRGINIA
alter table fabric.master5
	drop column if exists west_virginia;
alter table fabric.master5
	add column west_virginia int;
with new_values as(
select wv_school_id, fiber as wv_fiber
	from fabric.wv_ind
	order by wv_school_id
)
update fabric.master5
	set west_virginia=new_values.wv_fiber
	from new_values
	where master5.seasch=new_values.wv_school_id
		and lstate = 'WV';

--NORTH CAROLINA
alter table fabric.master5
	drop column if exists north_carolina;
alter table fabric.master5
	add column north_carolina int;
update fabric.master5
	set north_carolina = -2
	where (schnam = 'STANFIELD ELEMENTARY' or schnam = 'CHARLES E PERRY ELEMENTARY'
		or coname = 'NASH COUNTY' or coname = 'DAVIDSON COUNTY' or coname = 'FRANKLIN COUNTY'
		or coname = 'WARREN COUNTY' or coname = 'IREDELL COUNTY' or coname = 'CASEWELL COUNTY')
		and lstate = 'NC';
update fabric.master5
	set north_carolina = 2
	where north_carolina is null and lstate = 'NC';

--NEW MEXICO
alter table fabric.master5
	drop column if exists new_mexico;
alter table fabric.master5
	add column new_mexico int;
with new_values as(
select nces_id, fiber as nm_fiber
	from fabric.nm_ind
	order by nces_id
)
update fabric.master5
	set new_mexico=new_values.nm_fiber
	from new_values
	where master5.ncessch=new_values.nces_id
		and lstate = 'NM';

--MAINE
alter table fabric.master5
	drop column if exists maine;
alter table fabric.master5
	add column maine int;
with new_values as(
select nces_id, fiber as me_fiber
	from fabric.me_ind
	order by nces_id
)
update fabric.master5
	set maine=new_values.me_fiber
	from new_values
	where master5.ncessch=new_values.nces_id
		and lstate = 'ME';

--TEXAS
alter table fabric.master5
	drop column if exists round_rock,
	drop column if exists palestine;
alter table fabric.master5
	add column round_rock int,
	add column palestine int;
update fabric.master5
	set round_rock = 2
	where leanm = 'ROUND ROCK ISD'
		and lstate = 'TX';
update fabric.master5
	set palestine = 2
	where leanm = 'PALESTINE ISD'
		and lstate = 'TX';

--MONTANA
alter table fabric.master5
	drop column if exists montana;
alter table fabric.master5
	add column montana int;
with new_values as(
select school_name, district_name, fiber as mt_fiber
	from fabric.mt_ind
)
update fabric.master5
	set montana=new_values.mt_fiber
	from new_values
	where master5.schnam = upper(new_values.school_name)
		and master5.leanm = upper(new_values.district_name)
		and lstate = 'MT';

update fabric.master5
	set montana = -1
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
	from fabric.sunesys, fabric.master5
	where rev_appname=leanm
		and appstate=lstate
		and apptype = 'District';

alter table fabric.master5
	add column sunesys int;
with new_values as(
select sunesys.rev_appname, appstate, apptype, fiber as sunesys_fiber
	from fabric.sunesys
)
update fabric.master5
	set sunesys=new_values.sunesys_fiber
	from new_values
	where leanm=new_values.rev_appname
		and lstate=new_values.appstate
		and apptype = 'District';

--OHIO
alter table fabric.master5
	drop column if exists ohio;
alter table fabric.master5
	add column ohio int;
with new_values as(
select building_name, building_city, fiber as oh_fiber
from fabric.oh_ind
)
update fabric.master5
	set ohio = new_values.oh_fiber
	from new_values
	where master5.schnam = upper(new_values.building_name)
	and master5.lcity = upper(new_values.building_city)
	and master5.lstate = 'OH';

--FAT BEAM
alter table fabric.master5
	drop column if exists fatbeam;
alter table fabric.master5
	add column fatbeam int;
update fabric.master5
	set fatbeam = 2
	where leaid = '5301140' or leaid = '5303510' or leaid = '5304950' or leaid = '5308670' or leaid = '5310110'
		or leaid = '3005280' or leaid = '3005310' or leaid = '1600780' or leaid = '5305370' or leaid = '5302940'
		or leaid = '1602670';

--GEORGIA
alter table fabric.master5
	drop column if exists georgia;
alter table fabric.master5
	add column georgia int;
with new_values as(
select ncesid, fiber AS ga_fiber
from fabric.ga_ind_new
)
update fabric.master5
set georgia = new_values.ga_fiber
from new_values
where ncessch = ncesid;

--BIE
alter table fabric.master5
	drop column if exists bie;
alter table fabric.master5
	add column bie int;
with new_values as(
select school_code, fiber AS bie_fiber
from fabric.bie_ind
)
update fabric.master5
set bie = new_values.bie_fiber
from new_values
where master5.seasch = new_values.school_code;

--NAVAJO
alter table fabric.master5
	drop column if exists navajo;
alter table fabric.master5
	add column navajo int;
with new_values as(
select nces_id, fiber as navajo_fiber
	from fabric.navajo_schools
	order by nces_id
)
update fabric.master5
	set navajo = new_values.navajo_fiber
	from new_values
	where new_values.nces_id=master5.ncessch;

--ARIZONA
alter table fabric.master5
	drop column if exists az_ind,
	drop column if exists nogales;
alter table fabric.master5
	add column nogales int;
update fabric.master5
	set nogales = 2
	where leanm = 'NOGALES UNIFIED DISTRICT'
		and lstate = 'AZ';

--PUERTO RICO
alter table fabric.master5
	drop column if exists puerto_rico;
alter table fabric.master5
	add column puerto_rico int;

with new_values as(
select school_code, fiber
from fabric.pr_ind
)
update fabric.master5
set puerto_rico = new_values.fiber
from new_values
where seasch = school_code
	and lstate = 'PR';

--DC
alter table fabric.master5
	drop column if exists dc;
alter table fabric.master5
	add column dc int;

with new_values as(
select nces_code, fiber
from fabric.dc_ind
)
update fabric.master5
set dc = new_values.fiber
from new_values
where ncessch = nces_code;

--C SPIRE
alter table fabric.master5
	drop column if exists c_spire;
alter table fabric.master5
	add column c_spire int;

update fabric.master5
set c_spire = 2
where leaid = '2800600' or leaid = '2800820' or leaid = '2801050' or leaid = '2801090' or leaid = '2801170' or leaid = '2801260'
	or leaid = '2801320' or leaid = '2801490' or leaid = '2801800' or leaid = '2801860' or leaid = '2801950' or leaid = '2802190'
	or leaid = '2802550' or leaid = '2802820' or leaid = '2802850' or leaid = '2802910' or leaid = '2802970' or leaid = '2803270'
	or leaid = '2803570' or leaid = '2803530' or leaid = '2803600' or leaid = '2803720' or leaid = '2803780' or leaid = '2803830'
	or leaid = '2804020' or leaid = '2804290' or leaid = '2804440' or leaid = '2804560';

--EMAIL SUBMISSIONS
alter table fabric.master5
	drop column if exists revere,
	drop column if exists citizens,
	drop column if exists hudson,
	drop column if exists rock_island,
	drop column if exists elmwood,
	drop column if exists ketchikan,
	drop column if exists galena,
	drop column if exists farmers,
	drop column if exists toledotel,
	drop column if exists wabash,
	drop column if exists peoples_rural,
	drop column if exists south_central,
	drop column if exists garden_valley,
	drop column if exists mtc,
	drop column if exists clear_lake,
	drop column if exists peoples_telecom,
	drop column if exists west_texas_rural,	
	drop column if exists com_net,
	drop column if exists yadtel,
	drop column if exists heart_iowa,
	drop column if exists mckenzie,
	drop column if exists alliance,
	drop column if exists ganado,
	drop column if exists us_connect,
	drop column if exists middleburgh,
	drop column if exists dupage,
	drop column if exists marion,
	drop column if exists snc,
	drop column if exists mte,
	drop column if exists dobson,
	drop column if exists sacred_wind,
	drop column if exists west_central,
	drop column if exists arlington,
	drop column if exists s_and_a,
	drop column if exists west_carolina_tel,
	drop column if exists butler_bremer,
	drop column if exists manawa,
	drop column if exists srtc,
	drop column if exists southwest_texas,
	drop column if exists totah_totel,
	drop column if exists runestone,
	drop column if exists golden_belt,
	drop column if exists united,
	drop column if exists tca,
	drop column if exists midstate,
	drop column if exists premier,
	drop column if exists fibercomm,
	drop column if exists h_and_b,
	drop column if exists ftc,
	drop column if exists marne_elk,
	drop column if exists yelcot,
	drop column if exists alpine,
	drop column if exists laporte,
	drop column if exists nextech,
	drop column if exists newton,
	drop column if exists nemr,
	drop column if exists otelco,
	drop column if exists wilson,
	drop column if exists pmt,
	drop column if exists alenco_comm,
	drop column if exists wikstrom,
	drop column if exists van_horne,
	drop column if exists dumont, 
	drop column if exists pioneer,
	drop column if exists paul_bunyan,
	drop column if exists ortelco,
	drop column if exists waldron,
	drop column if exists gervais_datavision,
	drop column if exists mcleod,
	drop column if exists htc,
	drop column if exists franklin,
	drop column if exists phoenixville,
	drop column if exists mifflin,
	drop column if exists blue_mountain,
	drop column if exists in_shore,
	drop column if exists dubois,
	drop column if exists spring_grove,
	drop column if exists kane,
	drop column if exists hempfield,
	drop column if exists octorara,
	drop column if exists lebanon,
	drop column if exists souderton,
	drop column if exists atc,
	drop column if exists monon,
	drop column if exists south_middleton,
	drop column if exists somerset,
	drop column if exists bellwood_antis,
	drop column if exists fort_laboeuf,
	drop column if exists harrisonville,
	drop column if exists eastex,
	drop column if exists redbank,
	drop column if exists wayne_highlands,
	drop column if exists rt_comm,
	drop column if exists dubois_telephone,
	drop column if exists advanced,
	drop column if exists range_telephone,
	drop column if exists red_river,
	drop column if exists upper_dauphin,
	drop column if exists huntsville,
	drop column if exists glen_rose,
	drop column if exists ritter,
	drop column if exists van_buren;
alter table fabric.master5
	add column revere int,
	add column citizens int,
	add column hudson int,
	add column rock_island int,
	add column elmwood int,
	add column ketchikan int,
	add column galena int,
	add column farmers int,
	add column toledotel int,
	add column wabash int,
	add column peoples_rural int,
	add column south_central int,
	add column garden_valley int,
	add column mtc int,
	add column clear_lake int,
	add column peoples_telecom int,
	add column west_texas_rural int,
	add column com_net int,
	add column yadtel int,
	add column heart_iowa int,
	add column mckenzie int,
	add column alliance int,
	add column ganado int,
	add column us_connect int,
	add column middleburgh int,
	add column dupage int,
	add column marion int, 
	add column snc int,
	add column mte int,
	add column dobson int,
	add column sacred_wind int,
	add column west_central int,
	add column arlington int,
	add column s_and_a int,
	add column west_carolina_tel int,
	add column butler_bremer int,
	add column manawa int,
	add column srtc int,
	add column southwest_texas int,
	add column totah_totel int,
	add column runestone int,
	add column golden_belt int,
	add column united int,
	add column tca int,
	add column midstate int,
	add column premier int,
	add column fibercomm int,
	add column h_and_b int,
	add column ftc int,
	add column marne_elk int,
	add column yelcot int,
	add column alpine int,
	add column laporte int,
	add column nextech int,
	add column newton int,
	add column nemr int,
	add column otelco int,
	add column wilson int,
	add column pmt int,
	add column alenco_comm int,
	add column wikstrom int,
	add column van_horne int,
	add column dumont int,
	add column pioneer int,
	add column paul_bunyan int,
	add column ortelco int,
	add column waldron int,
	add column gervais_datavision int,
	add column mcleod int,
	add column htc int,
	add column franklin int,
	add column phoenixville int,
	add column mifflin int,
	add column blue_mountain int,
	add column in_shore int,
	add column dubois int,
	add column spring_grove int,
	add column kane int,
	add column hempfield int,
	add column octorara int,
	add column lebanon int,
	add column souderton int,
	add column atc int,
	add column monon int,
	add column south_middleton int,
	add column somerset int,
	add column bellwood_antis int,
	add column fort_laboeuf int,
	add column harrisonville int,
	add column eastex int,
	add column redbank int,
	add column wayne_highlands int,
	add column rt_comm int,
	add column dubois_telephone int,
	add column advanced int,
	add column range_telephone int,
	add column red_river int,
	add column upper_dauphin int,
	add column huntsville int,
	add column glen_rose int;

update fabric.master5
set ketchikan = 2
where leaid = '0200150';

update fabric.master5
set revere = 2 
where leaid = '2510050';

update fabric.master5
set citizens = 2
where ncessch = '551044001363';

update fabric.master5
set hudson = 2
where ncessch = '390500203801' or ncessch = '390500203802' or ncessch = '390500203803' or ncessch = '390500203804'
	or ncessch = '390500200199' or ncessch = '390500203805';

update fabric.master5
set rock_island = 2
where ncessch = '173441003526' or ncessch = '173441003527' or ncessch = '173441003538' or ncessch = '173441003528' 
	or ncessch = '173441003530' or ncessch = '173441006107' or ncessch = '173441003534' or ncessch = '170020406200' 
	or ncessch = '173441006155' or ncessch = '173441003535' or ncessch = '173441005967' or ncessch = '173441003540' 
	or ncessch = '173441003536' or ncessch = '173441005338' or ncessch = '173441003529';

update fabric.master5
set elmwood = 2
where ncessch = '171410004687' or ncessch = '171410001760' or ncessch = '171410001762' or ncessch = '171410005506' 
	or ncessch = '171410001761';

update fabric.master5
set galena = 2
where ncessch = '171605001914' or ncessch = '171605001913' or ncessch = '171605001912';

update fabric.master5
set farmers = 2
where ncessch = '550567000601' or ncessch = '550567000602' or ncessch = '550567000603' or ncessch = '550567002704'
	or ncessch = '550567000604';

update fabric.master5
set toledotel = 2
where leaid = '5308910' or leaid = '5309930';

update fabric.master5
set wabash = 2
where leaid = '3904857' or leaid = '3910030' or leaid = '3904859' or leaid = '3904858';

update fabric.master5
set peoples_rural = 2
where leaid = '2102940' or leaid = '2104620';

update fabric.master5
set south_central = 2 
where leaid = '2003570' or leaid = '2008130' or leaid = '2009450' or leaid = '2008310' or leaid = '2011430';

update fabric.master5
set garden_valley = 2
where leaid = '2703570' or leaid = '2700103' or leaid = '2711910' or leaid = '2712300' or leaid = '2713020'
	or leaid = '2718920' or leaid = '2724030' or leaid = '2729070' or leaid = '2730450' or leaid = '2791449';

update fabric.master5
set mtc = 2
where leaid = '1918930';

update fabric.master5
set clear_lake = 2
where ncessch = '190762000363' or ncessch = '190762000364' or ncessch = '190762000362' or ncessch = '192910001673'
	or ncessch = '192910001674';

update fabric.master5
set peoples_telecom = 2
where ncessch = '200825000755' or ncessch = '200825000754' or ncessch = '200825000752';

update fabric.master5
set west_texas_rural = 2
where ncessch = '484437005066' or ncessch = '483557005577' or ncessch = '483557010997' or ncessch = '483557007057'
	or ncessch = '481998001952' or ncessch = '481998001953' or ncessch = '481998001954' or ncessch = '481998006704' 
	or ncessch = '481095000558' or ncessch = '481035000559' or ncessch = '481095005161' or ncessch = '482301002333' 
	or ncessch = '482301002334' or ncessch = '482301002337' or ncessch = '482301002340' or ncessch = '482301002341' 
	or ncessch = '482301002335' or ncessch = '482301002336' or ncessch = '482301002336' or ncessch = '482301006561';

update fabric.master5
set com_net = 2
where ncessch = '391003103298' or ncessch = '390493303563' or ncessch = '390493503567' or ncessch = '390493503568'
	or ncessch = '390493403566' or ncessch = '390493803575'
	or ncessch = '391002301885' or ncessch = '391002203926' or ncessch = '390493701065' or ncessch = '391001901250' 
	or ncessch = '390493203561' or ncessch = '390493603569' or ncessch = '390493103558' or ncessch = '390493903578' 
	or ncessch = '390474302893' or ncessch = '391003000263' or ncessch = '390453104398' or ncessch = '390457802341' 
	or ncessch = '390457902345' or ncessch = '390507704051' or ncessch = '390447201585' or ncessch = '390449801904'
	or ncessch = '390480803106' or ncessch = '390498103699' or ncessch = '390459702393' or ncessch = '390507004037' 
	or ncessch = '391000102900' or ncessch = '390474502898' or ncessch = '390457702339' or ncessch = '390436300186' 
	or ncessch = '390489903467' or ncessch = '390474402895' or ncessch = '390497003676' or ncessch = '390474302893' 
	or ncessch = '390452101366' or ncessch = '390448901762' or ncessch = '390455702283' or ncessch = '390455702284' or ncessch = '390457502331'
	or ncessch = '390500503815' or ncessch = '390448901764' or ncessch = '390448901767' or ncessch = '390448901766'
	or ncessch = '390485903309' or ncessch = '390507404049';

update fabric.master5
set yadtel = 2
where ncessch = '370231000997' or ncessch = '370231000987' or ncessch = '370117002853' or ncessch = '370117000485'
	or ncessch = '370117002516' or ncessch = '370117000486' or ncessch = '370117000487' or ncessch = '370117002065'
	or ncessch = '370117000489' or ncessch = '370117000490' or ncessch = '370117002066' or ncessch = '370117002816'
	or ncessch = '370117000491';

update fabric.master5
set heart_iowa = 2
where ncessch = '190444000118' or ncessch = '190444000087' or ncessch = '191069002048' or ncessch = '190004000132'
	or ncessch = '190006000182';

update fabric.master5
set mckenzie = 2
where leaid = '4702790';

update fabric.master5
set alliance = 2
where ncessch = '460002800014' or ncessch = '460002800874' or ncessch = '460002800013' or ncessch = '46048000036'
	or ncessch = '46048000986' or ncessch = '46048000035' or ncessch = '460795000071' or ncessch = '460795000072' 
	or ncessch = '460795000414' or ncessch = '460795001237' or ncessch = '460795000073' or ncessch = '462637000224' 
	or ncessch = '462637000843' or ncessch = '462637000223' or ncessch = '271404000727' or ncessch = '460002500305' 
	or ncessch = '460002500913' or ncessch = '460002500304' or ncessch = '460102701027' or ncessch = '460102701035'
	or ncessch = '460102701030' or ncessch = '460102701030' or ncessch = '460102701112' or ncessch = '466627000606' 
	or ncessch = '464494000405' or ncessch = '464494000406' or ncessch = '193102001807' or ncessch = '193102001808' 
	or ncessch = '193102001806';

update fabric.master5
set ganado = 2
where ncessch = '482031002006' or ncessch = '482031002007' or ncessch = '482031012317' or ncessch = '484281004881'
	or ncessch = '484281004882' or ncessch = '484281009599' or ncessch = '484281004883' or ncessch = '484281004884'
	or ncessch = '482835021546' or ncessch = '482835003167' or ncessch = '482835011929';

update fabric.master5
set us_connect = 2
where ncessch = '080615001082' or ncessch = '080615001074' or ncessch = '080615001081' or ncessch = '310007200188' 
	or ncessch = '310014001421';
update fabric.master5
set us_connect = -2
where ncessch = '080384000503' or ncessch = '080384000622' or ncessch = '080384000502' or ncessch = '080384001695'
	or ncessch = '310007201879' or ncessch = '317581001914' or ncessch = '317581001533';

update fabric.master5
set middleburgh = 2
where leaid = '3619260' or leaid = '3626100';

update fabric.master5
set dupage = 2
where ncessch = '171394001738' or ncessch = '171394001737';

update fabric.master5
set marion = 2
where leaid = '0509390';

update fabric.master5
set snc = 2
where leaid = '3170530';

update fabric.master5
	set mte = 2
	where ncessch = '160216000857';
update fabric.master5
	set mte = -2
	where ncessch = '160072000143' or leaid = '0409540';

update fabric.master5
set dobson = 2
where ncessch = '401956000931' or ncessch = '400750000299' or ncessch = '400750000300' or ncessch = '401104000525'
	or ncessch = '401104029615' or ncessch = '401737000844' or ncessch = '401737000845' or ncessch = '401956000932'
	or ncessch = '401956000933' or ncessch = '402580001370' or ncessch = '402580001371' or ncessch = '402931001538'
	or ncessch = '402931001539' or ncessch = '402943001549' or ncessch = '402943001550' or ncessch = '403117001727'
	or ncessch = '403117029664' or ncessch = '403264001804';

update fabric.master5
set sacred_wind = 2
where ncessch = '350039000187';

update fabric.master5
set west_central = 2
where leaid = '2740920' or leaid = '2720580';

update fabric.master5
set arlington = 2
where leaid = '5100270';

update fabric.master5
set s_and_a = 2
where ncessch = '200321000211' or ncessch = '201041001058';

update fabric.master5
set west_carolina_tel = 2
where ncessch = '450069001188' or ncessch = '450069000011' or ncessch = '450390101510' or ncessch = '450069000065'
	or ncessch = '450069000066' or ncessch = '450069000012' or ncessch = '450069000002' or ncessch = '450069000071'
	or ncessch = '450069001379' or ncessch = '450069000010' or ncessch = '450390301563' or ncessch = '450000101414'
	or ncessch = '450300000800' or ncessch = '450300000804' or ncessch = '450300000803' or ncessch = '450084000089'
	or ncessch = '450084000086' or ncessch = '450084000087' or ncessch = '450084000088';

update fabric.master5
set butler_bremer = 2
where ncessch = '190744000354' or ncessch = '190744000355' or ncessch = '192019001360' or ncessch = '192805001637'
	or ncessch = '192805001638' or ncessch = '193054001746';

update fabric.master5
set manawa = 2
where ncessch = '550855000969';

update fabric.master5
set srtc = 2
where ncessch = '480000600274' or ncessch = '480000600275' or ncessch = '480998000468' or ncessch = '481587001152'
	or ncessch = '481587001153' or ncessch = '482262002298' or ncessch = '482274002304' or ncessch = '482274002305'
	or ncessch = '482340002374' or ncessch = '482340002375' or ncessch = '482340006118' or ncessch = '482587005525'
	or ncessch = '482587005526' or ncessch = '483197003552' or ncessch = '483197003553' or ncessch = '482587005527'
	or ncessch = '483396003777' or ncessch = '482274011279' or ncessch = '483828004270' or leaid = '4004350';

update fabric.master5
set southwest_texas = 2
where ncessch = '480000304219' or ncessch = '480000304218' or ncessch = '483324003739' or ncessch = '483324003738'
	or ncessch = '48161400195' or ncessch = '484368004965';

update fabric.master5
set totah_totel = 2
where leaid = '4025470' or leaid = '4000021';

update fabric.master5
set runestone = 2
where leaid = '2700104' or ncessch = '271389000714';

update fabric.master5
set golden_belt = 2
where ncessch = '200585000868' or ncessch = '200822000890' or ncessch = '200870001479' or ncessch = '200906000713'
	or ncessch = '200993000500' or ncessch = '200402000923' or ncessch = '201128002033' or ncessch = '201191000711'
	or ncessch = '200002000498' or ncessch = '200002000501';
	
update fabric.master5
set united = 2
where ncessch = '200351000084' or ncessch = '200351000086' or ncessch = '200351001650' or ncessch = '200414001190'
	or ncessch = '200414001191' or ncessch = '200480000009' or ncessch = '200480000010' or ncessch = '200504000491'
	or ncessch = '200519001270' or ncessch = '200519001713' or ncessch = '200558000879' or ncessch = '200558001089'
	or ncessch = '200558001743' or ncessch = '200558001095' or ncessch = '200558001094' or ncessch = '200558000887'
	or ncessch = '200558001091' or ncessch = '200558001092' or ncessch = '200558001905' or ncessch = '200558000888'
	or ncessch = '200558001093' or ncessch = '200558001096' or ncessch = '200621000103' or ncessch = '200621000104'
	or ncessch = '200768001272' or ncessch = '200768001273' or ncessch = '200780000107' or ncessch = '200780000108'
	or ncessch = '200942000105' or ncessch = '200942000106' or ncessch = '200960000082' or ncessch = '200960000083'
	or ncessch = '200963000782' or ncessch = '200963000783' or ncessch = '200504000492' or ncessch = '200504000493'
	or ncessch = '201182000836' or ncessch = '201182000837';

update fabric.master5
set tca = 2
where ncessch = '080471000683' or ncessch = '080471000684' or ncessch = '080486006387' or ncessch = '080486000811'
	or ncessch = '80486000813' or ncessch = '80600001020' or ncessch = '80600001021' or ncessch = '80456000673'
	or ncessch = '80456000674' or ncessch = '80393000511' or ncessch = '80393000512';

update fabric.master5
set midstate = 2
where ncessch = '466954000628' or ncessch = '466954000629' or ncessch = '466954001054' or ncessch = '468043801244'
	or ncessch = '468043801248' or ncessch = '468043801250' or ncessch = '468043801267' or ncessch = '467851000745'
	or ncessch = '467851000746' or ncessch = '467851000950' or ncessch = '463822000354' or ncessch = '463822000355'
	or ncessch = '463822000142' or ncessch = '461200000118' or ncessch = '461200000119' or ncessch = '461200000889';

update fabric.master5
set premier = 2
where ncessch = '190002102002' or ncessch = '190002102004' or ncessch = '190322001937' or ncessch = '190322001938'
	or ncessch = '190322001939' or ncessch = '190519000166' or ncessch = '190519000167' or ncessch = '190696000306'
	or ncessch = '190696000307' or ncessch = '190696000308' or ncessch = '191248000757' or ncessch = '191248000758'
	or ncessch = '191248001010' or ncessch = '191248001011' or ncessch = '191416000843' or ncessch = '191416000844'
	or ncessch = '191416000845' or ncessch = '191653000983' or ncessch = '191653000984' or ncessch = '191653000985'
	or ncessch = '191653000987' or ncessch = '191653000988' or ncessch = '191653001101' or ncessch = '191884000710'
	or ncessch = '191884001112' or ncessch = '192466001414' or ncessch = '192466001415' or ncessch = '192637001495'
	or ncessch = '192637001496' or ncessch = '192637001497' or ncessch = '193129001820' or ncessch = '193129001822';

update fabric.master5
set fibercomm = 2
where ncessch = '192640001498' or ncessch = '192640001500' or ncessch = '192640001502' or ncessch = '192640001504'
	or ncessch = '192640001505' or ncessch = '192640001506' or ncessch = '192640001513' or ncessch = '192640001514'
	or ncessch = '192640002080' or ncessch = '192640001515' or ncessch = '192640001934' or ncessch = '192640002165'
	or ncessch = '192640001517' or ncessch = '192640001518' or ncessch = '192640001521' or ncessch = '192640001522'
	or ncessch = '192640001287' or ncessch = '192640001526' or ncessch = '192640001527' or ncessch = '192640001530'
	or ncessch = '192640002089' or ncessch = '192640001531' or ncessch = '192640001533' or ncessch = '192640001534'
	or ncessch = '192640001535';

update fabric.master5
set h_and_b = 2
where ncessch = '200465000912' or ncessch = '200465000914' or ncessch = '200465000913' or ncessch = '200034902044'
	or ncessch = '200034902042' or ncessch = '200034902043';

update fabric.master5
set ftc = 2
where ncessch = '4580267000712' or ncessch = '450390201453'  or ncessch = '450390201452' or ncessch = '450390201388'
	or ncessch = '450390201317' or ncessch = '450390201080' or ncessch = '450390201079' or ncessch = '450390201078'
	or ncessch = '450390201077' or ncessch = '450390201073' or ncessch = '450390201071' or ncessch = '450390201069'
	or ncessch = '450390201068' or ncessch = '450390201067' or ncessch = '450390201066' or ncessch = '450390201065'
	or ncessch = '450390201064' or ncessch = '450390201062' or ncessch = '450390201061' or ncessch = '450390201060'
	or ncessch = '450390201059' or ncessch = '450390201057' or ncessch = '450390201057' or ncessch = '450390200511'
	or ncessch = '450390200223' or ncessch = '450390200217' or ncessch = '450390101543' or ncessch = '450378001584'
	or ncessch = '450378001371' or ncessch = '450378001112' or ncessch = '450378001111' or ncessch = '450378001107'
	or ncessch = '450378001099' or ncessch = '450378001096' or ncessch = '450378001094' or ncessch = '450267001540'
	or ncessch = '450267000711' or ncessch = '450267000709' or ncessch = '450267000559' or ncessch = '450219001502'
	or ncessch = '450219001237' or ncessch = '450219000457' or ncessch = '450219000456' or ncessch = '450219000454'
	or ncessch = '450219000453' or ncessch = '450219000452' or ncessch = '450219000451' or ncessch = '450180000331'
	or ncessch = '450180000329' or ncessch = '450177000431' or ncessch = '450160000328' or leaid = '4503902' or leaid = '4502190';
	
update fabric.master5
set marne_elk = 2
where ncessch = '191125002142' or ncessch = '191071000674' or ncessch = '191071002143';

update fabric.master5
set yelcot = 2
where leaid = '0514490' or leaid = '0504680' or leaid = '0510200' or leaid = '0512540';

update fabric.master5
set alpine = 2
where ncessch = '190684000292' or ncessch = '190684000293' or ncessch = '191335000751' or ncessch = '192871002058'
	or ncessch = '192871001664' or ncessch = '191335000807' or ncessch = '191335000806' or ncessch = '191812001484'
	or ncessch = '191812001068';

update fabric.master5
set laporte = 2
where ncessch = '190002200956' or ncessch = '190002200957';

update fabric.master5
set nextech = 2
where ncessch = '201131000942' or ncessch = '201047000397' or ncessch = '201002000058' or ncessch = '201104000576'
	or ncessch = '200726000429' or ncessch = '200753000965' or ncessch = '200702001680' or ncessch = '200447000405'
	or ncessch = '200702001318' or ncessch = '200891000607' or ncessch = '200985000904' or ncessch = '200327000061'
	or ncessch = '201008000475' or ncessch = '201029000881' or ncessch = '201065000604' or ncessch = '200531001018'
	or ncessch = '201074000399' or ncessch = '201095000472' or ncessch = '200702001324' or ncessch = '201131000943'
	or ncessch = '200000700155' or ncessch = '201206000401' or ncessch = '200034601903' or ncessch = '201263000050'
	or ncessch = '201260002018' or ncessch = '200702001319' or ncessch = '200663001873' or ncessch = '200702001320'
	or ncessch = '200702001321' or ncessch = '201104000574' or ncessch = '200327000063' or ncessch = '201002000059'
	or ncessch = '201047000396' or ncessch = '201065000605' or ncessch = '200531001586' or ncessch = '201131000944'
	or ncessch = '200034601900' or ncessch = '201008000477' or ncessch = '201104000575' or ncessch = '200702001322'
	or ncessch = '200726001954' or ncessch = '200753000966' or ncessch = '200447000406' or ncessch = '200891000608'
	or ncessch = '200985000905' or ncessch = '200327000062' or ncessch = '201002000060' or ncessch = '201029000882'
	or ncessch = '201047000398' or ncessch = '201065000606' or ncessch = '201074000400' or ncessch = '201095000473'
	or ncessch = '201131000945' or ncessch = '200000700156' or ncessch = '201206000402' or ncessch = '200034601922'
	or ncessch = '201263000051' or ncessch = '201260001999' or ncessch = '200663001891';

update fabric.master5
set newton = 2
where leaid = '2803180';

update fabric.master5
set nemr = 2
where leaid = '2922980' or ncessch = '291638000797' or leaid = '2913230' or leaid = '2925640'
	or leaid = '2927660' or leaid = '2920700';
update fabric.master5
set nemr = -2
where leaid = '2919320';

update fabric.master5
set otelco = 2
where ncessch = '10042000670' or ncessch = '10042000203' or ncessch = '10042000682' or ncessch = '10042000205'
	or ncessch = '10042000206' or ncessch = '10042000101' or ncessch = '10042000208' or ncessch = '10042001870'
	or ncessch = '10042000207' or ncessch = '10042000209' or ncessch = '10042000210' or ncessch = '10042000211'
	or ncessch = '10010000028' or ncessch = '10255001064' or ncessch = '10042000213';

update fabric.master5
set wilson = 2
where ncessch = '200034902022' or ncessch = '200034902022' or ncessch = '201212001976' or ncessch = '201212002008';

update fabric.master5
set pmt = 2
where leaid = '1602190';

update fabric.master5
set alenco_comm = 2
where ncessch = '482580002911';

update fabric.master5
set wikstrom = 2
where ncessch = '270012700131' or leaid = '2703540' or leaid = '2717570' or leaid = '2700107' or leaid = '2791447'
	or leaid = '2791446' or leaid = '2717880' or ncessch = '270010702572' or leaid = '2723550' or leaid = '2732250'
	or leaid = '2700127' or leaid = '2738850' or leaid = '2700024' or leaid = '2741850';

update fabric.master5
set van_horne = 2
where ncessch = '190483000137' or ncessch = '190483001987';

update fabric.master5
set dumont = 2
where ncessch = '190345000043' or ncessch = '190345000042';

update fabric.master5
set pioneer = 2
where ncessch = '410216000641' or ncessch = '410750000657' or ncessch = '410750001582' or ncessch = '410750000667'
	or ncessch = '410960000020' or ncessch = '410960001481' or ncessch = '410960000021' or ncessch = '410960000022'
	or ncessch = '410960000024' or ncessch = '410960000023';

update fabric.master5
set paul_bunyan = 2
where ncessch = '270444000190' or ncessch = '270444002031' or ncessch = '270444000191' or ncessch = '270444000193'
	or ncessch = '270444000196' or ncessch = '270444000192' or ncessch = '270444000194' or ncessch = '270444004454'
	or ncessch = '270444000197' or ncessch = '270444004159' or ncessch = '270444000313' or ncessch = '271827000847'
	or ncessch = '271827000848' or ncessch = '270573000212' or ncessch = '270573000213' or ncessch = '271014000433'
	or ncessch = '271014000434' or ncessch = '271317000662' or ncessch = '271317000935' or ncessch = '271317003073'
	or ncessch = '271317000940' or ncessch = '271317000907' or ncessch = '271317002655' or ncessch = '271317000939'
	or ncessch = '271317000915' or ncessch = '270948002786' or ncessch = '270948000394' or ncessch = '271392000715'
	or ncessch = '271392002143' or ncessch = '271392000716' or ncessch = '273270001945' or ncessch = '273270001413'
	or ncessch = '271500000761' or ncessch = '272331001136' or ncessch = '271701000786' or ncessch = '271701000787'
	or ncessch = '272331001138' or ncessch = '273270001946' or ncessch = '273270001416' or ncessch = '273051001302'
	or ncessch = '273051002427' or ncessch = '273051001303' or ncessch = '273051003303' or ncessch = '271794000825'
	or ncessch = '271794000826';


update fabric.master5
set ortelco = 2
where leaid = '4110110' or leaid = '4104020' or leaid = '4106780' or leaid = '4101740' or leaid = '4106120';

update fabric.master5
set waldron = 2
where leaid = '2635040';

update fabric.master5
set gervais_datavision = 2
where ncessch = '411353001714' or ncessch = '411353001713' or ncessch = '411353001723' or ncessch = '411353001731'
	or ncessch = '411353001715' or ncessch = '411353001546' or ncessch = '411353000844' or ncessch = '411353001051'
	or ncessch = '411353000843' or ncessch = '411353000841' or ncessch = '411353001052' or ncessch = '411353000842'
	or ncessch = '410004300494' or ncessch = '410001500853' or ncessch = '410001500831' or ncessch = '410001501034'
	or ncessch = '410001500821' or ncessch = '411176000824' or ncessch = '411176000823' or ncessch = '410327000109'
	or ncessch = '410327000110' or ncessch = '410327001343';

update fabric.master5
set mcleod = -2
where leaid = '4829910';

update fabric.master5
set htc = 2
where ncessch = '190001501486' or ncessch = '190001501487' or ncessch = '190001501485' or ncessch = '192598001473'
	or ncessch = '192598001474' or ncessch = '192598001475' or ncessch = '191884001114';

update fabric.master5
set franklin = 2
where ncessch = '428023007067';

update fabric.master5
set phoenixville = 2
where ncessch = '421905001426' or ncessch = '421905001430' or ncessch = '421905001396' or ncessch = '421905007296'
	or ncessch = '421905001425' or ncessch = '421905004841';

update fabric.master5
set mifflin = 2
where ncessch = '421529006261' or ncessch = '421529007396' or ncessch = '421529007391' or ncessch = '421529007397'
	or ncessch = '421529007398' or ncessch = '421529007399' or ncessch = '421529000784' or ncessch = '421529007392'
	or ncessch = '421529003196';

update fabric.master5
set blue_mountain = 2
where ncessch = '420387003891' or ncessch = '420387005263' or ncessch = '420387004659' or ncessch = '420387000138'
	or ncessch = '420387003887';

update fabric.master5
set in_shore = 2
where ncessch = '421095001251' or ncessch = '421095001252' or ncessch = '421095007120' or ncessch = '421095001250'
	or leaid = '4209750' or ncessch = '420534006646' or ncessch = '420534001208' or ncessch = '420534001202';
update fabric.master5
set in_shore = -2
where ncessch = '420534001205';

update fabric.master5
set dubois = 2
where leaid = '4207830';

update fabric.master5
set spring_grove = 2
where ncessch = '422259004623' or ncessch = '422259006725' or ncessch = '422259004622' or ncessch = '422259004618'
	or ncessch = '422259004617' or ncessch = '422259004620';

update fabric.master5
set kane = 2
where ncessch = '421266005244' or ncessch = '421266003100' or ncessch = '421266005245';

update fabric.master5
set hempfield = 2
where ncessch = '421179002578' or ncessch = '421179000118' or ncessch = '421179006294' or ncessch = '421179000160'
	or ncessch = '421179005055' or ncessch = '421179005236' or ncessch = '421179002574' or ncessch = '421179002577'
	or ncessch = '421179002576' or ncessch = '421179002575';

update fabric.master5
set octorara = 2
where leaid = '4218030';

update fabric.master5
set lebanon = 2
where ncessch = '421764002760' or ncessch = '421764000098' or ncessch = '421764002755' or ncessch = '421764002757'
	or ncessch = '421764002756' or ncessch = '421764002758';

update fabric.master5
set souderton = 2
where ncessch = '422187003357' or ncessch = '422187004900' or ncessch = '422187003266' or ncessch = '422187009965'
	or ncessch = '422187003350' or ncessch = '422187000697' or ncessch = '422187004721' or ncessch = '422187004722'
	or ncessch = '422187003354';

update fabric.master5
set atc = 2
where ncessch = '160249000433' or ncessch = '160249000432' or ncessch = '160249000629' or ncessch = '160249000434'
	or ncessch = '160249000856' or ncessch = '160066000122' or ncessch = '160066000123' or ncessch = '160066000129'
	or ncessch = '160066000134' or ncessch = '160049000007' or ncessch = '160049000008' or ncessch = '160049000662'
	or ncessch = '160190000331' or ncessch = '160190000332';

update fabric.master5
set monon = 2
where ncessch = '180813001396' or ncessch = '180813002522' or ncessch = '180813002500';

update fabric.master5
set south_middleton = 2
where ncessch = '422205001730' or ncessch = '422205006853' or ncessch = '422205000455' or ncessch = '422205006328';

update fabric.master5
set somerset = -2
where ncessch = '428040007085';

update fabric.master5
set bellwood_antis = 2
where ncessch = '420330000914' or ncessch = '420330007170' or ncessch = '420330000917';

update fabric.master5
set fort_laboeuf = 2
where ncessch = '420999002037' or ncessch = '420999005328' or ncessch = '420999002036' or ncessch = '420999002035';
update fabric.master5
set fort_laboeuf = -2
where ncessch = '420999005226';

update fabric.master5
set harrisonville = 2
where leaid = '1741070' or leaid = '1710740' or leaid = '1712720' or leaid = '1733300';

--update fabric.master5
--set eastex = 2
--where leaid = 

update fabric.master5
set redbank = 2
where leaid = '4220130';

update fabric.master5
set wayne_highlands = 2
where ncessch = '422497004295' or ncessch = '422497006865' or ncessch = '422497000226' or ncessch = '422497004291'
	or ncessch = '422497006424' or ncessch = '422497006425';

update fabric.master5
set rt_comm = 2
where ncessch = '560331000180' or ncessch = '560331000185' or ncessch = '560331000185' or ncessch = '560624000345'
	or ncessch = '560624000346' or ncessch = '560624000346' or ncessch = '560624000346' or ncessch = '560624000344'
	or ncessch = '560483000265' or ncessch = '560483000265' or ncessch = '560483000263' or ncessch = '560483000263'
	or ncessch = '560570000362' or ncessch = '560570000323' or ncessch = '560570000510' or ncessch = '560377000449'
	or ncessch = '560451000157' or ncessch = '560451000133' or ncessch = '560237000451' or ncessch = '560237000148'
	or ncessch = '560237000398' or ncessch = '560412000208' or ncessch = '560412000504' or ncessch = '560412000209'
	or ncessch = '560412000213' or ncessch = '560412000210' or ncessch = '560412000210' or ncessch = '560609000363'
	or ncessch = '560609000401' or ncessch = '560609000401';
update fabric.master5
set rt_comm = 2
where ncessch = '560570000510';

update fabric.master5
set dubois_telephone = 2
where ncessch = '560267000151' or ncessch = '560283000159' or ncessch = '560103000124';

update fabric.master5
set advanced = 2
where ncessch = '560451000254' or ncessch = '560283000159' or ncessch = '560445000441' or ncessch = '300708000194'
	or ncessch = '560096000162';

update fabric.master5
set range_telephone = 2
where ncessch = '560568000309' or ncessch = '560568000310' or ncessch = '560568000522' or ncessch = '560568000308';
update fabric.master5
set range_telephone = -2
where  ncessch = '560237000405' or ncessch = '560237000150' or ncessch = '560237000530';

update fabric.master5
set red_river = 2
where ncessch = '381902000666' or ncessch = '388066000722' or ncessch = '380669000190' or ncessch = '380669000191'
	or ncessch = '380871000281' or ncessch = '380871000283' or ncessch = '381114000365' or ncessch = '381114000366'
	or ncessch = '380003600552' or ncessch = '380003600553' or ncessch = '382031000712' or ncessch = '382031000713';

update fabric.master5
set upper_dauphin = 2
where ncessch = '422436006340';
update fabric.master5
set upper_dauphin = -2
where ncessch = '422436009967' or ncessch = '422436006339';

--update fabric.master5
--set huntsville = 2
--where ncessch = 

update fabric.master5
set glen_rose = -2
where leaid = '0506630';

update fabric.master5
set van_buren = 2
where leaid = '0513410';


--------------------------------CORROBORATION SCORING----------------------------------
--MAP SCORE
alter table fabric.master5
	drop column if exists score_map;
alter table fabric.master5
	add column score_map int;

with new_values as(
select ncessch, coalesce(alenco_comm,0) + coalesce(alliance,0) + coalesce(alpine,0) + coalesce(arlington,0) + coalesce(blue_mountain,0)
	+ coalesce(bie,0) + coalesce(butler_bremer,0) + coalesce(california,0) + coalesce(citizens,0) + coalesce(clear_lake,0)
	+ coalesce(com_net,0) + coalesce(cai,0) + coalesce(dc,0) + coalesce(dobson,0) + coalesce(dubois,0) + coalesce(dupage,0) + coalesce(dumont,0)
	+ coalesce(elmwood,0) + coalesce(farmers,0) + coalesce(fatbeam,0) + coalesce(fibercomm,0) + coalesce(florida,0) + coalesce(franklin,0)
	+ coalesce(ftc,0) + coalesce(galena,0) + coalesce(ganado,0) + coalesce(garden_valley,0) + coalesce(georgia,0) + coalesce(gervais_datavision,0)
	+ coalesce(golden_belt,0) + coalesce(h_and_b,0) + coalesce(heart_iowa,0) + coalesce(hempfield,0) + coalesce(htc,0) 
	+ coalesce(hudson,0) + coalesce(in_shore,0) + coalesce(kane,0) + coalesce(ketchikan,0)
	+ coalesce(laporte,0) + coalesce (lebanon,0) + coalesce(maine,0) + coalesce(manawa,0) + coalesce(marion,0) + coalesce(marne_elk,0)
	+ coalesce(mckenzie,0) + coalesce(mcleod,0) + coalesce(middleburgh,0) + coalesce(midstate,0) + coalesce(mifflin,0) + coalesce(montana,0) + coalesce(mtc,0) + coalesce(navajo,0)
	+ coalesce(new_mexico,0) + coalesce(newton,0) + coalesce(nextech,0) + coalesce(nogales,0) + coalesce(north_carolina,0)
	+ coalesce(nemr,0) + coalesce(octorara,0) + coalesce(ohio,0) + coalesce(ortelco,0) + coalesce(otelco,0) + coalesce(palestine,0) + coalesce(paul_bunyan,0)
	+ coalesce(peoples_rural,0) + coalesce(peoples_telecom,0) + coalesce(pioneer,0) + coalesce(phoenixville,0) + coalesce(premier,0) + coalesce(pmt,0) + coalesce(puerto_rico,0)
	+ coalesce(revere,0) + coalesce(rock_island,0) + coalesce(round_rock,0) + coalesce(runestone,0) + coalesce(s_and_a,0)
	+ coalesce(sacred_wind,0) + coalesce(spring_grove,0) + coalesce(srtc,0) + coalesce(south_central,0) + coalesce(snc,0) + coalesce(souderton,0) + coalesce(southwest_texas,0)
	+ coalesce(sunesys,0) + coalesce(tca,0) + coalesce(toledotel,0) + coalesce(totah_totel,0)
	+ coalesce(united,0) + coalesce(us_connect,0) + coalesce(van_horne,0) + coalesce(wabash,0) + coalesce(waldron,0) + coalesce(west_carolina_tel,0)
	+ coalesce(west_central,0) + coalesce(west_texas_rural,0) + coalesce(west_virginia,0) + coalesce(wikstrom,0) + coalesce(wilson,0)
	+ coalesce(yadtel,0) + coalesce(yelcot,0)
	as row_score
from fabric.master5
)
update fabric.master5
set score_map = new_values.row_score
from new_values
where master5.ncessch = new_values.ncessch;

alter table fabric.master5
	drop column if exists fiber_map;
alter table fabric.master5
	add column fiber_map int;

update fabric.master5
set fiber_map = 1
where score_map > 0;

update fabric.master5
set fiber_map = 0
where score_map = 0;

update fabric.master5
set fiber_map = -1
where score_map < 0;

select fiber_map, count(*)
from fabric.master5
group by fiber_map
order by fiber_map;

select score_map, count(*)
from fabric.master5
group by score_map
order by score_map;

drop table if exists fabric.publicmap;
create table fabric.publicmap as(
select ncessch, leaid, ulocal, member, geom, score_map, fiber_map
from fabric.master5
);

copy(select * from fabric.publicmap) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/public_map_fiber.csv' with delimiter '|' CSV header;

alter table fabric.master5
	drop column if exists fiber_v2,
	drop column if exists fiber_v1;
alter table fabric.master5
	add column fiber_v2 int,
	add column fiber_v1 int;

with new_values as(
select ncessch, fiber_map
from fabric.master3
)
update fabric.master5
set fiber_v2 = new_values.fiber_map
from new_values
where master5.ncessch = new_values.ncessch;

with new_values as(
select ncessch, fiber_map
from fabric.master2
)
update fabric.master5
set fiber_v1 = new_values.fiber_map
from new_values
where master5.ncessch = new_values.ncessch;

drop table if exists fabric.map_fiber;
create table fabric.map_fiber as(
select ncessch, schnam, leaid, leanm, lcity, lstate, ulocal, member, geom, fiber_map AS fiber_v3, fiber_v2, fiber_v1, score_map AS score,
	alenco_comm, alliance, alpine, arlington, blue_mountain, bie, butler_bremer, california, citizens, clear_lake, com_net, cai, dc,
	dobson, dubois, dumont, dupage, elmwood, farmers, fatbeam, fibercomm, florida, franklin, ftc, galena, ganado, garden_valley, georgia,
	gervais_datavision, golden_belt, h_and_b, heart_iowa, hempfield, htc, hudson, in_shore, kane, ketchikan, laporte, maine, manawa,
	marion, marne_elk, mckenzie, mcleod, middleburgh, midstate, mifflin, montana, mtc, mte, navajo, new_mexico, newton, nextech, nogales,
	north_carolina, nemr, lebanon, octorara, ohio, ortelco, otelco, palestine, paul_bunyan, peoples_rural, peoples_telecom, phoenixville,
	pioneer, premier, pmt, puerto_rico, revere, rock_island, round_rock, runestone, s_and_a, sacred_wind, srtc, souderton, south_central,
	snc, southwest_texas, spring_grove, sunesys, tca, toledotel, totah_totel, united, us_connect, van_horne, wabash, waldron,
	west_carolina_tel, west_central, west_texas_rural, west_virginia, wikstrom, wilson, yadtel, yelcot
from fabric.master5
);

copy(select * from fabric.map_fiber) to '/Users/FCC/Documents/allison/E-rate analysis/Maps/public_map_fiber_publish.csv' with delimiter '|' CSV header;
