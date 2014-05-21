drop table if exists fabric.wv_ind;
CREATE TABLE fabric.wv_ind
(
	resa character varying(4),
	county_number character varying(10),
	county_name character varying(20),
	school_number character varying(15),
	school_name character varying(100),
	enrollment character varying(5),
	current_bandw float,
	perstu_bandw character varying(5),
	meet_2014standard character varying(3),
	meet_2017standard character varying(3),
	cxn_type character varying(50),
	current_prov character varying(50),
	monthly_cost money,
	fiber_ind character(1),
	current_router character varying(20),
	btop_fiber character varying(3),
	btop_complete character varying(3),
	btop_router character varying(3),
	router_installed character varying(3),
	notes character varying(250)
)	
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.wv_ind
  OWNER TO postgres;

copy fabric.wv_ind
	from '/Users/FCC/Documents/allison/data/fabric/State Connectivity Data/WV/All_K12_Connections_Summary_mod.csv'
	csv header delimiter ',';
