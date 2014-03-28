drop table if exists fabric.me_ind;
CREATE TABLE fabric.me_ind
(
	site_id character varying(5),
	entity_type character varying(2),
	district_id character varying(5),
	site_name character varying(100),
	cai_type character varying(20),
	address character varying(50),
	city character varying(20),
	state character(2),
	zip character varying(10),
	cxn_type character varying(20),
	capacity int,
	provider character varying(20),
	nces_id character varying(12), 
	fscs_id character varying(10)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.me_ind
  OWNER TO postgres;

copy fabric.me_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/ME/Internet2_PhaseII-rev070813.csv'
	csv header delimiter ',';
