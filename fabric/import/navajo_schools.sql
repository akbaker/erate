drop table if exists fabric.navajo_schools;
CREATE TABLE fabric.navajo_schools
(
	school_name character varying(100),
	state character(2),
	port_speed character varying(50),
	navajo_school character varying(15)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.navajo_schools
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.navajo_schools
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/Dept_Indian_Affairs/Navajo School Bandwidth.csv'
	csv header delimiter ',';

