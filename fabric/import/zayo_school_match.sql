drop table if exists fabric.zayo_school_match;
CREATE TABLE fabric.zayo_school_match
(
	ncessch character varying(12),
	schnam character varying(50),
	level character varying(2),
	bldg_name character varying(10),
	bldg_type character varying(20)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.zayo_school_match
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy fabric.zayo_school_match
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/zayo_school_closest/zayo_school_closest.csv'
	csv header delimiter '|';
