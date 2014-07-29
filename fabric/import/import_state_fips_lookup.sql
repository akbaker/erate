drop table if exists census2010.state_fips_lookup;
CREATE TABLE census2010.state_fips_lookup
(
	state_fips character varying(2),
	state_name character varying(50)
)
WITH (
  OIDS=FALSE
);

copy census2010.state_fips_lookup
	from '/Users/FCC/Documents/allison/data/state_fips_lookup.csv'
	csv header delimiter ',';
