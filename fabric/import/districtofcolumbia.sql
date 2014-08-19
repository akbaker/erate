drop table if exists fabric.dc_ind;
CREATE TABLE fabric.dc_ind
(
	school_name character varying(100),
	school_level character varying(5),
	address character varying(50),
	city character varying(15),
	statecode character varying(2),
	zip5 character varying(5),
	technology character varying(10),
	bandwidth int,
	public_wifi character varying(1),
	nces_code character varying(12),
	marid character varying(10),
	latitude double precision,
	longitude double precision
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.dc_ind
  OWNER TO postgres;

copy fabric.dc_ind
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/DC/DC_LibrarySchoolBandwidthTable_Final.csv'
	csv header delimiter ',';