drop table if exists fabric.oh_lib;
CREATE TABLE fabric.oh_lib
(
	ben character varying(8),
	library_name character varying(100),
	fscs character varying(6),
	fcc_no character varying(8),
	county character varying(20),
	zip character varying(10),
	school_district character varying(50),
	urban character varying(1),
	rural character varying(1),
	student_count int,
	free_reduc_count int,
	conn_type character varying(50),
	quantity int,
	bandwidth float,
	monthly_cost money,
	cipa character varying(10),
	borrowers int,
	bldgs int,
	computers int,
	bandwidth_portion float
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.oh_lib
  OWNER TO postgres;

copy fabric.oh_lib
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/OH/OPLIN FY2012 FRN 2300412 Data.csv'
	csv header delimiter ',';