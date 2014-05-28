drop table if exists fabric.nj_lib;
CREATE TABLE fabric.nj_lib
(
	cai_id character varying(10),
	libraryname character varying(50),
	address character varying(100),
	city character varying(50),
	state character varying(2),
	zip character varying(5),
	zip4 character varying(4),
	county character varying(50),
	longitude double precision,
	latitute double precision,
	provider character varying(50),
	transtech int,
	downspeed_tier int,
	upspeed_tier int,
	availability character varying(2),
	wifi character varying(5),
	cai_sub_category character varying(10),
	source character varying(10),
	data_currentness int
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.nj_lib
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy fabric.nj_lib
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/NJ/OIT NJ Library Data/Libraries_SurveyPlusBBPlusUSAC.csv'
	csv header delimiter ',';
