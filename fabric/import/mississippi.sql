drop table if exists fabric.ms_ind;
CREATE TABLE fabric.ms_ind
(
	id int,
	district character varying(100),
	school character varying(100),
	connection_tech character varying(50),
	adv_speed float
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ms_ind
  OWNER TO postgres;

copy fabric.ms_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/MS/MSdata092220140950.csv'
	csv header delimiter ',';