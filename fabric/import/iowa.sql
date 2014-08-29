drop table if exists fabric.ia_ind;
CREATE TABLE fabric.ia_ind
(
	nces_school_id character varying(12),
	state_school_id character varying(10),
	nces_district_id character varying(7),
	state_district_id character varying(10),
	low_grade character varying(2),
	high_grade character varying(2),
	school_name character varying(100),
	district character varying(100),
	part_iii_site character varying(100),
	part_iii_address1 character varying(100),
	part_iii_address2 character varying(100),
	vendor_name character varying(100),
	connection_type character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ia_ind
  OWNER TO postgres;

copy fabric.ia_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/IA/ICN Part III Connections - August 2014.csv'
	csv header delimiter ',';

select count(*)
from fabric.ia_ind
where length(nces_school_id) = 11;