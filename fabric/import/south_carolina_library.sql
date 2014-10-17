drop table if exists fabric.sc_lib;
CREATE TABLE fabric.sc_lib
(
	institution_cat character varying(1),
	site_type character varying(10),
	service_type character varying(30),
	cxn_tech character varying(5),
	tech_cat int,
	lease_own character varying(7),
	lib_name character varying(100),
	id character varying(6),
	fscs_id character varying(10),
	library_sys character varying(100),
	usac_entity_num character varying(10),
	institution_name character varying(200),
	physical_address character varying(200),
	city character varying(100),
	zip character varying(5),
	adv_up character varying(7),
	ad_down character varying(7),
	notes character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.sc_lib
  OWNER TO postgres;

copy fabric.sc_lib
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/SC/FCC E-Rate Fiber Map Refresh September 2014 SC Public Libraries.csv'
	csv header delimiter ',';