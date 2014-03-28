drop table if exists fabric.ben_nces_xwalk;
CREATE TABLE fabric.ben_nces_xwalk
(
	ben character varying(8),
	nces_id character varying(15),
	location_type character varying(20),
	applicant_name character varying(100),
	street1 character varying(50),
	street2 character varying(50),
	city character varying(50),
	state character(2),
	zip character(5),
	enrollment int,
	site_count int,
	applicant_type character varying(20),
	discount float 
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ben_nces_xwalk
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.ben_nces_xwalk
	from '/Users/FCC/Documents/allison/data/fabric/BEN-to-NCES Master 2013-11-09.csv'
	csv header delimiter ',';
