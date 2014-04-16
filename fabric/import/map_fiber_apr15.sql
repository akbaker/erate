-- Table: fabric.map_fiber_apr15

-- DROP TABLE fabric.map_fiber_apr15;

CREATE TABLE fabric.map_fiber_apr15
(
  school_id character(12),
  leaid character(7),
  latitude double precision,
  longitude double precision,
  tot_students integer,
  geom geometry(Point,4326),
  fiber boolean
)
WITH (
  OIDS=FALSE
);
ALTER TABLE fabric.map_fiber_apr15
  OWNER TO postgres;

COPY fabric.map_fiber_apr15
	FROM '/Users/FCC/Documents/allison/data/fabric/map_fiber_apr15.csv'
	CSV HEADER DELIMITER '|';