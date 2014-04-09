drop table if exists fabric.cci;
CREATE TABLE fabric.cci
(
	award_id character varying(15),
	organization character varying(50),
	org_name character varying(150),
	service_address character varying(100),
	city character varying(50),
	state character(2),
	zip_code character varying(10), 
	lat double precision,
	lon double precision,
	cxn_type character varying(20),
	planned_speed_tier character varying(20),
	cai_type character varying(50)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.cci
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.cci
	from '/Users/FCC/Documents/allison/data/fabric/CCI Data Request.3.17.14.csv' 
	csv header delimiter ',';

