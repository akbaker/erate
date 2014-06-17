drop table if exists fabric.block4_may22;
CREATE TABLE fabric.block4_may22
(
	funding_year int,
	f471_appnum character varying(6),
	frn character varying(8),
	block5_item22 character varying(15),
	entity_rcv_svc_num character varying(15),
	entity_rcv_name character varying(100),
	entity_rcv_type character varying(20),
	nces_code character varying(15),
	rural_urban character varying(10),
	student_count int,
	student_nslp_count int,
	nslp_eligible_pct double precision,
	discount_pct int,
	weighted_product double precision,
	prek_adult_juvenile_flag character varying(2),
	alt_discount_mechanism_flag character varying(2)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.block4_may22
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy fabric.block4_may22
	from '/Users/FCC/Documents/allison/data/Block4_09_13/FCCREQ_3_BLOCK4_REV.csv'
	csv delimiter '|';
