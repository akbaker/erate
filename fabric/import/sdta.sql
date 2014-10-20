drop table if exists fabric.sdta;
CREATE TABLE fabric.sdta
(
	sort_code int,
	entity_type character varying(100),
	district_name character varying(100),
	school_name character varying(100),
	service_provider character varying(50),
	facility character varying(10),
	maddress character varying(150),
	mcity character varying(50),
	mstate character varying(2),
	mzip character varying(5),
	school_address character varying(150),
	school_city character varying(50), 
	school_state character varying(2),
	school_zip character varying(5),
	nces_id character varying(12)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.sdta
  OWNER TO postgres;

copy fabric.sdta
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/SD/SDTA Member School Connections Information.csv'
	csv header delimiter ',';