drop table if exists fabric.mo_lib;
CREATE TABLE fabric.mo_lib
(
	loc_type character varying(10),
	site_id character varying(5),
	org_name character varying(50),
	site_name character varying(100),
	fcc_entity_no character varying(10),
	mb11_12 double precision,
	mrc11_12 double precision,
	mb12_13 double precision,
	mrc12_13 double precision,
	mb13_14 double precision,
	mrc13_14 double precision
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.mo_lib
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy fabric.mo_lib
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/MO/FCC bw trend request.csv'
	csv header delimiter ',';
