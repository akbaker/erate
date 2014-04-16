drop table if exists fabric.oh_ind;
CREATE TABLE fabric.oh_ind
(
	customer_name character varying(50),
	district_irn character(6),
	building_name character varying(50),
	building_irn character(6), 
	building_address character varying(200),
	building_city character varying(50),
	building_zip character(15),
	oeds_status character varying(10),
	speed character varying(100),
	restrict_smry character varying(20),
	other_speed character varying(50),
	provider character varying(20),
	connect_dist_bldg character varying(50),
	isp_support character varying(100),
	itc_support character varying(50)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.oh_ind
  OWNER TO postgres;

set client_encoding to latin1;
copy fabric.oh_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/OH/Rstrctd_bldgs_032814.csv' 
	csv header delimiter ',';

