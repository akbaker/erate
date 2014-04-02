drop table if exists fabric.mt_ind;
CREATE TABLE fabric.mt_ind
(
	school_name character varying(50),
	district_name character varying(50),
	school_level character varying(20),
	students int,
	max_mbps float,
	num_tests int
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.mt_ind
  OWNER TO postgres;

copy fabric.mt_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/MT/SchoolSpeedTestMonthFinalReportDataFile.csv'
	csv header delimiter ',';
