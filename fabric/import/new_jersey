drop table if exists fabric.nj_ind;
CREATE TABLE fabric.nj_ind
(
	school_name character varying(100),
	school_id character varying(12),
	district_name character varying(70),
	district_id character(6),
	county_name character varying(20),
	county_id character(2),
	region character varying(10),
	region_id character varying(2),
	tot_enrollment int,
	available_bandw float,
	internet_use int,
	internet_reqs float,
	internet_speed float,
	wan_speed float,
	lan_speed float,
	locations int,
	waps_count int,
	waps_ratio float,
	address character varying(200),
	city_state_zip character varying(50),
	internal_network_speed float,
	internal_network_use int,
	caching character varying(3),
	wan_cxn character varying(3),
	wan_use int,
	school_type character varying(20)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.nj_ind
  OWNER TO postgres;

set client_encoding to 'latin1'; 
copy fabric.nj_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/NJ/FCC NJTRAx/NJTRAx School Data 03-13-14_mod.csv'
	csv header delimiter ',';
