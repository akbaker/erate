Workflow
------------------
1) Download state-level shapefiles from nbm.gov

2) Import NBM state data

	nbm_state_import.py

3) Set up tables in PostgreSQL

	cable_table_prep.sql

4) Run calculations

	public_schools.py
	private_schools.py
	libraries.py

5) Sum across block, address, road columns

	cable_column_totals.sql
