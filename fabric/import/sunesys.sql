drop table if exists fabric.sunesys;
CREATE TABLE fabric.sunesys
(
	appstate character(2),
	appname character varying(50),
	apptype character varying(20),
	svcid character varying(50),
	spin character(9),
	co_name character varying(20)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.sunesys
  OWNER TO postgres;

copy fabric.sunesys
	from '/Users/FCC/Documents/allison/data/fabric/MAW - Sunesys SPIN.csv'
	csv header delimiter ',';
