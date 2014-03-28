drop table if exists fabric.fl_ind;
CREATE TABLE fabric.fl_ind
(
	school_code character varying(8),
	schoolname character varying(100),
	num_students int,
	num_teachers int,
	schooltype character varying(50),
	classification character varying(50),
	grades character varying(20),
	dedicated_band character varying(10),
	shared_band character varying(10),
	cxn_fiber int,
	cxn_copper int,
	cxn_wireless int,
	cxn_other character varying(200),
	dist_wan character varying(10),
	thirdparty_isp character varying(10)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.fl_ind
  OWNER TO postgres;

copy fabric.fl_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/FL/ss-prin-state_mod.csv'
	csv header delimiter ',';
