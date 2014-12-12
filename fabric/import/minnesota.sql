drop table if exists fabric.mn_ind;
CREATE TABLE fabric.mn_ind
(
	nces_sch_id character varying(12),
	cxn_tech character varying(15),
	available_bw character varying(15)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.mn_ind
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.mn_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/MN/NW Links Area Schools Summary Response.csv' 
	csv header delimiter ',';

