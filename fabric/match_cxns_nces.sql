--ADD LEA SCHOOLS COUNT TO NCES PUBLIC TABLE
alter table analysis.nces_pub_full
	drop column if exists schools_count;
alter table analysis.nces_pub_full
	add column schools_count int;
with new_values as(
select leaid, count(*) as schools_district
	from analysis.nces_pub_full
	group by leaid
	order by leaid
)
update analysis.nces_pub_full
	set schools_count=new_values.schools_district
	from new_values
	where nces_pub_full.leaid=new_values.leaid;

--CLASSIFY SCHOOLS AS ELEMENTARY, MIDDLE, OR HIGH IN NCES PUBLIC TABLE
alter table analysis.nces_pub_full
	drop column if exists school_level;
alter table analysis.nces_pub_full
	add column school_level int;
update analysis.nces_pub_full
	set school_level = 3
	where high_grade = 'PK' or high_grade = 'KG' or high_grade = '1' or high_grade = '2' 
		or high_grade = '3' or high_grade = '4' or high_grade = '5';
update analysis.nces_pub_full
	set school_level = 2
	where high_grade = '6' or high_grade = '7' or high_grade = '8';
update analysis.nces_pub_full
	set school_level = 1
	where high_grade = '9' or high_grade = '10' or high_grade = '11' or high_grade = '12';
update analysis.nces_pub_full
	set school_level = 4
	where high_grade = 'UG';

select school_level, count(*)
	from analysis.nces_pub_full
	group by school_level;
select high_grade from analysis.nces_pub_full where school_level is null;

--ORDER SCHOOLS BY TYPE & SIZE WITHIN DISTRICT (USING PYTHON SCRIPT)

--ADD TOTAL FIBER CONNECTIONS COUNT TO ITEM 24 CONNECTIONS TABLE
alter table fabric.item24_cxns_feb21
	drop column if exists tot_fiber_cxns;
alter table fabric.item24_cxns_feb21
	add column tot_fiber_cxns int;
with new_values as(
select ben, sum(num_lines) as tot_fiber_lines
	from fabric.item24_cxns_feb21
	where type_cxn = 'Fiber optic/OC-x'
	group by ben
	order by ben
)
update fabric.item24_cxns_feb21
	set tot_fiber_cxns=new_values.tot_fiber_lines
	from new_values
	where new_values.ben=item24_cxns_feb21.ben;

--ADD TOTAL FIBER CONNECTIONS AT MAXIMUM DOWNLOAD SPEED TO ITEM 24 CONNECTIONS TABLE
alter table fabric.item24_cxns_feb21
	drop column if exists fiber_max_down;
alter table fabric.item24_cxns_feb21
	add column fiber_max_down int;
with new_values as(
select ben, max(download_speed) over (partition by ben) as max_speed
	from fabric.item24_cxns_feb21
	where type_cxn = 'Fiber optic/OC-x'
)
update fabric.item24_cxns_feb21
	set fiber_max_down=new_values.max_speed
	from new_values
	where new_values.ben=item24_cxns_feb21.ben;

alter table fabric.item24_cxns_feb21
	drop column if exists fiber_cxns_max_down;
alter table fabric.item24_cxns_feb21
	add column fiber_cxns_max_down int;
with new_values as(
select ben, sum(num_lines) as fiber_lines
	from fabric.item24_cxns_feb21
	where download_speed = fiber_max_down
	group by ben
	order by ben
)
update fabric.item24_cxns_feb21
	set fiber_cxns_max_down=new_values.fiber_lines
	from new_values
	where new_values.ben=item24_cxns_feb21.ben;
update fabric.item24_cxns_feb21
	set fiber_cxns_max_down=tot_fiber_cxns
	where fiber_cxns_max_down > tot_fiber_cxns;

select * from fabric.item24_cxns_feb21 where ben = '140841';


--CASE 1: NUMBER OF SCHOOLS LESS THAN OR EQUAL TO NUMBER OF FIBER CONNECTIONS AT MAX DOWNLOAD SPEED
select ben_nces_xwalk.ben, leaid, tot_fiber_cxns, fiber_max_down, fiber_cxns_max_down, schools_count
	from analysis.nces_pub_full, fabric.item24_cxns_feb21, fabric.ben_nces_xwalk
	where item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.rev_nces_id=nces_pub_full.leaid
		and type_cxn = 'Fiber optic/OC-x'
		--and leaid = '122425'
	order by fiber_cxns_max_down desc;

alter table analysis.nces_pub_full
	drop column if exists fiber_case1;
alter table analysis.nces_pub_full
	add column fiber_case1 int;
update analysis.nces_pub_full
	set fiber_case1 = 1
	from fabric.item24_cxns_feb21, fabric.ben_nces_xwalk
	where item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.rev_nces_id=nces_pub_full.leaid
		and type_cxn = 'Fiber optic/OC-x'
		and schools_count <= fiber_cxns_max_down;

select ben_nces_xwalk.ben, leaid, tot_fiber_cxns, fiber_max_down, fiber_cxns_max_down, schools_count, fiber_case1
	from analysis.nces_pub_full, fabric.item24_cxns_feb21, fabric.ben_nces_xwalk
	where item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.rev_nces_id=nces_pub_full.leaid
		and type_cxn = 'Fiber optic/OC-x'
	order by fiber_cxns_max_down desc;

select fiber_case1, count(*)
	from analysis.nces_pub_full
	group by fiber_case1;

--CASE 2: SCHOOLS EQUAL NUMBER OF FIBER CONNECTIONS BUT SPEEDS VARY
create table fabric.flat_item24_cxns_feb21 as(
select ben, sum(num_lines) as tot_fiber_lines
	from fabric.item24_cxns_feb21
	where type_cxn = 'Fiber optic/OC-x'
	group by ben
	order by ben
);

alter table analysis.nces_pub_full
	drop column if exists fiber_case2;
alter table analysis.nces_pub_full
	add column fiber_case2 int;
update analysis.nces_pub_full
	set fiber_case2 = 1
	from fabric.flat_item24_cxns_feb21, fabric.ben_nces_xwalk 
	where size_sort <= tot_fiber_lines
		and flat_item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.rev_nces_id=nces_pub_full.leaid;


select fiber_case1, fiber_case2, fiber_case4, count(*) from analysis.nces_pub_full group by fiber_case1, fiber_case2, fiber_case4;

--CASE 4: INDIVIDUAL SCHOOL APPLICATIONS
select item24_cxns_feb21.ben, ben_nces_xwalk.ben, nces_id, school_id, type_cxn, download_speed
	from fabric.item24_cxns_feb21, fabric.ben_nces_xwalk, analysis.nces_pub_full
	where item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.nces_id=nces_pub_full.school_id
		and type_cxn = 'Fiber optic/OC-x'
	order by nces_id;

alter table analysis.nces_pub_full
	drop column if exists fiber_case4;
alter table analysis.nces_pub_full
	add column fiber_case4 int;
update analysis.nces_pub_full
	set fiber_case4 = 1
	from fabric.item24_cxns_feb21, fabric.ben_nces_xwalk
	where item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.nces_id=nces_pub_full.school_id
		and type_cxn = 'Fiber optic/OC-x';	

select item24_cxns_feb21.ben, ben_nces_xwalk.ben, ben_nces_xwalk.nces_id, school_id, num_lines, download_speed,
		tot_fiber_cxns, fiber_max_down, fiber_cxns_max_down, fiber_case1, fiber_case4
	from analysis.nces_pub_full, fabric.item24_cxns_feb21, fabric.ben_nces_xwalk
	where item24_cxns_feb21.ben=ben_nces_xwalk.ben
		and ben_nces_xwalk.rev_nces_id=nces_pub_full.school_id
		and type_cxn = 'Fiber optic/OC-x'
	order by fiber_cxns_max_down desc;

--COMBINE 4 CASES TO MARK SCHOOLS WITH FIBER
alter table analysis.nces_pub_full
	drop column if exists fiber_item24;
alter table analysis.nces_pub_full
	add column fiber_item24 int;

update analysis.nces_pub_full
	set fiber_item24 = coalesce(fiber_case1, fiber_case2, fiber_case4);

select lstate, sum(fiber_item24) as fiber, count(*) as tot_schools
	from analysis.nces_pub_full
	group by lstate
	order by lstate;
