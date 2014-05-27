drop table if exists fabric.imls_cai;
CREATE TABLE fabric.imls_cai
(
	id character varying(10),
	anchorname character varying(50),
	address character varying(100),
	bldgnbr character varying(5),
	predir character varying(10),
	streetname character varying(50),
	streettype character varying(10),
	suffdir character varying(2),
	city character varying(50),
	statecode character varying(2),
	zip5 character varying(5),
	zip4 character varying(4),
	latitude double precision,
	longitude double precision,
	caicat character varying(2),
	bbservice character varying(2),
	publicwifi character varying(2),
	url character varying(50),
	transtech int,
	fullfipsid character varying(15),
	caiid character varying(10),
	maxaddown int,
	maxadup int,
	sbdd_id character varying(15),
	year int,
	month int,
	ds character varying(10),
	fscskey character varying(6),
	fscs_seq character varying(5),
	imlsid character varying(10)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.imls_cai
  OWNER TO postgres;

set client_encoding to 'latin1';
copy fabric.imls_cai
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/IMLS CAI/NTIA NBM CAI LIBRARY CSV/NTIA_CAI_jun2013_LIB.csv'
	csv header delimiter ',';
