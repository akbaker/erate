--Create tract column in crosswalk table
alter table analysis.nces_block_walk add column tract character varying(11);
update analysis.nces_block_walk set tract = substr(block_fips,1,11);

alter table analysis.nces_pub_oos
	add column tract character(11);

update analysis.nces_pub_oos
	set tract = nces_block_walk.tract
	from analysis.nces_block_walk
	where nces_block_walk.school_id = nces_pub_oos.school_id;

----Comcast (Note: this takes about 7 minutes)
alter table analysis.nces_pub_oos
	add column comcast integer;

update analysis.nces_pub_oos
	set comcast = 1
	from analysis.shp_block
	where dbaname like 'Comcast' and st_contains(shp_block.geom, nces_pub_oos.geom);
update analysis.nces_pub_oos
	set comcast = 0
	where comcast is null;

----Verizon (Note: this takes about 5 minutes)
alter table analysis.nces_pub_oos
	add column verizon integer;

update analysis.nces_pub_oos
	set verizon = 1
	from analysis.shp_block
	where dbaname like 'Verizon' and st_contains(shp_block.geom, nces_pub_oos.geom);
update analysis.nces_pub_oos
	set verizon = 0
	where verizon is null;

----AT&T (Note: this takes about 50 minutes)
alter table analysis.nces_pub_oos
	add column att integer;
	
update analysis.nces_pub_oos
	set att = 1
	from analysis.shp_block
	where dbaname like '%AT&T%' and st_contains(shp_block.geom, nces_pub_oos.geom);
update analysis.nces_pub_oos
	set att = 0
	where att is null;

----CenturyLink (Note: this takes about 10 minutes)
alter table analysis.nces_pub_oos
	add column centurylink integer;

update analysis.nces_pub_oos
	set centurylink = 1
	from analysis.shp_block
	where dbaname like 'CenturyLink' and st_contains(shp_block.geom, nces_pub_oos.geom);
update analysis.nces_pub_oos
	set centurylink = 0
	where centurylink is null;

--Drop duplicates 
create table analysis.sample_schools as
	select school_id from analysis.flatfile_reg;
select count(*)
	from analysis.nces_pub_oos, analysis.sample_schools
	where nces_pub_oos.school_id=sample_schools.school_id;
delete from analysis.nces_pub_oos using analysis.sample_schools
	where nces_pub_oos.school_id=sample_schools.school_id;

select count(*) from analysis.nces_pub_oos;
----obs: 62,459

--Create flatfile query
drop view analysis.outsample_reg;
create view analysis.outsample_reg as
	select nces_pub_oos.school_id, nces_pub_oos.school_type, nces_pub_oos.school_status, nces_pub_oos.school_loc, 
		nces_pub_oos.fte, nces_pub_oos.title1_elig, nces_pub_oos.magnet, nces_pub_oos.charter, nces_pub_oos.shared,
		nces_pub_oos.tot_students, nces_pub_oos.free_lunch, nces_pub_oos.reduc_lunch, nces_pub_oos.native_american,
		nces_pub_oos.asian, nces_pub_oos.hispanic, nces_pub_oos.black, nces_pub_oos.white, nces_pub_oos.pacific,
		nces_pub_oos.two_races, nces_pub_oos.comcast, nces_pub_oos.verizon, nces_pub_oos.att, nces_pub_oos.centurylink,
		acs2011.ur_16plus, acs2011.median_inc,nces_optring.min_dist, btop_awards.btop_award, 
		state_gdp.realgdp_2010, state_gdp.realgdp_2011, state_gdp.gdpchange_2011
	from analysis.nces_pub_oos
	left outer join analysis.nces_optring on nces_optring.ncessch=nces_pub_oos.school_id
	left outer join analysis.acs2011 on nces_pub_oos.tract = acs2011.tract
	left outer join analysis.btop_awards on nces_pub_oos.lstate = btop_awards.stab
	left outer join analysis.state_gdp on nces_pub_oos.fips_state = state_gdp.state_fips;

select count(*)
	from analysis.outsample_reg;

--Export view
copy (select * from analysis.outsample_reg) to '/Users/FCC/Documents/allison/data/outsample_reg_feb14.csv' with delimiter '|' CSV header;
