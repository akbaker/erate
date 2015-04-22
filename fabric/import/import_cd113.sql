--CREATE TABLE
DROP TABLE IF EXISTS census2010.cd113;
CREATE TABLE census2010.cd113
(
	gid int,
	statefp character varying(2),
	cd113fp character varying(2),
	geoid character varying(7),
	namelsad character varying(41),
	lsad character varying(2),
	cdsessn character varying(3),
	mtfcc character varying(5),
	funcstat character varying(1),
	aland double precision,
	awater double precision, 
	intptlat character varying(11),
	intptlon character varying(12),
	geom geometry
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE census2010.cd113
  OWNER TO postgres;

COPY census2010.cd113
	FROM '/Users/FCC/Documents/allison/E-rate analysis/Data/Census/congressional_districts.csv'
	CSV HEADER DELIMITER '|';