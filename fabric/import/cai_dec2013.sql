drop table if exists analysis.cai_dec2013;
CREATE TABLE analysis.cai_dec2013
(
	id character varying(10),
	anchorname character varying(200),
	address character varying(150),
	bldgnbr character varying(10),
	predir character varying(10),
	streetname character varying(100),
	streettype character varying(50),
	suffdir character varying(50),
	city character varying(50),
	statecode character varying(2),
	zip5 character varying(5),
	zip4 character varying(4),
	latitude double precision,
	longitude double precision,
	caicat int,
	bbservice character varying(2),
	publicwifi character varying(2),
	url character varying(100),
	transtech int,
	fullfipsid character varying(15),
	caiid character varying(50),
	maxaddown character varying(2),
	maxadup character varying(2),
	objectid character varying(50)
)
WITH (
  OIDS=FALSE
);

copy analysis.cai_dec2013
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/CAI/All-NBM-CAI-December-2013/BBMap_CAI_Dec2013.csv'
	csv header delimiter '|';
