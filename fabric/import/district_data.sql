drop table if exists analysis.nces_pub_dist_short;
CREATE TABLE analysis.nces_pub_dist_short
(
	leaid character varying(7),
	district_name character varying(200),
	lzip character varying(5),
	ulocal character varying(2),
	member int
)
WITH (
  OIDS=FALSE
);
ALTER TABLE analysis.nces_pub_dist_short
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy analysis.nces_pub_dist_short
	from '/Users/FCC/Documents/allison/data/public_school/NCES District Data Short.csv'
	csv header delimiter ',';
