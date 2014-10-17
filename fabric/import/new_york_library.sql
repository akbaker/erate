drop table if exists fabric.ny_lib;
CREATE TABLE fabric.ny_lib
(
	fscs character varying(6),
	lib_name character varying(100),
	branch_name character varying(100),
	address character varying(100),
	city character varying(50),
	zip1 character varying(5),
	cxn_type character varying(10),
	download_speed character varying(200),
	it_contact character varying(100),
	it_phone character varying(15),
	it_email character varying(100)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ny_lib
  OWNER TO postgres;

copy fabric.ny_lib
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/NY/NYS Library Buildings with Fiber Connections_1.csv'
	csv header delimiter ',';