-- Table: analysis.shp_cai2013_clean

-- DROP TABLE analysis.shp_cai2013_clean;

CREATE TABLE analysis.shp_cai2013_clean
(
  gid integer NOT NULL DEFAULT nextval('analysis.shp_cai_clean_gid_seq'::regclass),
  __gid numeric(10,0),
  anchorname character varying(200),
  address character varying(200),
  bldgnbr character varying(10),
  predir character varying(25),
  streetname character varying(50),
  streettype character varying(25),
  suffdir character varying(25),
  city character varying(50),
  statecode character varying(2),
  zip5 character varying(5),
  zip4 character varying(4),
  lat numeric,
  lon numeric,
  caicat character varying(2),
  bbservice character varying(2),
  publicwifi character varying(2),
  url character varying(100),
  transtech numeric(10,0),
  fullfipsid character varying(16),
  caiid character varying(50),
  subscrbdow character varying(2),
  subsrbup character varying(2),
  sbdd_id character varying(20),
  geom_cai geometry(Point,4326),
  nces_id character(12),
  fiber integer,
  tract character varying(11),
  CONSTRAINT shp_cai_clean_pkey PRIMARY KEY (gid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE analysis.shp_cai2013_clean
  OWNER TO "FCC";

-- Index: analysis.shp_cai_clean_geom_gist

-- DROP INDEX analysis.shp_cai_clean_geom_gist;

CREATE INDEX shp_cai_clean_geom_gist
  ON analysis.shp_cai2013_clean
  USING gist
  (geom_cai);

COPY analysis.shp_cai2013_clean
FROM '/Users/FCC/Documents/allison/E-rate analysis/Maps/shp_cai2013_clean.csv'
CSV DELIMITER '|' HEADER;