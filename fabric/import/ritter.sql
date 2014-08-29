drop table if exists fabric.ritter;
CREATE TABLE fabric.ritter
(
	nces_id character varying(12),
	school character varying(100),
	company character varying(50),
	fiber character varying(1),
	notes character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ritter
  OWNER TO postgres;

copy fabric.ritter
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/Ritter fiber in schools.csv'
	csv header delimiter ',';

update fabric.ritter
set nces_id = '0' || nces_id
where length(nces_id) = 11;