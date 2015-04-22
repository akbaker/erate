ALTER table analysis.nces_pub ADD COLUMN geom geometry(POINT,4326);
UPDATE analysis.nces_pub SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);
CREATE INDEX nces_pub_geom_gist ON analysis.nces_pub USING GIST(geom);