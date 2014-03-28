drop table if exists fabric.cenic;
CREATE TABLE fabric.cenic
(
	cds_code character varying(15),
	loc_name character varying(80),
	loc_type character varying(10),
	county_name character varying(20),
	region integer,
	connection_type character varying(50),
	connection_type_other character varying(50),
	connection_speed character varying(20),
	carrier character varying(30),
	carrier_other character varying(30),
	connect_where character varying(50),
	connect_to character varying(50),
	connect_to_other character varying(100),
	secondary_connect integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.cenic
  OWNER TO postgres;

CREATE INDEX fabric_cenic_cds_code_btree
  ON fabric.cenic
  USING btree
  (cds_code);
set client_encoding to 'latin1';
copy fabric.cenic
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/CA/California_K12HSN_datalink_March_25_2014_mod.csv'
	csv header delimiter ',' quote '"';
