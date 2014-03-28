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
