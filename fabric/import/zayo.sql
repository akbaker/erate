drop table if exists fabric.zayo;
CREATE TABLE fabric.zayo
(
	market_name character varying(100),
	building_number character varying(6),
	building_type character varying(50),
	street_address character varying(100),
	state character varying(2),
	city character varying(50),
	postal_code character varying(5),
	latitute double precision,
	longitude double precision,
	lata character varying(5),
	npa character varying(5),
	nxx character varying(5),
	clli_code character varying(10),
	status character varying(10)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.zayo
  OWNER TO postgres;

copy fabric.zayo
	from '/Users/FCC/Documents/allison/data/fabric/Zayo On-Net Fiber Building List - Education sites %285-14-14%29.csv'
	csv header delimiter ',';
