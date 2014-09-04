drop table if exists fabric.its;
CREATE TABLE fabric.its
(
	school_name character varying(100),
	street character varying(100),
	city character varying(50),
	state character varying(2),
	zip_code character varying(5),
	wan character varying(10),
	nces_id character varying(12)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.its
  OWNER TO postgres;

copy fabric.its
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/AL/FCC School Fiber locations ITS.csv'
	csv header delimiter ',';