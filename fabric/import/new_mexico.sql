drop table if exists fabric.nm_ind;
CREATE TABLE fabric.nm_ind
(
	district_name character varying(50),
	school_name character varying(50),
	orgcode character(6),
	nces_id character(12),
	median_bandw float,
	perstud_median_band float,
	num_tests int,
	student_count int,
	tot_devices int,
	parcc_compt int,
	stu_comp_ratio float,
	comp_needed int,
	effective_bandw float,
	bw_thres float,
	cbt_bonus character varying(20)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.nm_ind
  OWNER TO postgres;

copy fabric.nm_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/NM/nm_tech_readiness_v4.csv'
	csv header delimiter ',';
