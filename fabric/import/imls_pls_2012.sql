drop table if exists analysis.imls_lib_2012;

create table analysis.imls_lib_2012 (
	stabr character varying(2),
	fscskey character varying(6),
	fscs_seq character varying(5),
	libid character varying(20),
	libname character varying(100),
	address character varying(150),
	city character varying(100),
	zip character varying(5),
	zip4 character varying(4),
	county character varying(50),
	phone character varying(10),
	c_out_ty character varying(2),
	c_msa character varying(2),
	sq_feet int,
	f_sq_ft character varying(5),
	l_num_bm int,
	f_bkmob character varying(5),
	hours int,
	f_hours character varying(5),
	wks_open int,
	f_wksopn character varying(5),
	yr_sub int,
	statstru int,
	statname character varying(2),
	stataddr character varying(2),
	longitude double precision,
	latitute double precision,
	fipsst character varying(2),
	fipsco character varying(5),
	fipslac character varying(5),
	cntypop int,
	locale int,
	centract character varying(10),
	cenblock character varying(5),
	cdcode character varying(5),
	cbsa character varying(5),
	microf character varying(2),
	gal character varying(50),
	galms character varying(3),
	postms character varying(3)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE analysis.imls_lib_2012
  OWNER TO postgres;

set client_encoding to 'latin1';
copy analysis.imls_lib_2012
	from '/Users/FCC/Documents/allison/E-rate analysis/Data/PLS 2012/pupld12a_csv/Puout12a.csv'
	csv header delimiter ',';