Objective
--------------
Run a regression on a sample of schools with known fiber connectivity to determine the effects
of control variables. Then use the results to predict the probability that all public schools
are connected to fiber.

Dependencies
----------------
* Postgres / PostGIS (Open Geo Suite)
* Python
* Stata
* Data (see below for details)


Workflow
--------------
1) Import a second copy of the 2013 CAI data to work from

2) Import additional datasets.

	ACS_data_import.sql
	crosswalk_import.sql
	nces_optring_import.sql

3) Clean CAI dataset -- keep only private schools, remove duplicates
  
    cai_cleaning.sql

4) Calculate minimum distance to existing fiber source
  
    erate_mindist.py

5) Run query to create flat sample group CSV file

    sample_group.sql

6) Run query to create flat out-of-sample group CSV file 

    outsample_group.sql

7) Import resulting CSVs into Stata

8) Run regression and calculate predicted values
