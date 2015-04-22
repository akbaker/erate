ALTER table analysis.nces_pri ADD COLUMN geom geometry(POINT,4326);
UPDATE analysis.nces_pri SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);
CREATE INDEX nces_pri_geom_gist ON analysis.nces_pri USING GIST(geom);