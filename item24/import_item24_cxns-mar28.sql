drop table if exists fabric.item24_cxns_mar28_expanded;
CREATE TABLE fabric.item24_cxns_mar28_expanded
(
	frn character(7),
	appl_num_471 character(6),
	ben character varying(8),
	applicant_name character varying(100),
	type_cxn character varying(50),
	num_lines int,
	download_speed float
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.item24_cxns_mar28_expanded
  OWNER TO postgres;

--set client_encoding to 'latin1';
copy fabric.item24_cxns_mar28_expanded
	from '/Users/FCC/Documents/allison/data/fabric/item24/SL_FRN_Connections 03282014.csv'
	csv header delimiter ',';
