--CREATE TABLE
DROP TABLE IF EXISTS fabric.ga_ind;
CREATE TABLE fabric.ga_ind
(
school_name character varying(100),
district_name character varying(100),
address character varying(100),
city character varying(50),
zip_code character varying(10),
has_fiber character varying(3)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ga_ind
  OWNER TO postgres;

SET client_encoding to 'latin1';
COPY fabric.ga_ind
	FROM '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/GA/Georgia SchoolFiberSurvey with address.csv'
	CSV HEADER DELIMITER ',';

DELETE FROM fabric.ga_ind
WHERE school_name IS NULL;