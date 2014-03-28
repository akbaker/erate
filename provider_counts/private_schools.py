## Version 0.1 (for postgis)
## provider_cable_counts.py
## Created on: March 10, 2014
## Created by: Allison Baker
## FCC
## -------------------------------

#Import system modules
import sys, string, os
import psycopg2
import time
now = time.localtime(time.time())
print "local time:", time.asctime(now)

#variables
myHost = "localhost"
myPort = "5432"
myUser = "postgres"
db = "allison"
schema = "analysis"
schTBL = "nces_pri"
schema2 = "nbm2013june"
nbm = "nbm2013june.shp_"
eq_prj = "4326"

#function for creating a table of school IDs and transtechs for each state
def unique_pairs():
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
		myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
		conn = psycopg2.connect(myConn)
		ctest = conn.cursor()
		for shp in ["block","road","address"]:
			ctest.execute("select * from information_schema.tables where table_name=%s", (myState.lower() + "_" + shp,))
			if bool(ctest.rowcount):
				print myState
				c = conn.cursor()
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".private_school_transtech_" + myState + "_" + shp + "; "
				c.execute(dropSQL)
				print "drop successful"
				theSQL = "CREATE TABLE " + schema + ".private_school_transtech_" + myState + "_" + shp + " AS "
				theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
				theSQL = theSQL + ", " + schema2 + "." + myState.lower() + "_" + shp 
				theSQL = theSQL + " WHERE st_contains(" + myState.lower() + "_" + shp + ".geom, " + schTBL + ".geom) "
				theSQL = theSQL + "AND school_state = '" + str(myState) + "' GROUP BY school_id, transtech"
				theSQL = theSQL + " ORDER BY school_id, transtech; "
				print theSQL
				c.execute(theSQL)
				conn.commit()
			c.close()
		ctest.close()

#function for creating a table of unique school IDs in cable areas
def cable_schools():
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
		myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
		conn = psycopg2.connect(myConn)
		ctest = conn.cursor()
		for shp in ["block","road","address"]:
			ctest.execute("select * from information_schema.tables where table_name=%s", ("private_school_transtech_" + myState.lower() + "_" + shp,))
			if bool(ctest.rowcount):
				print myState
				print shp
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".private_school_unique_cable_" + myState + "_" + shp + "; "
				c.execute(dropSQL)
				theSQL = "CREATE TABLE " + schema + ".private_school_unique_cable_" + myState + "_" + shp + " AS "
				theSQL = theSQL + "SELECT school_id, count(*) FROM " + schema + ".private_school_transtech_"
				theSQL = theSQL + myState + "_" + shp + " WHERE transtech = '40' or transtech = '41'"
				theSQL = theSQL + " GROUP BY school_id ORDER BY count desc;"
				print theSQL
				c.execute(theSQL)
				conn.commit()
				c.close()
		ctest.close()

#function for updating all cable areas counts in primary table
def update_allcable():
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
		myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
		conn = psycopg2.connect(myConn)
		ctest = conn.cursor()
		for shp in ["block","road","address"]:
			ctest.execute("select * from information_schema.tables where table_name=%s", ("private_school_unique_cable_" + myState.lower() + "_" + shp,))
			if bool(ctest.rowcount):
				print myState
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				theSQL = "WITH new_values AS(SELECT school_state, count(*) AS tot_schools_cable"
				theSQL = theSQL + " FROM " + schema + ".private_school_unique_cable_" + myState + "_" + shp + ", " + schema 
				theSQL = theSQL + "." + schTBL + " WHERE private_school_unique_cable_" + myState + "_" + shp + ".school_id=" 
				theSQL = theSQL + schTBL + ".school_id" + " GROUP BY school_state ORDER BY school_state)"
				theSQL = theSQL + "UPDATE " + schema + ".private_schools_cable"
				theSQL = theSQL + " SET schools_allcable_" + shp + "=new_values.tot_schools_cable"
				theSQL = theSQL + " FROM new_values WHERE private_schools_cable.school_state=new_values.school_state"
				print theSQL
				c.execute(theSQL)
				conn.commit()
				theSQL2 = "WITH new_values AS(SELECT school_state, sum(tot_students) AS tot_students_cable"
				theSQL2 = theSQL2 + " FROM " + schema + ".private_school_unique_cable_" + myState + "_" + shp + ", " + schema 
				theSQL2 = theSQL2 + "." + schTBL + " WHERE private_school_unique_cable_" + myState + "_" + shp + ".school_id=" 
				theSQL2 = theSQL2 + schTBL + ".school_id" + " GROUP BY school_state ORDER BY school_state)"
				theSQL2 = theSQL2 + "UPDATE " + schema + ".private_schools_cable"
				theSQL2 = theSQL2 + " SET students_allcable_" + shp + "=new_values.tot_students_cable"
				theSQL2 = theSQL2 + " FROM new_values WHERE private_schools_cable.school_state=new_values.school_state"
				print theSQL2
				c.execute(theSQL2)
				conn.commit()
				c.close()
		ctest.close()

#function for creating a table of schools IDs for cable providers in each state
def provider_school(myProv):
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
			print myState
			myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
			conn = psycopg2.connect(myConn)
			c = conn.cursor()
			for shp in ["block","road","address"]:
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".school_" + myProv + "_" + myState + "_" + shp + ";"
				c.execute(dropSQL)
				if (myProv == 'comcast'):
					theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND school_state = '" + str(myState) + "' AND (frn = '0001604818' or"
					theSQL = theSQL + " frn = '0001609585' or frn = '0003251717' or frn = '0003261914' or"
					theSQL = theSQL + " frn = '0003663796' or frn = '0003768165' or frn = '0004441663' or"
					theSQL = theSQL + " frn = '0006109623' or frn = '0013431911' or frn = '0014383657') "
					theSQL = theSQL + "GROUP BY school_id, transtech ORDER BY school_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'twc'):
					theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND school_state = '" + str(myState)
					theSQL = theSQL + "' AND (frn = '0007556251' or frn = '0013430244') "
					theSQL = theSQL + "GROUP BY school_id, transtech ORDER BY school_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'cox'):
					theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND school_state = '" + str(myState)
					theSQL = theSQL + "' AND (frn = '0001524461' or frn = '0001834696' or frn = '0020705760') "
					theSQL = theSQL + "GROUP BY school_id, transtech ORDER BY school_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'charter'):
					theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND school_state = '" + str(myState)
					theSQL = theSQL + "' AND frn = '0017179383' "
					theSQL = theSQL + "GROUP BY school_id, transtech ORDER BY school_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'cablevision'):
					theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND school_state = '" + str(myState)
					theSQL = theSQL + "' AND (frn = '0003510195' or frn = '0003735909' or frn = '0007001977') "
					theSQL = theSQL + "GROUP BY school_id, transtech ORDER BY school_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'top5'):
					theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT school_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND school_state = '" + str(myState) + "' AND (frn = '0001604818' or"
					theSQL = theSQL + " frn = '0001609585' or frn = '0003251717' or frn = '0003261914' or"
					theSQL = theSQL + " frn = '0003663796' or frn = '0003768165' or frn = '0004441663' or"
					theSQL = theSQL + " frn = '0006109623' or frn = '0013431911' or frn = '0014383657' or"
					theSQL = theSQL + " frn = '0007556251' or frn = '0013430244' or frn = '0001524461' or"
					theSQL = theSQL + " frn = '0001834696' or frn = '0020705760' or frn = '0017179383' or"
					theSQL = theSQL + " frn = '0003510195' or frn = '0003735909' or frn = '0007001977') "
					theSQL = theSQL + "GROUP BY school_id, transtech ORDER BY school_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
			c.close()
				
#function for creating a list of unique school IDs by provider
def	provider_unique(myProv):
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
			"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
			"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
			"VI","VT","WA","WI","WV","WY"]:
		for shp in ["block","road","address"]:
				print myState
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".school_" + myProv + "_unique_" + myState + "_" + shp + ";"
				c.execute(dropSQL)
				theSQL = "CREATE TABLE " + schema + ".school_" + myProv + "_unique_" + myState + "_" + shp + " AS "
				theSQL = theSQL + "SELECT school_id, count(*) FROM " + schema + ".school_" + myProv
				theSQL = theSQL + "_" + myState + "_" + shp
				theSQL = theSQL + " WHERE transtech = '40' or transtech = '41' "
				theSQL = theSQL + "GROUP BY school_id ORDER BY count desc;"
				print theSQL
				c.execute(theSQL)
				conn.commit()
				c.close()
			
#function for matching NCES id to table and then updating primary table
def update(myProv):
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
			"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
			"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
			"VI","VT","WA","WI","WV","WY"]:
			for shp in ["block","road","address"]:
				print myState
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				theSQL = "WITH new_values AS(SELECT school_state, count(*) AS tot_schools_" + myProv
				theSQL = theSQL + " FROM " + schema + ".school_" + myProv + "_unique_" + myState + "_" + shp + ", " + schema 
				theSQL = theSQL + "." + schTBL + " WHERE school_" + myProv + "_unique_" + myState + "_" + shp + ".school_id=" 
				theSQL = theSQL + schTBL + ".school_id" + " GROUP BY school_state ORDER BY school_state)"
				theSQL = theSQL + "UPDATE " + schema + ".private_schools_cable"
				theSQL = theSQL + " SET schools_" + myProv + "_" + shp + "=new_values.tot_schools_" + myProv
				theSQL = theSQL + " FROM new_values WHERE private_schools_cable.school_state=new_values.school_state"
				print theSQL
				c.execute(theSQL)
				conn.commit()
				theSQL2 = "WITH new_values AS(SELECT school_state, sum(tot_students) AS tot_schools_" + myProv		
				theSQL2 = theSQL2 + " FROM " + schema + ".school_" + myProv + "_unique_" + myState + "_" + shp + ", " + schema 
				theSQL2 = theSQL2 + "." + schTBL + " WHERE school_" + myProv + "_unique_" + myState + "_" + shp + ".school_id=" 
				theSQL2 = theSQL2 + schTBL + ".school_id" + " GROUP BY school_state ORDER BY school_state)"
				theSQL2 = theSQL2 + "UPDATE " + schema + ".private_schools_cable"
				theSQL2 = theSQL2 + " SET students_" + myProv + "_" + shp + "=new_values.tot_schools_" + myProv
				theSQL2 = theSQL2 + " FROM new_values WHERE private_schools_cable.school_state=new_values.school_state"
				print theSQL2
				c.execute(theSQL2)
				conn.commit()
				c.close()
				
#function to clean up temp tables
def clean_tables(myProv):
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
			"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
			"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
			"VI","VT","WA","WI","WV","WY"]:
			print myState
			myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
			conn = psycopg2.connect(myConn)
			c = conn.cursor()
			for shp in ["block","road","address"]:
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".school_" + myProv + "_" + myState + "_" + shp + ";"
				c.execute(dropSQL)
				dropSQL2 = "DROP TABLE IF EXISTS " + schema + ".school_" + myProv + "_unique_" + myState + "_" + shp + ";"
				c.execute(dropSQL2)
				dropSQL3 = "DROP TABLE IF EXISTS " + schema + ".school_" + myProv + "_" + myState.lower() + ";"
				c.execute(dropSQL3)
				dropSQL4 = "DROP TABLE IF EXISTS " + schema + ".private_school_transtech_" + myState + "_" + shp + "; "
				c.execute(dropSQL4)
				dropSQL5 = "DROP TABLE IF EXISTS " + schema + ".private_school_unique_cable_" + myState + "_" + shp + "; "
				c.execute(dropSQL5)
				conn.commit()
			c.close()
							 
try:
        #set up the connection to the database
        myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
        conn = psycopg2.connect(myConn)
        unique_pairs()
        cable_schools()
        update_allcable()
        for provider in ['comcast','twc','cox','charter','cablevision','top5']:
        	provider_school(provider)
        	provider_unique(provider)
        	update(provider)
        #	clean_tables(provider)
        now = time.localtime(time.time())
        print "local time:", time.asctime(now)
        
        
except psycopg2.ProgrammingError as e:
		# Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
		print "psycopg2 error code %s" % e.pgcode
		raise e
