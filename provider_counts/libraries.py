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
schTBL = "imls_lib"
schema2 = "nbm2013june"
nbm = "nbm2013june.shp_"
eq_prj = "4326"

#function for creating a table of library IDs and transtechs for each state
def unique_pairs():
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
		myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
		conn = psycopg2.connect(myConn)
		ctest = conn.cursor()
		for shp in ["block","address","road"]:
			ctest.execute("select * from information_schema.tables where table_name=%s", (myState.lower() + "_" + shp,))
			if bool(ctest.rowcount):
				print myState
				c = conn.cursor()
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".lib_transtech_" + myState + "_" + shp + "; "
				c.execute(dropSQL)
				print "drop successful"
				theSQL = "CREATE TABLE " + schema + ".lib_transtech_" + myState + "_" + shp + " AS "
				theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
				theSQL = theSQL + ", " + schema2 + "." + myState.lower() + "_" + shp 
				theSQL = theSQL + " WHERE st_contains(" + myState.lower() + "_" + shp + ".geom, " + schTBL + ".geom) "
				theSQL = theSQL + "AND stab = '" + str(myState) + "' AND lib_outype <> 'BS' GROUP BY lib_id, transtech"
				theSQL = theSQL + " ORDER BY lib_id, transtech; commit;"
				print theSQL
				c.execute(theSQL)
				conn.commit()
			c.close()
		ctest.close()

#function for creating a table of unique library IDs in cable areas
def cable_libs():
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
		myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
		conn = psycopg2.connect(myConn)
		ctest = conn.cursor()
		for shp in ["block","address","road"]:
			ctest.execute("select * from information_schema.tables where table_name=%s", ("lib_transtech_" + myState.lower() + "_" + shp,))
			if bool(ctest.rowcount):
				print myState
				print shp
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".lib_unique_cable_" + myState + "_" + shp + "; "
				c.execute(dropSQL)
				theSQL = "CREATE TABLE " + schema + ".lib_unique_cable_" + myState + "_" + shp + " AS "
				theSQL = theSQL + "SELECT lib_id, count(*) FROM " + schema + ".lib_transtech_"
				theSQL = theSQL + myState + "_" + shp + " WHERE transtech = '40' or transtech = '41'"
				theSQL = theSQL + " GROUP BY lib_id ORDER BY count desc;"
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
		for shp in ["block","address","road"]:
			ctest.execute("select * from information_schema.tables where table_name=%s", ("lib_unique_cable_" + myState.lower() + "_" + shp,))
			if bool(ctest.rowcount):
				print myState
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				theSQL = "WITH new_values AS(SELECT stab, count(*) AS tot_libs_cable"
				theSQL = theSQL + " FROM " + schema + ".lib_unique_cable_" + myState + "_" + shp + ", " + schema 
				theSQL = theSQL + "." + schTBL + " WHERE lib_unique_cable_" + myState + "_" + shp + ".lib_id=" 
				theSQL = theSQL + schTBL + ".lib_id" + " GROUP BY stab ORDER BY stab)"
				theSQL = theSQL + " UPDATE " + schema + ".lib_cable"
				theSQL = theSQL + " SET lib_allcable_" + shp + "=new_values.tot_libs_cable"
				theSQL = theSQL + " FROM new_values WHERE lib_cable.stab=new_values.stab"
				print theSQL
				c.execute(theSQL)
				conn.commit()
				c.close()
		ctest.close()


#function for creating a table of library IDs for cable providers in each state
def provider_lib(myProv):
	for myState in ["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
		"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
		"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
		"VI","VT","WA","WI","WV","WY"]:
			print myState
			myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
			conn = psycopg2.connect(myConn)
			c = conn.cursor()
			for shp in ["block","address","road"]:
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + ";"
				c.execute(dropSQL)
				if (myProv == 'comcast'):
					theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND stab = '" + str(myState) + "' AND (frn = '0001604818' or"
					theSQL = theSQL + " frn = '0001609585' or frn = '0003251717' or frn = '0003261914' or"
					theSQL = theSQL + " frn = '0003663796' or frn = '0003768165' or frn = '0004441663' or"
					theSQL = theSQL + " frn = '0006109623' or frn = '0013431911' or frn = '0014383657') "
					theSQL = theSQL + " AND lib_outype <> 'BS' GROUP BY lib_id, transtech ORDER BY lib_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'twc'):
					theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND stab = '" + str(myState)
					theSQL = theSQL + "' AND (frn = '0007556251' or frn = '0013430244') "
					theSQL = theSQL + "AND lib_outype <> 'BS' GROUP BY lib_id, transtech ORDER BY lib_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'cox'):
					theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND stab = '" + str(myState)
					theSQL = theSQL + "' AND (frn = '0001524461' or frn = '0001834696' or frn = '0020705760') "
					theSQL = theSQL + "AND lib_outype <> 'BS' GROUP BY lib_id, transtech ORDER BY lib_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'charter'):
					theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND stab = '" + str(myState)
					theSQL = theSQL + "' AND frn = '0017179383' AND lib_outype <> 'BS' "
					theSQL = theSQL + "GROUP BY lib_id, transtech ORDER BY lib_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'cablevision'):
					theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND stab = '" + str(myState)
					theSQL = theSQL + "' AND (frn = '0003510195' or frn = '0003735909' or frn = '0007001977') "
					theSQL = theSQL + "AND lib_outype <> 'BS' GROUP BY lib_id, transtech ORDER BY lib_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()
				if (myProv == 'top5'):
					theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + " AS "
					theSQL = theSQL + "SELECT lib_id, transtech FROM " + schema + "." + schTBL
					theSQL = theSQL + ", " + nbm + shp + " WHERE st_contains(shp_" + shp + ".geom, " + schTBL + ".geom) "
					theSQL = theSQL + "AND stab = '" + str(myState) + "' AND (frn = '0001604818' or"
					theSQL = theSQL + " frn = '0001609585' or frn = '0003251717' or frn = '0003261914' or"
					theSQL = theSQL + " frn = '0003663796' or frn = '0003768165' or frn = '0004441663' or"
					theSQL = theSQL + " frn = '0006109623' or frn = '0013431911' or frn = '0014383657' or"
					theSQL = theSQL + " frn = '0007556251' or frn = '0013430244' or frn = '0001524461' or"
					theSQL = theSQL + " frn = '0001834696' or frn = '0020705760' or frn = '0017179383' or"
					theSQL = theSQL + " frn = '0003510195' or frn = '0003735909' or frn = '0007001977') "
					theSQL = theSQL + "AND lib_outype <> 'BS' GROUP BY lib_id, transtech ORDER BY lib_id, transtech;"
					print theSQL
					c.execute(theSQL)
					conn.commit()	
			c.close()
				
#function for creating a list of unique school IDs by provider
def	provider_unique(myProv):
	for myState in ["AK","AS","AL","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
			"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
			"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
			"VI","VT","WA","WI","WV","WY"]:
		for shp in ["block","address","road"]:
				print myState
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".lib_" + myProv + "_unique_" + myState + "_" + shp + ";"
				c.execute(dropSQL)
				theSQL = "CREATE TABLE " + schema + ".lib_" + myProv + "_unique_" + myState + "_" + shp + " AS "
				theSQL = theSQL + "SELECT lib_id, count(*) FROM " + schema + ".lib_" + myProv
				theSQL = theSQL + "_" + myState + "_" + shp
				theSQL = theSQL + " WHERE transtech = '40' or transtech = '41' "
				theSQL = theSQL + "GROUP BY lib_id ORDER BY count desc;"
				print theSQL
				c.execute(theSQL)
				conn.commit()
				c.close()
			
#function for matching NCES id to table and then updating primary table
def update(myProv):
	for myState in ["AK","AS","AL","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
			"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
			"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
			"VI","VT","WA","WI","WV","WY"]:
			for shp in ["block","address","road"]:
				print myState
				myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
				conn = psycopg2.connect(myConn)
				c = conn.cursor()
				theSQL = "WITH new_values AS(SELECT stab, count(*) AS tot_libs_" + myProv
				theSQL = theSQL + " FROM " + schema + ".lib_" + myProv + "_unique_" + myState + "_" + shp + ", " + schema 
				theSQL = theSQL + "." + schTBL + " WHERE lib_" + myProv + "_unique_" + myState + "_" + shp + ".lib_id=" 
				theSQL = theSQL + schTBL + ".lib_id" 
				theSQL = theSQL + " GROUP BY stab ORDER BY stab)"
				theSQL = theSQL + " UPDATE " + schema + ".lib_cable"
				theSQL = theSQL + " SET lib_" + myProv + "_" + shp + "=new_values.tot_libs_" + myProv
				theSQL = theSQL + " FROM new_values WHERE lib_cable.stab=new_values.stab"
				print theSQL
				c.execute(theSQL)
				conn.commit()

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
				dropSQL = "DROP TABLE IF EXISTS " + schema + ".lib_" + myProv + "_" + myState + "_" + shp + ";"
				c.execute(dropSQL)
				dropSQL2 = "DROP TABLE IF EXISTS " + schema + ".lib_" + myProv + "_unique_" + myState + "_" + shp + ";"
				c.execute(dropSQL2)
				dropSQL3 = "DROP TABLE IF EXISTS " + schema + ".lib_" + myProv + "_" + myState.lower() + ";"
				c.execute(dropSQL3)
				dropSQL4 = "DROP TABLE IF EXISTS " + schema + ".lib_transtech_" + myState + "_" + shp + "; "
				c.execute(dropSQL4)
				dropSQL5 = "DROP TABLE IF EXISTS " + schema + ".lib_unique_cable_" + myState + "_" + shp + "; "
				c.execute(dropSQL5)
				conn.commit()
			c.close()
	
							 
try:
        #set up the connection to the database
        myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
        conn = psycopg2.connect(myConn)
        unique_pairs()
        cable_libs()
        update_allcable()
        for provider in ['comcast','twc','cox','charter','cablevision','top5']:
        	provider_lib(provider)
        	provider_unique(provider)
        	update(provider)
        	#clean_tables(provider)
        now = time.localtime(time.time())
        print "local time:", time.asctime(now)
          
except psycopg2.ProgrammingError as e:
		# Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
		print "psycopg2 error code %s" % e.pgcode
		raise e
