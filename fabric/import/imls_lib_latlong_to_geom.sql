ALTER table analysis.imls_lib_2012 ADD COLUMN geom geometry(POINT,4326);
UPDATE analysis.imls_lib_2012 SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);
CREATE INDEX imls_lib_geom_gist ON analysis.imls_lib_2012 USING GIST(geom);