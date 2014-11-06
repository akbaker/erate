drop table if exists fabric.al_ind;
CREATE TABLE fabric.al_ind
(
	system_no int,
	school_no character varying(5),
	system_name character varying(100),
	school_name character varying(150),
	nces_id character varying(12),
	cxn_tech character varying(20),
	adv_speed float,
	address character varying(100),
	city character varying(100),
	state character varying(2),
	zip character varying(10),
	lat double precision,
	lon double precision
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.al_ind
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.al_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/AL/AL_Schools_WANData2_v2.csv' 
	csv header delimiter ',';

