DROP TABLE IF EXISTS fabric.master;

--Create master table
create table fabric.master as
select school_id, fips_state, leaid, stid, seasch, lea_name, school_name, lstreet, lcity, 
	lstate, lzip5, school_type, school_status, school_loc, latitude, longitude, county_name, cong_dist, 
	county_fips, school_lvl, tot_students, geom, state_schid, school_code_fl, school_code_nj, school_name_sd, 
	ncessch, size_sort
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
update fabric.master
	set cai1 = -1
	where cai1 = 0;

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
update fabric.master
	set cai2 = -1
	where cai2 = 0;

alter table fabric.master
	add column cai int;
update fabric.master
	set cai = cai1
	where cai1 is not null;
update fabric.master
	set cai = cai2
	where cai2 is not null;
update fabric.master
	set cai = 0
	where cai is null;

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

--Navajo Schools
----check matches
select count(*)
	from fabric.master, fabric.navajo_schools
	where master.school_id=navajo_schools.nces_id;

----add column
alter table fabric.master
	add column navajo int;
with new_values as(
select nces_id, fiber as navajo_fiber
	from fabric.navajo_schools
	order by nces_id
)
update fabric.master
	set navajo = new_values.navajo_fiber
	from new_values
	where new_values.nces_id=master.school_id;

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
	set nc_ind = -1
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

--TEXAS
alter table fabric.master
	add column tx_ind int;
update fabric.master
	set tx_ind = 1
	where lea_name = 'ROUND ROCK ISD'
		and lstate = 'TX';
update fabric.master
	set tx_ind = 1
	where lea_name = 'PALESTINE ISD'
		and lstate = 'TX';
update fabric.master
	set tx_ind = 0
	where tx_ind is null
		and lstate = 'TX';


--MONTANA
----check matches
select master.school_name, mt_ind.school_name, lstate, state
	from fabric.master, fabric.mt_ind
	where master.school_name = upper(mt_ind.school_name)
		and lstate=state;

-----add fiber column 
alter table fabric.master
	add column mt_ind int;
with new_values as(
select mt_ind.school_name, state, fiber as mt_fiber
	from fabric.mt_ind
)
update fabric.master
	set mt_ind=new_values.mt_fiber
	from new_values
	where master.school_name = upper(new_values.school_name)
		and master.lstate = new_values.state;

update fabric.master
	set mt_ind = -1
	where lstate = 'MT' and (school_name = 'POLARIS SCHOOL' or school_name = 'PLENTY COUPS HIGH SCHOOL' 
		or school_name = 'LUTHER SCHOOL' or school_name = 'HAMMOND SCHOOL' or school_name = 'HAWKS HOME SCHOOL' 
		or school_name = 'BENTON LAKE SCHOOL' or school_name = 'KINSEY SCHOOL' or school_id = '302088000624' 
		or school_name = 'WEST GLACIER SCHOOL' or school_name = 'MALMBORG SCHOOL' or school_name = 'PASS CREEK SCHOOL' 
		or school_name = 'KESTER SCHOOL' or school_name = 'BABB SCHOOL' or school_name = 'EAST GLACIER PARK' 
		or school_name = 'GLENDALE SCHOOL' or school_name = 'CARDWELL SCHOOL' or school_id = '300009800325' 
		or school_name = 'SAGE CREEK ELEMENTARY' or school_name = 'YAAK SCHOOL' or school_id = '302067000619' 
		or school_id = '302067000166' or school_id = '300093201025' or school_id = '300093201024' or school_id = '300093301026'
		or school_id = '301719000538' or school_id = '301719000251' or school_name = 'FISHTAIL SCHOOL'
		or school_name = 'LUSTRE SCHOOL' or school_name = 'MORIN SCHOOL' or school_name = 'PRAIRIE ELK COLONY SCHOOL'
		or school_name = 'RIMROCK COLONY SCHOOL' or school_name = 'MIAMI COLONY SCHOOL' or school_name = 'MIDWAY COLONY SCHOOL'
		or school_name = 'KING COLONY SCHOOL' or school_name = 'FAIRHAVEN COLONY SCHOOL' or school_name = 'CASCADE COLONY SCHOOL'
		or school_name = 'DEERFIELD COLONY SCHOOL' or school_name = 'NORTH HARLEM COLONY SCHOOL' or school_name = 'SPRING CREEK COLONY SCHOOL');

--SUNESYS
----check matches
select sunesys.rev_appname, master.lea_name, appstate, lstate
	from fabric.sunesys, fabric.master
	where rev_appname=lea_name
		and appstate=lstate;

----add fiber column
alter table fabric.master
	add column sunesys int;
with new_values as(
select sunesys.rev_appname, appstate, fiber as sunesys_fiber
	from fabric.sunesys
)
update fabric.master
	set sunesys=new_values.sunesys_fiber
	from new_values
	where lea_name=new_values.rev_appname
		and lstate=new_values.appstate;
	
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

--CCI Data
-----add fiber column
alter table fabric.master
	drop column if exists cci1;
alter table fabric.master
	add column cci1 int;

with new_values as(
select org_name, city, state, fiber as cci_fiber
from fabric.cci
where cai_type = 'Schools (K-12)'
)
update fabric.master
	set cci1=new_values.cci_fiber
	from new_values
	where master.school_name = upper(new_values.org_name)
	and master.lstate = new_values.state
	and master.lcity = upper(new_values.city);


alter table fabric.master
	drop column if exists cciSD;
alter table fabric.master
	add column cciSD int;

with new_values as(
select org_name, service_address, city, state, fiber as cci_fiber
from fabric.cci
where cai_type = 'Schools (K-12)'
	and state = 'SD'
)
update fabric.master
	set cciSD=new_values.cci_fiber
	from new_values
	where master.school_name_sd = upper(new_values.org_name)
		and master.lstate = new_values.state
		and master.lcity = upper(new_values.city);

alter table fabric.master
	drop column if exists cciIA;
alter table fabric.master
	add column cciIA int;

with new_values as(
select org_name, service_address, city, state, fiber as cci_fiber
from fabric.cci
where cai_type = 'Schools (K-12)'
	and state = 'IA'
)
update fabric.master
	set cciIA=new_values.cci_fiber
	from new_values
	where master.lstreet = upper(new_values.service_address)
	and master.lcity = upper(new_values.city)
	and master.lstate = new_values.state
	and (school_id <> '010264001385' and school_id <> '010264001385' and school_id <> '010264001386'
		 and school_id <> '080453000664' and school_id <> '090057000113' and school_id <> '090219001529'
		 and school_id <> '090498001043' and school_id <> '090330000664' and school_id <> '090002801366'
		 and school_id <> '090015001373' and school_id <> '090432000864' and school_id <> '090339000713'
		 and school_id <> '110008200441' and school_id <> '130258002727' and school_id <> '190822000419'
		 and school_id <> '190798000398' and school_id <> '191329000415' and school_id <> '192244001345'
		 and school_id <> '192244000523' and school_id <> '190549000173' and school_id <> '190393000412'
		 and school_id <> '190575001620' and school_id <> '190575000176' and school_id <> '191104000682'
		 and school_id <> '191311000170' and school_id <> '190001501485' and school_id <> '192253001355'
		 and school_id <> '190330000024' and school_id <> '190597000203' and school_id <> '192466001414'
		 and school_id <> '193063000990' and school_id <> '190897000232' and school_id <> '190897002128'
		 and school_id <> '190897002082' and school_id <> '192820001644' and school_id <> '192058000712'
		 and school_id <> '192058000713' and school_id <> '192058001217' and school_id <> '191095000676'
		 and school_id <> '191830001049' and school_id <> '190003201317' and school_id <> '190873001501'
		 and school_id <> '192172001296' and school_id <> '190375000081' and school_id <> '192085001246'
		 and school_id <> '192871002058' and school_id <> '190693000303' and school_id <> '190693000305'
		 and school_id <> '190402000013' and school_id <> '190402000099' and school_id <> '190474000134'
		 and school_id <> '192802001635' and school_id <> '192802001636' and school_id <> '192556001459'
		 and school_id <> '199901901259' and school_id <> '190912000595' and school_id <> '190309000006'
		 and school_id <> '192799001630' and school_id <> '192799000309' and school_id <> '190684000293'
		 and school_id <> '190678001998' and school_id <> '190678000284' and school_id <> '191269000525'
		 and school_id <> '190786000104' and school_id <> '190786000761' and school_id <> '190786000388'
		 and school_id <> '190786000389' and school_id <> '190786002113' and school_id <> '190786000387'
		 and school_id <> '190786000391' and school_id <> '190945000600' and school_id <> '193135001830'
		 and school_id <> '190960000631' and school_id <> '190960000629' and school_id <> '193096000331'
		 and school_id <> '190468001436' and school_id <> '191071000673' and school_id <> '192316001403'
		 and school_id <> '192211002034' and school_id <> '190627000214' and school_id <> '193192001861'
		 and school_id <> '191518000913' and school_id <> '191266001401' and school_id <> '192412001405'
		 and school_id <> '192901001671' and school_id <> '191041000665' and school_id <> '192067001230'
		 and school_id <> '192238001338' and school_id <> '192112001888' and school_id <> '192112001267'
		 and school_id <> '192667001551' and school_id <> '192541001452' and school_id <> '191488000912'
		 and school_id <> '190322001938' and school_id <> '190322001937' and school_id <> '191332000805'
		 and school_id <> '191152000702' and school_id <> '192415001409' and school_id <> '191034001433'
		 and school_id <> '190792000394' and school_id <> '170942000548' and school_id <> '240021001349'
		 and school_id <> '240051000865' and school_id <> '240051001067' and school_id <> '240015001344'
		 and school_id <> '231110000406' and school_id <> '231478200246' and school_id <> '231101000176'
		 and school_id <> '230828000226' and school_id <> '231167001010' and school_id <> '261119008022'
		 and school_id <> '270819004415' and school_id <> '270001203287' and school_id <> '270001202262'
		 and school_id <> '270001203292' and school_id <> '270001203290' and school_id <> '270001203295'
		 and school_id <> '270001203296' and school_id <> '270001203294' and school_id <> '270001202263'
		 and school_id <> '270001203289' and school_id <> '690003000004' and school_id <> '690003000007'
		 and school_id <> '690003000047' and school_id <> '690003000046' and school_id <> '690003000006'
		 and school_id <> '690003000018' and school_id <> '370420003231' and school_id <> '370387001548'
		 and school_id <> '370342003005' and school_id <> '370108002374' and school_id <> '370268002875'
		 and school_id <> '370177000734' and school_id <> '370472002805' and school_id <> '370297001291'
		 and school_id <> '370225000973' and school_id <> '370204000911' and school_id <> '370225000968'
		 and school_id <> '317802001674' and school_id <> '390479003035' and school_id <> '390494303589'
		 and school_id <> '390472102804' and school_id <> '390472102803' and school_id <> '390021104735'
		 and school_id <> '390029104828' and school_id <> '390472002801' and school_id <> '390472002800'
		 and school_id <> '390467802652' and school_id <> '390467802652' and school_id <> '390442905450'
		 and school_id <> '391000901626' and school_id <> '390451002014' and school_id <> '390465202586'
		 and school_id <> '390465205594' and school_id <> '390465202582' and school_id <> '390029704834'
		 and school_id <> '390132605397' and school_id <> '390494603606' and school_id <> '390494603605'
		 and school_id <> '390050805218' and school_id <> '390001901514' and school_id <> '390047805037'
		 and school_id <> '390052305233' and school_id <> '390141805616' and school_id <> '390052505235'
		 and school_id <> '390465102581' and school_id <> '390465102578' and school_id <> '390465102580'
		 and school_id <> '390446101483' and school_id <> '390494403592' and school_id <> '410883000081'
		 and school_id <> '410883001584' and school_id <> '410883001686' and school_id <> '410883001716'
		 and school_id <> '410883000094' and school_id <> '440114000313' and school_id <> '440021000355'
		 and school_id <> '467830000012' and school_id <> '467830000016' and school_id <> '463049000647'
		 and school_id <> '463049000630' and school_id <> '460004601164' and school_id <> '461785000163'
		 and school_id <> '460004200939' and school_id <> '460004200656' and school_id <> '466518000568'
		 and school_id <> '466518000933' and school_id <> '468043701249' and school_id <> '467746000732'
		 and school_id <> '466546001273' and school_id <> '550852003356' and school_id <> '540162001427');





alter table fabric.master
	drop column if exists cci;
alter table fabric.master
	add column cci int;

update fabric.master
	set cci = cci1;
update fabric.master
	set cci = cciIA where cci is null;
update fabric.master
	set cci = cciSD where cci is null;


--OHIO
-----check matches
select count(*)
from fabric.master, fabric.oh_ind
where master.school_name = upper(oh_ind.building_name)
	and lstate = 'OH';


-----add fiber column 
alter table fabric.master
	drop column if exists oh_ind;
alter table fabric.master
	add column oh_ind int;

with new_values as(
select building_name, fiber as oh_fiber
from fabric.oh_ind
)
update fabric.master
	set oh_ind = new_values.oh_fiber
	from new_values
	where master.school_name = upper(new_values.building_name)
	and master.lstate = 'OH';

--H&B Cable
alter table fabric.master
	drop column if exists hb_cable;
alter table fabric.master
	add column hb_cable int;

update fabric.master
	set hb_cable = 0 
	where lstate = 'KS';
update fabric.master
	set hb_cable = 1
	where school_id = '200034901970' or school_id = '200034902028' or school_id = '200034901992'
		or school_id = '200582000731' or school_id = '200582000732' or school_id = '200582000733'
		or school_id = '200465000912' or school_id = '200465000914' or school_id = '200465000913';
	
--Fat Beam
alter table fabric.master
	drop column if exists fatbeam;
alter table fabric.master
	add column fatbeam int;

update fabric.master
	set fatbeam = 1
	where leaid = '5301140' or leaid = '5303510' or leaid = '5304950' or leaid = '5308670' or leaid = '5310110'
		or leaid = '3005280' or leaid = '3005310' or leaid = '1600780' or leaid = '5305370' or leaid = '5302940'
		or leaid = '1602670';

--Georgia
alter table fabric.master
	drop column if exists ga_ind;
alter table fabric.master
	add column ga_ind int;

with new_values as(
select school_name, city, fiber AS ga_fiber
from fabric.ga_ind
)
update fabric.master
set ga_ind = new_values.ga_fiber
from new_values
where master.school_name = upper(new_values.school_name)
	and lcity = upper(new_values.city)
	and lstate = 'GA';

--BIE
alter table fabric.master
	drop column if exists bie_ind;
alter table fabric.master
	add column bie_ind int;

with new_values as(
select school_code, fiber AS bie_fiber
from fabric.bie_ind
)
update fabric.master
set bie_ind = new_values.bie_fiber
from new_values
where master.seasch = new_values.school_code;

--Zayo
alter table fabric.master
	drop column if exists zayo_ind;
alter table fabric.master
	add column zayo_ind int;

with new_values as(
select street_address, city, state, fiber AS zayo_fiber
from fabric.zayo
)
update fabric.master
set zayo_ind = new_values.zayo_fiber
from new_values
where master.lstreet = upper(new_values.street_address)
	and master.lcity = upper(new_values.city)
	and master.lstate = upper(new_values.state);

--ARIZONA
alter table fabric.master
	drop column if exists az_ind;
alter table fabric.master
	add column az_ind int;

update fabric.master
	set az_ind = 1
	where lea_name = 'NOGALES UNIFIED DISTRICT'
		and lstate = 'AZ';

--PUERTO RICO
select *
from fabric.master, fabric.pr_ind
where seasch = school_code
	and lstate = 'PR';

alter table fabric.master
	drop column if exists pr_ind;
alter table fabric.master
	add column pr_ind int;

with new_values as(
select school_code, fiber
from fabric.pr_ind
)
update fabric.master
set pr_ind = new_values.fiber
from new_values
where seasch = new_values.school_code
	and lstate = 'PR';

------------------------------------------------------
----MAXIMUM VALUE
alter table fabric.master
	drop column if exists max_val;
alter table fabric.master
	add column max_val int;
update fabric.master
	set max_val = greatest(cai,verizon,navajo,ca_hsn,fl_ind,wv_ind,nc_ind,nm_ind,me_ind,nj_ind,tx_ind,mt_ind,sunesys,cci,oh_ind,hb_cable,fatbeam,ga_ind,bie_ind,zayo_ind,pr_ind);
select max_val, count(*)
	from fabric.master
	group by max_val
	order by max_val;


----FIBER SCORE (FOR APRIL 15 MAP)
alter table fabric.master
	drop column if exists fiber;
alter table fabric.master
	add column fiber boolean;
update fabric.master
	set fiber = 'yes'
	where ca_hsn = 1 or fl_ind = 1 or nj_ind = 1 or wv_ind = 1 or nc_ind = 1 or nm_ind = 1 or me_ind = 1 or tx_ind = 1 or mt_ind = 1
		or navajo = 1;
update fabric.master
	set fiber = 'no'
	where ca_hsn = -1 or fl_ind = -1 or nj_ind = -1 or wv_ind = -1 or nc_ind = -1 or nm_ind = -1 or me_ind = -1 or tx_ind = -1
		or mt_ind = -1 or navajo = -1;
update fabric.master
	set fiber = 'yes'
	where cai = 1
		and fiber is null;
update fabric.master
	set fiber = 'no'
	where cai = -1
		and fiber is null;

select fiber, count(*)
	from fabric.master
	group by fiber;

drop table if exists fabric.map_fiber_apr15;
create table fabric.map_fiber_apr15 as(
select school_id, leaid, latitude, longitude, tot_students, geom, fiber 
from fabric.master
);

copy(select * from fabric.map_fiber_apr15) to '/Users/FCC/Documents/allison/data/fabric/map_fiber_apr15.csv' with delimiter '|' CSV header;


----CORROBORATION SCORING 
alter table fabric.master
	drop column if exists score_full;
alter table fabric.master
	add column score_full int;
with new_values as(
select school_id, coalesce(cai,0) + coalesce(verizon,0) + coalesce(navajo,0) + coalesce(ca_hsn,0) + coalesce(fl_ind,0) 
	+ coalesce(wv_ind,0) + coalesce(nc_ind,0) + coalesce(nm_ind,0) + coalesce(me_ind,0) + coalesce(nj_ind,0) 
	+ coalesce(tx_ind,0) + coalesce(mt_ind,0) + coalesce(sunesys,0) + coalesce(cci,0) + coalesce(oh_ind,0)
	+ coalesce(hb_cable,0) + coalesce(fatbeam,0) + coalesce(ga_ind,0) + coalesce(bie_ind,0) + coalesce(zayo_ind,0) 
	+ coalesce(pr_ind,0) as row_score
	from fabric.master
)
update fabric.master
	set score_full=new_values.row_score
	from new_values
	where master.school_id = new_values.school_id;

alter table fabric.master
	drop column if exists score_public;
alter table fabric.master
	add column score_public int;
	with new_values as(
select school_id, coalesce(cai,0) + coalesce(navajo,0) + coalesce(ca_hsn,0) + coalesce(fl_ind,0) 
	+ coalesce(wv_ind,0) + coalesce(nc_ind,0) + coalesce(nm_ind,0) + coalesce(me_ind,0)
	+ coalesce(tx_ind,0) + coalesce(mt_ind,0) + coalesce(sunesys,0) + coalesce(cci,0) + coalesce(oh_ind,0)
	+ coalesce(fatbeam,0) + coalesce(ga_ind,0) + coalesce(bie_ind,0) + coalesce(pr_ind,0) as row_score
	from fabric.master
)
update fabric.master
	set score_public=new_values.row_score
	from new_values
	where master.school_id = new_values.school_id;

	
select score_full, count(*)
	from fabric.master
	group by score_full
	order by score_full;

select score_public, count(*)
	from fabric.master
	group by score_public
	order by score_public;

select lstate, score_full, count(*)
	from fabric.master
	group by lstate, score_full
	order by lstate, score_full;

select lstate, score_public, count(*)
	from fabric.master
	group by lstate, score_public
	order by lstate, score_public;

----SOURCE COUNTS
select cai, count(*) from fabric.master group by cai;
select verizon, count(*) from fabric.master group by verizon;
select ca_hsn, count(*) from fabric.master group by ca_hsn;
select fl_ind, count(*) from fabric.master group by fl_ind;
select nj_ind, count(*) from fabric.master group by nj_ind;
select wv_ind, count(*) from fabric.master group by wv_ind;
select nc_ind, count(*) from fabric.master group by nc_ind;
select nm_ind, count(*) from fabric.master group by nm_ind;
select me_ind, count(*) from fabric.master group by me_ind;
select tx_ind, count(*) from fabric.master group by tx_ind;
select mt_ind, count(*) from fabric.master group by mt_ind;
select navajo, count(*) from fabric.master group by navajo;
select sunesys, count(*) from fabric.master group by sunesys;
select cci, count(*) from fabric.master group by cci;
select oh_ind, count(*) from fabric.master group by oh_ind;
select fatbeam, count(*) from fabric.master group by fatbeam;
select ga_ind, count(*) from fabric.master group by ga_ind;
select hb_cable, count(*) from fabric.master group by hb_cable;
select bie_ind, count(*) from fabric.master group by bie_ind;
select navajo, bie_ind, count(*) from fabric.master group by navajo, bie_ind;


----PIVOT TABLE
drop table if exists fabric.state_counts_full;

create table fabric.state_counts_full as(
select lstate,
	count(case when score_full = -3 then max_val end) as nofiber_neg3,
	count(case when score_full = -2 then max_val end) as nofiber_neg2,
	count(case when score_full = -1 then max_val end) as nofiber_neg1,
	count(case when score_full = 0 then max_val end) as unknown_0,
	count(case when score_full = 1 then max_val end) as fiber_pos1,
	count(case when score_full = 2 then max_val end) as fiber_pos2,
	count(case when score_full = 3 then max_val end) as fiber_pos3,
	count(case when score_full = 4 then max_val end) as fiber_pos4
	from fabric.master
	group by lstate
	order by lstate
);

drop table if exists fabric.state_counts_full_rurality;

create table fabric.state_counts_full as(
select lstate, l,
	count(case when score_full = -3 then max_val end) as nofiber_neg3,
	count(case when score_full = -2 then max_val end) as nofiber_neg2,
	count(case when score_full = -1 then max_val end) as nofiber_neg1,
	count(case when score_full = 0 then max_val end) as unknown_0,
	count(case when score_full = 1 then max_val end) as fiber_pos1,
	count(case when score_full = 2 then max_val end) as fiber_pos2,
	count(case when score_full = 3 then max_val end) as fiber_pos3,
	count(case when score_full = 4 then max_val end) as fiber_pos4
	from fabric.master
	group by lstate
	order by lstate
);


drop table if exists fabric.state_counts_public;

create table fabric.state_counts_public as(
select lstate,
	count(case when score_public = -3 then max_val end) as nofiber_neg3,
	count(case when score_public = -2 then max_val end) as nofiber_neg2,
	count(case when score_public = -1 then max_val end) as nofiber_neg1,
	count(case when score_public = 0 then max_val end) as unknown_0,
	count(case when score_public = 1 then max_val end) as fiber_pos1,
	count(case when score_public = 2 then max_val end) as fiber_pos2,
	count(case when score_public = 3 then max_val end) as fiber_pos3,
	count(case when score_public = 4 then max_val end) as fiber_pos4
	from fabric.master
	group by lstate
	order by lstate
);

----CREATE DUMMY FOR GREATER THAN 100 and 100 STUDENTS OR LESS
alter table fabric.master
	add column gt_100 int;

update fabric.master
	set gt_100 = 0
	where tot_students <= 100;
update fabric.master
	set gt_100 = 1
	where tot_students > 100;

----NATIONAL COUNTS
drop table if exists fabric.national_counts_full;

create table fabric.national_counts_full as(
select gt_100,
	count(case when score_full < 0 then max_val end) as nofiber,
	count(case when score_full = 0 then max_val end) as unk,
	count(case when score_full > 0 then max_val end) as fiber
	from fabric.master
	group by gt_100
	order by gt_100
);

drop table if exists fabric.national_counts_full_rurality;

create table fabric.national_counts_full_rurality as(
select gt_100, school_loc,
	count(case when score_full < 0 then max_val end) as nofiber,
	count(case when score_full = 0 then max_val end) as unk,
	count(case when score_full > 0 then max_val end) as fiber
	from fabric.master
	group by gt_100, school_loc
	order by gt_100, school_loc
);

drop table if exists fabric.national_counts_public;

create table fabric.national_counts_public as(
select gt_100,
	count(case when score_public < 0 then max_val end) as nofiber,
	count(case when score_public = 0 then max_val end) as unk,
	count(case when score_public > 0 then max_val end) as fiber
	from fabric.master
	group by gt_100
	order by gt_100
);

drop table if exists fabric.national_counts_public_rurality;

create table fabric.national_counts_public_rurality as(
select gt_100, school_loc,
	count(case when score_public < 0 then max_val end) as nofiber,
	count(case when score_public = 0 then max_val end) as unk,
	count(case when score_public > 0 then max_val end) as fiber
	from fabric.master
	group by gt_100, school_loc
	order by gt_100, school_loc
);


----STATE COUNTS
drop table if exists fabric.state_counts_summary_full;

create table fabric.state_counts_summary_full as(
select lstate,
	count(case when score_full < 0 then max_val end) as nofiber,
	count(case when score_full = 0 then max_val end) as unk,
	count(case when score_full > 0 then max_val end) as fiber
	from fabric.master
	group by lstate
	order by lstate
);

drop table if exists fabric.state_counts_summary_public;

create table fabric.state_counts_summary_public as(
select lstate,
	count(case when score_public < 0 then max_val end) as nofiber,
	count(case when score_public = 0 then max_val end) as unk,
	count(case when score_public > 0 then max_val end) as fiber
	from fabric.master
	group by lstate
	order by lstate
);

---EXPORT FILE
COPY (SELECT * FROM fabric.master) to '/Users/FCC/Documents/allison/data/fabric/master.csv' with delimiter '|' CSV header;
COPY (SELECT * FROM fabric.state_counts_full) to '/Users/FCC/Documents/allison/data/fabric/counts_full.csv' with delimiter '|' CSV header;
COPY (SELECT * FROM fabric.state_counts_public) to '/Users/FCC/Documents/allison/data/fabric/counts_public.csv' with delimiter '|' CSV header;
COPY (SELECT * FROM fabric.state_counts_summary_full) to '/Users/FCC/Documents/allison/data/fabric/counts_state_full.csv' with delimiter '|' CSV header;
COPY (SELECT * FROM fabric.state_counts_summary_public) to '/Users/FCC/Documents/allison/data/fabric/counts_state_public.csv' with delimiter '|' CSV header;
