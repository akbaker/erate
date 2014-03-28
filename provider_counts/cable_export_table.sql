--EXPORT SUMMED TABLE
ALTER TABLE analysis.public_schools_cable
	RENAME COLUMN tot_schools TO tot_schools_public;
ALTER TABLE analysis.public_schools_cable
	RENAME COLUMN tot_students TO tot_students_public;
ALTER TABLE analysis.private_schools_cable
	RENAME COLUMN tot_schools TO tot_schools_private;
ALTER TABLE analysis.private_schools_cable
	RENAME COLUMN tot_students TO tot_students_private;

DROP TABLE IF EXISTS analysis.cable_providers_full;
CREATE TABLE analysis.cable_providers_full AS
SELECT lstate, school_state, stab, tot_schools_public, tot_students_public, public_schools_allcable, public_students_allcable,
	public_schools_comcast, public_students_comcast, public_schools_twc, public_students_twc,
	public_schools_cox, public_students_cox, public_schools_charter, public_students_charter,
	public_schools_cablevision, public_students_cablevision, public_schools_top5, public_students_top5,
	tot_schools_private, tot_students_private, private_schools_allcable, private_students_allcable,
	private_schools_comcast, private_students_comcast, private_schools_twc, private_students_twc,
	private_schools_cox, private_students_cox, private_schools_charter, private_students_charter,
	private_schools_cablevision, private_students_cablevision, private_schools_top5, private_students_top5,
	tot_libraries, lib_allcable, lib_comcast, lib_twc, lib_cox, lib_charter, lib_cablevision,
	lib_top5
FROM analysis.public_schools_cable
FULL OUTER JOIN analysis.private_schools_cable
ON public_schools_cable.lstate = private_schools_cable.school_state
FULL OUTER JOIN analysis.lib_cable
ON public_schools_cable.lstate = lib_cable.stab;

ALTER TABLE analysis.cable_providers_full
	ADD COLUMN tot_schools int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN tot_students int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_allcable int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_allcable int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_comcast int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_comcast int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_twc int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_twc int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_cox int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_cox int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_charter int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_charter int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_cablevision int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_cablevision int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN schools_top5 int;
ALTER TABLE analysis.cable_providers_full
	ADD COLUMN students_top5 int;

--SUM ACROSS COLUMNS
--Totals
WITH new_values AS(
SELECT lstate, COALESCE(tot_schools_public,0) + COALESCE(tot_schools_private,0) as all_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET tot_schools = new_values.all_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(tot_students_public,0) + COALESCE(tot_students_private,0) as all_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET tot_students = new_values.all_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--All Cable
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_allcable,0) + COALESCE(private_schools_allcable,0) as allcable_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_allcable = new_values.allcable_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_allcable,0) + COALESCE(private_students_allcable,0) as allcable_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_allcable = new_values.allcable_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--Comcast
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_comcast,0) + COALESCE(private_schools_comcast,0) as comcast_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_comcast = new_values.comcast_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_comcast,0) + COALESCE(private_students_comcast,0) as comcast_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_comcast = new_values.comcast_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--TWC
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_twc,0) + COALESCE(private_schools_twc,0) as twc_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_twc = new_values.twc_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_twc,0) + COALESCE(private_students_twc,0) as twc_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_twc = new_values.twc_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--Cox
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_cox,0) + COALESCE(private_schools_cox,0) as cox_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_cox = new_values.cox_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_cox,0) + COALESCE(private_students_cox,0) as cox_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_cox = new_values.cox_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--Charter
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_charter,0) + COALESCE(private_schools_charter,0) as charter_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_charter = new_values.charter_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_charter,0) + COALESCE(private_students_charter,0) as charter_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_charter = new_values.charter_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--Cablevision
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_cablevision,0) + COALESCE(private_schools_cablevision,0) as cablevision_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_cablevision = new_values.cablevision_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_cablevision,0) + COALESCE(private_students_cablevision,0) as cablevision_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_cablevision = new_values.cablevision_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--Top 5
WITH new_values AS(
SELECT lstate, COALESCE(public_schools_top5,0) + COALESCE(private_schools_top5,0) as top5_schools
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET schools_top5 = new_values.top5_schools
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

WITH new_values AS(
SELECT lstate, COALESCE(public_students_top5,0) + COALESCE(private_students_top5,0) as top5_students
	FROM analysis.cable_providers_full
	ORDER BY lstate
)
UPDATE analysis.cable_providers_full
	SET students_top5 = new_values.top5_students
	FROM new_values
	WHERE cable_providers_full.lstate = new_values.lstate;

--EXPORT DATA
copy (select lstate, tot_schools, tot_students, tot_libraries, schools_allcable, students_allcable, 
lib_allcable, schools_comcast, students_comcast, lib_comcast, schools_twc, students_twc, lib_twc,
schools_cox, students_cox, lib_cox, schools_charter, students_charter, lib_charter,
schools_cablevision, students_cablevision, lib_cablevision, schools_top5, students_top5, lib_top5 from analysis.cable_providers_full) to '/Users/FCC/Documents/allison/data/provider_counts/cable_schools_mar14.csv' with delimiter '|' CSV header;
