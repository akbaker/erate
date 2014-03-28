-- Table: analysis.acs2011

--DROP TABLE analysis.acs2011;

CREATE TABLE analysis.acs2011
	(
		pct_HSplus double precision,
		pct_BAplus double precision,
		tot_pop_16plus integer,
		lf_16plus double precision,
		emp_16plus double precision,
		ur_16plus double precision,
		median_inc integer,
		tract character varying(11) primary key
	)	
		WITH (
		OIDS=FALSE
	);
	ALTER TABLE analysis.acs2011
	OWNER TO postgres;

copy analysis.acs2011
	from '/Users/FCC/Dropbox/Datasets/ACS_tract_emp_educ_inc.csv'
	csv header delimiter '|';
