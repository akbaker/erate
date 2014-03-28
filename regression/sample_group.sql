--Create tract column in acs2011
select count(*) from analysis.shp_cai2013_clean
	where char_length(fullfipsid) = '15';

--alter table analysis.shp_cai2013_clean drop column tract;
alter table analysis.shp_cai2013_clean add column tract character varying(11);
update analysis.shp_cai2013_clean set tract = substr(fullfipsid,1,11);

--Providers and counts
----Comcast (Note: this takes about 7 minutes)
alter table analysis.nces_pub
	add column comcast integer;

update analysis.nces_pub_full
	set comcast = 1
	from analysis.shp_block
	where dbaname like 'Comcast' and st_contains(shp_block.geom, nces_pub_full.geom);
update analysis.nces_pub_full
	set comcast = 0
	where comcast is null;

----Verizon (Note: this takes about 5 minutes)
alter table analysis.nces_pub_full
	add column verizon integer;

update analysis.nces_pub_full
	set verizon = 1
	from analysis.shp_block
	where dbaname like 'Verizon' and st_contains(shp_block.geom, nces_pub_full.geom);
update analysis.nces_pub_full
	set verizon = 0
	where verizon is null;

----AT&T (Note: this takes about 50 minutes)
alter table analysis.nces_pub_full
	add column att integer;
	
update analysis.nces_pub_full
	set att = 1
	from analysis.shp_block
	where dbaname like '%AT&T%' and st_contains(shp_block.geom, nces_pub_full.geom);
update analysis.nces_pub_full
	set att = 0
	where att is null;

----CenturyLink (Note: this takes about 10 minutes)
alter table analysis.nces_pub_full
	add column centurylink integer;

update analysis.nces_pub_full
	set centurylink = 1
	from analysis.shp_block
	where dbaname like 'CenturyLink' and st_contains(shp_block.geom, nces_pub_full.geom);
update analysis.nces_pub_full
	set centurylink = 0
	where centurylink is null;

--Create new table based on successful join between CAI data and NCES public schools data
create table analysis.reg_sample as
select * 
	from analysis.shp_cai2013_clean
	inner join analysis.nces_pub_full
	on shp_cai2013_clean.nces_id=nces_pub_full.school_id 
		or shp_cai2013_clean.caiid= nces_pub_full.state_schid;

select count(*)
	from analysis.reg_sample;
----obs: 41,639

--Create view
drop view analysis.flatfile_reg;
create view analysis.flatfile_reg as
	select reg_sample.school_id, reg_sample.school_type, reg_sample.school_status, reg_sample.school_loc, 
		reg_sample.fte, reg_sample.title1_elig, reg_sample.magnet, reg_sample.charter, reg_sample.shared,
		reg_sample.tot_students, reg_sample.free_lunch, reg_sample.reduc_lunch, reg_sample.native_american,
		reg_sample.asian, reg_sample.hispanic, reg_sample.black, reg_sample.white, reg_sample.pacific,
		reg_sample.two_races, reg_sample.comcast, reg_sample.verizon, reg_sample.att, reg_sample.centurylink,
		reg_sample.caicat, reg_sample.bbservice, reg_sample.transtech, reg_sample.subscrbdow, 
		reg_sample.subsrbup, reg_sample.fiber, acs2011.ur_16plus, acs2011.median_inc, 
		nces_optring.min_dist, btop_awards.btop_award, state_gdp.realgdp_2010, 
		state_gdp.realgdp_2011, state_gdp.gdpchange_2011
	from analysis.reg_sample
	inner join analysis.nces_optring on nces_optring.ncessch=reg_sample.school_id
	inner join analysis.acs2011 on reg_sample.tract = acs2011.tract
	inner join analysis.btop_awards on reg_sample.lstate = btop_awards.stab
	inner join analysis.state_gdp on reg_sample.fips_state = state_gdp.state_fips;

select count(*)
	from analysis.flatfile_reg;
----obs: 41,354

select *
	from analysis.flatfile_reg
	where min_dist is null or ur_16plus is null or median_inc is null or min_dist is null or btop_award is null 
		or realgdp_2010 is null or realgdp_2011 is null or gdpchange_2011 is null
----obs: 32 (all missing median income)

--Export view
copy (select * from analysis.flatfile_reg) to '/Users/FCC/Documents/allison/data/flatfile_reg_feb14.csv' with delimiter '|' CSV header;
