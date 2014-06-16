drop table if exists analysis.zip_codes;
CREATE TABLE analysis.zip_codes
(
	zipcode character varying(5),
	zipcode_type character varying(50),
	city character varying(100),
	state character varying(2),
	location_type character varying(20),
	latitude double precision,
	longitude double precision,
	location character varying(100),
	decommission character varying(10),
	tax_returns int,
	estimated_pop int,
	total_wages int
)
WITH (
  OIDS=FALSE
);
ALTER TABLE analysis.zip_codes
  OWNER TO postgres;

copy analysis.zip_codes
	from '/Users/FCC/Documents/allison/data/free-zipcode-database-Primary.csv'
	csv header delimiter ',';
