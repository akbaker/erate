drop table if exists fabric.bie_ind;
CREATE TABLE fabric.bie_ind
(
	elo character varying(50),
	district character varying(50),
	school_code character varying(6),
	school_name character varying(200),
	nces_id character varying(12)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.bie_ind
  OWNER TO postgres;

copy fabric.bie_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/Dept_Indian_Affairs/Bureau of Indian Education Connectivity Data .csv'
	csv header delimiter ',';
