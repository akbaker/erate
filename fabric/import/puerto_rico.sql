drop table if exists fabric.pr_ind;
CREATE TABLE fabric.pr_ind
(
	school_code character varying(5),          
	school_name character varying(100),
	region character varying(40),
	district_name character varying(40),
	town character varying(40),
	status character varying(40),
	address character varying(150),
	telephone1 character varying(30),
	telephone2 character varying(30),
	physical_cxn character varying(100),
	service character varying(20),
	current_bandwidth character varying(50),
	monthly_cost money,
	installation_cost money,
	purpose character varying(120),
	service_provider character varying(50)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.pr_ind
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.pr_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/PR/Puerto Rico Schools Type of Connectivity-Existing & Proposed Contract-FCC Rprt_6-12-2014.csv'
	csv header delimiter ',';