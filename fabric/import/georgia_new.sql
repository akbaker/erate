--CREATE TABLE
DROP TABLE IF EXISTS fabric.ga_ind_new;
CREATE TABLE fabric.ga_ind_new
(
school_name character varying(100),
suid character varying(8),
ncesid character varying(12),
entityid character varying(10),
district_name character varying(100),
district_type character varying(10),
gadistrictid character varying(8),
usdistrictid character varying(7),
address character varying(100),
city character varying(50),
zip_code character varying(10),
zip4 character varying(4),
lat double precision,
lon double precision,
has_fiber character varying(3),
isp character varying(100),
bau_0_cost character varying(10),
fiber_low character varying(20),
fiber_high character varying(10),
equip_100mb_1gb character varying(10),
total_cost character varying(10),
student_enrollment int,
student_frl int,
percentfrlenrollment character varying,
minbandwidth float,
fundingavailable float,
matchcomponent float
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.ga_ind_new
  OWNER TO postgres;

SET client_encoding to 'latin1';
COPY fabric.ga_ind_new
	FROM '/Users/FCC/Documents/allison/E-rate analysis/Data/State Connectivity Data/GA/SchoolErateDiscountLevels.csv'
	CSV HEADER DELIMITER ',';