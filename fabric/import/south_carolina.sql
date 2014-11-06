drop table if exists fabric.sc_ind;
CREATE TABLE fabric.sc_ind
(
	service_type character varying(15),
	cxn_tech character varying(10),
	tech_cat int,
	school_district character varying(150),
	location_type character varying(50),
	usac_entity character varying(10),
	inst_name character varying(150),
	address character varying(200),
	nces_id character varying(12),
	zip_code character varying(10),
	state character varying(2),
	lease_own character varying(50),
	adv_down character varying(5),
	adv_up character varying(5),
	shared_cxn character varying(3),
	notes character varying(200)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.sc_ind
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.sc_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/SC/FCC E-Rate Fiber Map Refresh October 30 2014 SC Public Schools AB.csv' 
	csv header delimiter ',';

