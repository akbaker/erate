--Add congressional district to schools tables
alter table analysis.nces_public_2011
add column cd113 character varying(2);

with new_values as(
select cd113fp, geom
from census2010.cd113
)
update analysis.nces_public_2011
set cd113 = cd113fp
from new_values
where st_within(nces_public_2011.geom, new_values.geom);