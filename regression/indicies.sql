--Create indexes
create index analysis_nces_optring_ncessch
	on analysis.nces_optring
	using btree(ncessch);

create index analysis_nces_pub_full_school_id
	on analysis.nces_pub_full
	using btree(school_id);

create index analysis_acs2011_tract
	on analysis.acs2011
	using btree(tract);

create index analysis_nces_pub_oos_school_id
	on analysis.nces_pub_oos
	using btree(school_id);

create index analysis_nces_block_walk_school_id
	on analysis.nces_block_walk
	using btree(school_id);

create index analysis_nces_block_walk_tract
	on analysis.nces_block_walk
	using btree(tract);
