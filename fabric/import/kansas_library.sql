drop table if exists fabric.ks_lib;
CREATE TABLE fabric.ks_lib
(
	library_name character varying(100),
	county character varying(50),
	num_computers int,
	population character varying(10),
	download_speed double precision,
	upload_speed double precision,
	cxn_type character varying(3),
	empty character varying (3)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ks_lib
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy fabric.ks_lib
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/KS/Copy of Broadband Speeds in Libraries 2012.csv'
	csv header delimiter ',';
