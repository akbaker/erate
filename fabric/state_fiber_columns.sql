--CA K-12 HSN
alter table fabric.cenic
	drop column if exists fiber;
alter table fabric.cenic
	add column fiber int;
update fabric.cenic
	set fiber = -1
	where connection_type <> 'Carrier Ethernet (e.g. - OptiMan, MetroEthernet)'  and
		connection_type <> 'Private Fiber' and connection_type <> 'Shared Private Fiber';
update fabric.cenic
	set fiber = 1
	where connection_type = 'Carrier Ethernet (e.g. - OptiMan, MetroEthernet)' 
		and (connection_speed = '100Mbs' or connection_speed = '10Gbps' or connection_speed = '155Mbs'
		or connection_speed = '1Gbs' or connection_speed = '> 100Mbs < 155 Mbs' or connection_speed = '> 10Gbps'
		or connection_speed =  '> 155 Mbs < 1Gbs' or connection_speed = '> 1Gbs < 10Gbps');
update fabric.cenic
	set fiber = 1
	where connection_type = 'Private Fiber' or connection_type = 'Shared Private Fiber';
update fabric.cenic
	set fiber = 0
	where fiber is null;

select fiber, count(*) from fabric.cenic group by fiber;

--FLORIDA
alter table analysis.nces_pub_full
	add column stid_fl character(2);
update analysis.nces_pub_full
	set stid_fl = '0' || stid
	from fabric.fl_ind
	where char_length(stid) = 1
	and lstate = 'FL';
update analysis.nces_pub_full
	set stid_fl = stid
	from fabric.fl_ind
	where char_length(stid) = 2
	and lstate = 'FL';
alter table analysis.nces_pub_full
	add column sea_fl character(4);
update analysis.nces_pub_full
	set sea_fl = '000' || seasch
	where char_length(seasch) = 1
	and lstate = 'FL';
update analysis.nces_pub_full
	set sea_fl = '00' || seasch
	where char_length(seasch) = 2
	and lstate = 'FL';
update analysis.nces_pub_full
	set sea_fl = '0' || seasch
	where char_length(seasch) = 3
	and lstate  = 'FL';
alter table analysis.nces_pub_full
	add column school_code_fl character(7);
update analysis.nces_pub_full
	set school_code_fl = stid_fl || ' ' || sea_fl;

alter table fabric.fl_ind
	drop column if exists fiber;
alter table fabric.fl_ind
	add column fiber int;
update fabric.fl_ind
	set fiber = 1
	where cxn_fiber > 0;
update fabric.fl_ind
	set fiber = -1
	where cxn_fiber = 0;
update fabric.fl_ind
	set fiber = 0
	where cxn_fiber is null;

select fiber, count(*) from fabric.fl_ind group by fiber;

--NEW JERSEY
alter table analysis.nces_pub_full
	add column stid_nj character(6);
alter table analysis.nces_pub_full
	add column seasch_nj character(3);
update analysis.nces_pub_full
	set stid_nj = stid
	where char_length(stid) = 6
	and lstate = 'NJ';
update analysis.nces_pub_full
	set stid_nj = '0' || stid
	where char_length(stid) = 5
	and lstate = 'NJ';
update analysis.nces_pub_full
	set seasch_nj = seasch
	where char_length(seasch) = 3
	and lstate = 'NJ';
update analysis.nces_pub_full
	set seasch_nj = '0' || seasch
	where char_length(seasch) = 2
	and lstate = 'NJ';
alter table analysis.nces_pub_full
	add column school_code_nj character(9);
update analysis.nces_pub_full
	set school_code_nj = stid_nj || seasch_nj;


alter table fabric.nj_ind
	drop column if exists fiber;
alter table fabric.nj_ind
	add column fiber int;
update fabric.nj_ind
	set fiber = 1
	where internet_speed >= 100;
update fabric.nj_ind
	set fiber = 0
	where internet_speed < 100;

select fiber, count(*) from fabric.nj_ind group by fiber;

--WEST VIRGINIA
alter table fabric.wv_ind
	add column wv_school_id character(5);
update fabric.wv_ind
	set wv_school_id = county_number || school_number;

alter table fabric.wv_ind
	drop column if exists fiber;
alter table fabric.wv_ind
	add column fiber int;
update fabric.wv_ind
	set fiber = 1
	where fiber_ind = 'Y';
update fabric.wv_ind
	set fiber = -1
	where fiber_ind = 'N';
update fabric.wv_ind
	set fiber = 0
	where fiber_ind is null;

--NEW MEXICO
select effective_bandw from fabric.nm_ind;

alter table fabric.nm_ind
	drop column if exists fiber;
alter table fabric.nm_ind
	add column fiber int;
update fabric.nm_ind
	set fiber = 1
	where effective_bandw >= 100;
update fabric.nm_ind
	set fiber = 0
	where effective_bandw < 100;

--MAINE
alter table fabric.me_ind
	drop column if exists fiber;
alter table fabric.me_ind
	add column fiber int;
update fabric.me_ind
	set fiber = 1
	where cai_type = 'K12' and (cxn_type = 'FIBER' or cxn_type = 'DARK FIBER');
update fabric.me_ind
	set fiber = -1
	where cai_type = 'K12' and (cxn_type <> 'FIBER' or cxn_type <> 'DARK FIBER');
update fabric.me_ind
	set fiber = 0
	where fiber is null;

select fiber, count(*) from fabric.me_ind group by fiber;

--NAVAJO SCHOOLS
alter table fabric.navajo_schools
	drop column if exists fiber;
alter table fabric.navajo_schools
	add column fiber int;
update fabric.navajo_schools
	set fiber = -1;

--MONTANA
alter table fabric.mt_ind
	add column state character(2);
update fabric.mt_ind
	set state = 'MT';
alter table fabric.mt_ind
	drop column if exists fiber;
alter table fabric.mt_ind
	add column fiber int;
update fabric.mt_ind
	set fiber = 1 
	where max_mbps >= 100;
update fabric.mt_ind
	set fiber = 0 
	where max_mbps < 100;

--SUNESYS
alter table fabric.sunesys
	add column rev_appname character varying(50);
update fabric.sunesys
	set rev_appname = appname;
--For CA
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCH DIST', '')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', '')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCH DISTRICT', '')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DIST', '')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'ELEM', 'ELEMENTARY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'UNIF', 'UNIFIED')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'UN ', 'UNIFIED')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'H S', 'HIGH')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'ALBANY', 'ALBANY CITY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'CAMBRIAN ELEM SCHOOL DISTRICT', 'CAMBRIAN')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'UN H S DIST', 'UNION HIGH')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'UN ', 'UNION ')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'CUCAMONGA SCHOOL DISTRICT', 'CUCAMONGA ELEMENTARY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'HAWTHORNE ELEMENTARY', 'HAWTHORNE')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'LENNOX ELEMENTARY', 'LENNOX')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'LUTHER BURBANK ELEMENTARY', 'LUTHER BURBANK')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'MORELAND SCHOOL', 'MORELAND ELEMENTARY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'MOUNT', 'MT.')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'NUVIEW UNION ELEMENTARY', 'NUVIEW UNION')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'ONTARIO-MONTCLAIR', 'ONTARIO-MONTCLAIR ELEMENTARY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'PALMDALE', 'PALMDALE ELEMENTARY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'REDWOOD CITY', 'REDWOOD CITY ELEMENTARY')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'CO ', 'COUNTY ')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'EDUC', 'EDUCATION')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'STOCKTON CITY', 'STOCKTON')
	where appstate = 'CA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'TRACY', 'TRACY JOINT')
	where appstate = 'CA';
--For FL
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT OF VOLUSIA COUNTY', 'VOLUSIA')
	where appstate = 'FL';
--For GA
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL SYSTEM', '')
	where appstate = 'GA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DIST', '')
	where appstate = 'GA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', '')
	where appstate = 'GA';
--For IL
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', 'SD')
	where appstate = 'IL';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'TOWNSHIP HIGH SCHOOL', 'TWP HSD 202')
	where appstate = 'IL';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'H S DIST', 'HSD')
	where appstate = 'IL';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'CUD60', 'CUSD 60')
	where appstate = 'IL';
--For MD
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', 'PUBLIC SCHOOLS')
	where appstate = 'MD';
--For NJ
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'BOUND BROOK', 'BOUND BROOK BOROUGH')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'HILLSIDE', 'HILLSIDE TOWNSHIP')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'HUNTERDON CTL REG', 'HUNTERDON CENTRAL REGIONA')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'TWP', 'TOWNSHIP')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'VLY', 'VALLEY')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'REG', 'REGIONAL')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', '')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DIST', '')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'HGH SCH DIST', '')
	where appstate = 'NJ';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'PUBLIC SCHOOLS', '')
	where appstate = 'NJ';
--For OH
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCH DIST', '')
	where appstate = 'OH';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', '')
	where appstate = 'OH';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DIST', '')
	where appstate = 'OH';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'TRI RIVERS', 'TRI-RIVERS')
	where appstate = 'OH';
--For PA
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCH DIST', 'SD')
	where appstate = 'PA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DISTRICT', 'SD')
	where appstate = 'PA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCH DISTRICT', 'SD')
	where appstate = 'PA';
update fabric.sunesys
	set rev_appname = replace(rev_appname, 'SCHOOL DIST', 'SD')
	where appstate = 'PA';

update fabric.sunesys
	set rev_appname = trim(both from rev_appname);

alter table fabric.sunesys
	drop column if exists fiber;
alter table fabric.sunesys
	add column fiber int;
update fabric.sunesys
	set fiber = 1;
	

--CCI DATA
select planned_speed_tier, count(*)
from analysis.nces_pub_full, fabric.cci
where nces_pub_full.school_name = upper(cci.org_name)
	and nces_pub_full.lstate = cci.state
	and nces_pub_full.lcity = upper(cci.city)
	and cai_type = 'Schools (K-12)'
group by planned_speed_tier;

--**See CCI Mod file**

alter table fabric.cci
	add column fiber int;
update fabric.cci
	set fiber = 1
	where planned_speed_tier = '>=1 Gb'
		or planned_speed_tier = '>= 100 Mb and < 1 Gb'
		or planned_speed_tier = '>= 1 Gb';
update fabric.cci
	set fiber = 0
	where fiber is null;

--OHIO DATA
select count(*)
from fabric.master, fabric.oh_ind
where master.school_name = upper(oh_ind.building_name)
	and lstate = 'OH';

alter table fabric.oh_ind
	add column fiber int;
update fabric.oh_ind
	set fiber = 1
	where speed = '50mbs Ethernet';
update fabric.oh_ind
	set fiber = 0
	where speed = 'Ethernet Other';
update fabric.oh_ind
	set fiber = -1
	where speed = '10mbs Ethernet';
update fabric.oh_ind
	set fiber = -1
	where speed = '20mbs Ethernet';
update fabric.oh_ind
	set fiber = -1
	where speed = 'T1 äóñ 1.54mbs';
update fabric.oh_ind
	set fiber = -1
	where speed = 'Wireless Other';
update fabric.oh_ind
	set fiber = -1
	where speed = 'Wireless 45mbs';
update fabric.oh_ind
	set fiber = -1
	where speed = 'Cable Modem';
update fabric.oh_ind
	set fiber = -1
	where speed = '30mbs Ethernet';
update fabric.oh_ind
	set fiber = -1
	where speed = '2mbs Business Class';
update fabric.oh_ind
	set fiber = -1
	where speed = 'DSL';

--GEORGIA
select *
from analysis.nces_pub_full, fabric.ga_ind
where nces_pub_full.school_name = upper(ga_ind.school_name)
	and lcity = upper(city)
	and lstate = 'GA';

alter table fabric.ga_ind
	add column fiber int;
update fabric.ga_ind
	set fiber = -1
	where has_fiber = 'No';
update fabric.ga_ind
	set fiber = 1
	where has_fiber = 'Yes' or has_fiber = 'yes';

--BIE
select *
from fabric.master, fabric.bie_ind
where master.seasch = bie_ind.school_code;

alter table fabric.bie_ind
	add column fiber int;
update fabric.bie_ind
	set fiber = -1;

--Zayo
select *
from fabric.master, fabric.zayo
where upper(master.lstreet) = upper(zayo.street_address)
	and upper(master.lcity) = upper(zayo.city)
	and upper(master.lstate) = upper(zayo.state);

alter table fabric.zayo
	add column fiber int;
update fabric.zayo
	set fiber = 1;