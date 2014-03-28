--PUBLIC
DROP TABLE IF EXISTS analysis.public_schools_cable;

CREATE TABLE analysis.public_schools_cable AS
SELECT lstate, count(*) as tot_schools, sum(tot_students) as tot_students
	FROM analysis.nces_pub_full
	WHERE tot_students > 0
	GROUP BY lstate
	ORDER BY lstate;

--All Cable
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_allcable_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_allcable_block int; 
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_allcable_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_allcable_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_allcable_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_allcable_road int;	 
--Comcast
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_comcast_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_comcast_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_comcast_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_comcast_address int; 
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_comcast_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_comcast_road int; 
--TWC
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_twc_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_twc_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_twc_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_twc_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_twc_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_twc_road int;
--Cox
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_cox_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_cox_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_cox_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_cox_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_cox_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_cox_road int;
--Charter
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_charter_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_charter_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_charter_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_charter_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_charter_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_charter_road int;
--Cablevision
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_cablevision_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_cablevision_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_cablevision_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_cablevision_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_cablevision_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_cablevision_road int;
--Top 5
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_top5_block int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_top5_block int;	
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_top5_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_top5_address int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN schools_top5_road int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN students_top5_road int;
--Combined
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_allcable int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_allcable int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_comcast int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_comcast int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_twc int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_twc int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_cox int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_cox int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_charter int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_charter int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_cablevision int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_cablevision int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_schools_top5 int;
ALTER TABLE analysis.public_schools_cable
	ADD COLUMN public_students_top5 int;

--PRIVATE
DROP TABLE IF EXISTS analysis.private_schools_cable;

CREATE TABLE analysis.private_schools_cable AS
SELECT school_state, count(*) as tot_schools, sum(tot_students) as tot_students
	FROM analysis.nces_pri
	GROUP BY school_state
	ORDER BY school_state;

--All Cable
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_allcable_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_allcable_block int; 
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_allcable_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_allcable_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_allcable_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_allcable_road int;	 
--Comcast
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_comcast_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_comcast_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_comcast_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_comcast_address int; 
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_comcast_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_comcast_road int; 
--TWC
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_twc_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_twc_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_twc_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_twc_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_twc_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_twc_road int;
--Cox
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_cox_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_cox_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_cox_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_cox_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_cox_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_cox_road int;
--Charter
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_charter_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_charter_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_charter_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_charter_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_charter_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_charter_road int;
--Cablevision
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_cablevision_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_cablevision_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_cablevision_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_cablevision_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_cablevision_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_cablevision_road int;
	
--Top 5
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_top5_block int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_top5_block int;	
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_top5_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_top5_address int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN schools_top5_road int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN students_top5_road int;
--Combined
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_allcable int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_allcable int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_comcast int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_comcast int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_twc int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_twc int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_cox int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_cox int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_charter int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_charter int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_cablevision int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_cablevision int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_schools_top5 int;
ALTER TABLE analysis.private_schools_cable
	ADD COLUMN private_students_top5 int;

--LIBRARIES
DROP TABLE IF EXISTS analysis.lib_cable;

CREATE TABLE analysis.lib_cable AS
SELECT stab, count(*)  as tot_libraries
	FROM analysis.imls_lib
	WHERE lib_outype <> 'BS'
	GROUP BY stab
	ORDER BY stab;

--All cable
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_allcable_block int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_allcable_address int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_allcable_road int;
--Comcast	
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_comcast_block int; 
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_comcast_address int; 
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_comcast_road int;
--TWC
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_twc_block int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_twc_address int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_twc_road int;
--Cox
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cox_block int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cox_address int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cox_road int;
--Charter
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_charter_block int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_charter_address int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_charter_road int;
--Cablevision
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cablevision_block int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cablevision_address int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cablevision_road int;
--Top 5
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_top5_block int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_top5_address int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_top5_road int;
--Combined
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_allcable int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_comcast int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_twc int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cox int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_charter int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_cablevision int;
ALTER TABLE analysis.lib_cable
	ADD COLUMN lib_top5 int;
