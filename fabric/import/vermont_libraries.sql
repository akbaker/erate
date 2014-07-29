drop table if exists fabric.vt_lib;
CREATE TABLE fabric.vt_lib
(
	town character varying(50),
	library_name character varying(150),
	address character varying(150),
	city character varying(50),
	zip character varying(5),
	county character varying(50),
	phone character varying(10)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.vt_lib
  OWNER TO postgres;

copy fabric.vt_lib
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/VT/FiberConnect_Library_list.csv'
	csv header delimiter ',';