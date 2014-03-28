--PUBLIC
--All Cable
WITH new_values AS(
SELECT lstate, COALESCE(schools_allcable_block,0) + COALESCE(schools_allcable_road,0) + COALESCE(schools_allcable_address,0) as public_allcable_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_allcable = new_values.public_allcable_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_allcable_block,0) + COALESCE(students_allcable_road,0) + COALESCE(students_allcable_address,0) as public_allcable_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_allcable = new_values.public_allcable_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;
--Comcast
WITH new_values AS(
SELECT lstate, COALESCE(schools_comcast_block,0) + COALESCE(schools_comcast_road,0) + COALESCE(schools_comcast_address,0) as public_comcast_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_comcast = new_values.public_comcast_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_comcast_block,0) + COALESCE(students_comcast_road,0) + COALESCE(students_comcast_address,0) as public_comcast_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_comcast = new_values.public_comcast_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;
--TWC
WITH new_values AS(
SELECT lstate, COALESCE(schools_twc_block,0) + COALESCE(schools_twc_road,0) + COALESCE(schools_twc_address,0) as public_twc_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_twc = new_values.public_twc_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_twc_block,0) + COALESCE(students_twc_road,0) + COALESCE(students_twc_address,0) as public_twc_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_twc = new_values.public_twc_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;
--Cox
WITH new_values AS(
SELECT lstate, COALESCE(schools_cox_block,0) + COALESCE(schools_cox_road,0) + COALESCE(schools_cox_address,0) as public_cox_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_cox = new_values.public_cox_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_cox_block,0) + COALESCE(students_cox_road,0) + COALESCE(students_cox_address,0) as public_cox_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_cox = new_values.public_cox_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;
--Charter
WITH new_values AS(
SELECT lstate, COALESCE(schools_charter_block,0) + COALESCE(schools_charter_road,0) + COALESCE(schools_charter_address,0) as public_charter_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_charter = new_values.public_charter_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_charter_block,0) + COALESCE(students_charter_road,0) + COALESCE(students_charter_address,0) as public_charter_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_charter = new_values.public_charter_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;
--Cablevision
WITH new_values AS(
SELECT lstate, COALESCE(schools_cablevision_block,0) + COALESCE(schools_cablevision_road,0) + COALESCE(schools_cablevision_address,0) as public_cablevision_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_cablevision = new_values.public_cablevision_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_cablevision_block,0) + COALESCE(students_cablevision_road,0) + COALESCE(students_cablevision_address,0) as public_cablevision_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_cablevision = new_values.public_cablevision_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;
--Top5
WITH new_values AS(
SELECT lstate, COALESCE(schools_top5_block,0) + COALESCE(schools_top5_road,0) + COALESCE(schools_top5_address,0) as public_top5_schools
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_schools_top5 = new_values.public_top5_schools
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(students_top5_block,0) + COALESCE(students_top5_road,0) + COALESCE(students_top5_address,0) as public_top5_students
	FROM analysis.public_schools_cable
	ORDER BY lstate
)
UPDATE analysis.public_schools_cable
	SET public_students_top5 = new_values.public_top5_students
	FROM new_values
	WHERE public_schools_cable.lstate = new_values.lstate;

--PRIVATE
--All Cable
WITH new_values AS(
SELECT school_state, COALESCE(schools_allcable_block,0) + COALESCE(schools_allcable_road,0) + COALESCE(schools_allcable_address,0) as private_allcable_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_allcable = new_values.private_allcable_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_allcable_block,0) + COALESCE(students_allcable_road,0) + COALESCE(students_allcable_address,0) as private_allcable_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_allcable = new_values.private_allcable_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;
--Comcast
WITH new_values AS(
SELECT school_state, COALESCE(schools_comcast_block,0) + COALESCE(schools_comcast_road,0) + COALESCE(schools_comcast_address,0) as private_comcast_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_comcast = new_values.private_comcast_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_comcast_block,0) + COALESCE(students_comcast_road,0) + COALESCE(students_comcast_address,0) as private_comcast_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_comcast = new_values.private_comcast_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;
--TWC
WITH new_values AS(
SELECT school_state, COALESCE(schools_twc_block,0) + COALESCE(schools_twc_road,0) + COALESCE(schools_twc_address,0) as private_twc_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_twc = new_values.private_twc_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_twc_block,0) + COALESCE(students_twc_road,0) + COALESCE(students_twc_address,0) as private_twc_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_twc = new_values.private_twc_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;
--Cox
WITH new_values AS(
SELECT school_state, COALESCE(schools_cox_block,0) + COALESCE(schools_cox_road,0) + COALESCE(schools_cox_address,0) as private_cox_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_cox = new_values.private_cox_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_cox_block,0) + COALESCE(students_cox_road,0) + COALESCE(students_cox_address,0) as private_cox_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_cox = new_values.private_cox_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;
--Charter
WITH new_values AS(
SELECT school_state, COALESCE(schools_charter_block,0) + COALESCE(schools_charter_road,0) + COALESCE(schools_charter_address,0) as private_charter_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_charter = new_values.private_charter_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_charter_block,0) + COALESCE(students_charter_road,0) + COALESCE(students_charter_address,0) as private_charter_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_charter = new_values.private_charter_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;
--Cablevision
WITH new_values AS(
SELECT school_state, COALESCE(schools_cablevision_block,0) + COALESCE(schools_cablevision_road,0) + COALESCE(schools_cablevision_address,0) as private_cablevision_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_cablevision = new_values.private_cablevision_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_cablevision_block,0) + COALESCE(students_cablevision_road,0) + COALESCE(students_cablevision_address,0) as private_cablevision_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_cablevision = new_values.private_cablevision_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;
--Top 5
WITH new_values AS(
SELECT school_state, COALESCE(schools_top5_block,0) + COALESCE(schools_top5_road,0) + COALESCE(schools_top5_address,0) as private_top5_schools
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_schools_top5 = new_values.private_top5_schools
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

WITH new_values AS(
SELECT school_state, COALESCE(students_top5_block,0) + COALESCE(students_top5_road,0) + COALESCE(students_top5_address,0) as private_top5_students
	FROM analysis.private_schools_cable
	ORDER BY school_state
)
UPDATE analysis.private_schools_cable
	SET private_students_top5 = new_values.private_top5_students
	FROM new_values
	WHERE private_schools_cable.school_state = new_values.school_state;

--LIBRARIES
--All Cable
WITH new_values AS(
SELECT stab, COALESCE(lib_allcable_block,0) + COALESCE(lib_allcable_road,0) + COALESCE(lib_allcable_address,0) as allcable_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_allcable = new_values.allcable_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;	
--Comcast
WITH new_values AS(
SELECT stab, COALESCE(lib_comcast_block,0) + COALESCE(lib_comcast_road,0) + COALESCE(lib_comcast_address,0) as comcast_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_comcast = new_values.comcast_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;
--TWC
WITH new_values AS(
SELECT stab, COALESCE(lib_twc_block,0) + COALESCE(lib_twc_road,0) + COALESCE(lib_twc_address,0) as twc_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_twc = new_values.twc_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;
--Cox
WITH new_values AS(
SELECT stab, COALESCE(lib_cox_block,0) + COALESCE(lib_cox_road,0) + COALESCE(lib_cox_address,0) as cox_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_cox = new_values.cox_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;
--Charter
WITH new_values AS(
SELECT stab, COALESCE(lib_charter_block,0) + COALESCE(lib_charter_road,0) + COALESCE(lib_charter_address,0) as charter_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_charter = new_values.charter_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;
--Cablevision
WITH new_values AS(
SELECT stab, COALESCE(lib_cablevision_block,0) + COALESCE(lib_cablevision_road,0) + COALESCE(lib_cablevision_address,0) as cablevision_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_cablevision = new_values.cablevision_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;	
--Top5
WITH new_values AS(
SELECT stab, COALESCE(lib_top5_block,0) + COALESCE(lib_top5_road,0) + COALESCE(lib_top5_address,0) as top5_lib
	FROM analysis.lib_cable
	ORDER BY stab
)
UPDATE analysis.lib_cable
	SET lib_top5 = new_values.top5_lib
	FROM new_values
	WHERE lib_cable.stab = new_values.stab;
