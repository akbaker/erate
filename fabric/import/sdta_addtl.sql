drop table if exists fabric.sdta_addtl;
CREATE TABLE fabric.sdta_addtl
(
	sort_code int,
	nces_id character varying(12),
	sort_type character varying(100),
	district_name character varying(100),
	school_name character varying(100),
	service_provider character varying(50),
	facility character varying(10),
	maddress character varying(150),
	mcity character varying(50),
	mstate character varying(2),
	mzip character varying(10),
	school_address character varying(150),
	school_city character varying(50), 
	school_state character varying(2),
	school_zip character varying(10)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.sdta_addtl
  OWNER TO postgres;

copy fabric.sdta_addtl
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/SD/Additional South Dakota School Fiber Connectivity Information Nov 2014.csv'
	csv header delimiter ',';