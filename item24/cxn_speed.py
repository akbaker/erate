## ---------------------------------------------------------------------------
### VERSION 0.1 (for postgis)
### cxn_speed.py
### Created on: March 28, 2013
### Created by: Allison Baker
### Federal Communications Commission 
##
## ---------------------------------------------------------------------------


##dependencies
##software
##runs in python
##postgres/gis (open geo suite)
##the psycopg library
##data

##uses epsg 102010 - http://spatialreference.org/ref/esri/102010/
##the output table "theTBL' variable below, needs to have the following fields to 
##size_sort (integer)


# Import system modules
import sys, string, os
import psycopg2
import time
from psycopg2.extras import RealDictCursor
now = time.localtime(time.time())
print "local time:", time.asctime(now)

#variables
myHost = "localhost"
myPort = "5432"
myUser = "postgres"
db = "allison"

	
try:
	#set up the connection to the database
	myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
	conn = psycopg2.connect(myConn)
	theCur = conn.cursor()
	#get the total number of records to go through
	theSQL = "SELECT ben" 
	theSQL = theSQL + " FROM fabric.item24_cxns_mar28_expanded"
	theSQL = theSQL + " GROUP BY ben;"
	theCur.execute(theSQL)
	print theSQL
	driver = theCur.fetchall()
	for r in driver:
		theSQL2 = "SELECT * FROM fabric.item24_cxns_mar28_expanded"
		theSQL2 = theSQL2 + " WHERE ben = '" + str(r[0]) + "'"
		theSQL2 = theSQL2 + " ORDER BY download_speed DESC;"
		theCur.execute(theSQL2)
		print theSQL2
		cxns = theCur.fetchall()
		print cxns
		for i in cxns:
			lines = i[5]
			j = 1
			while j < lines:
				print j
				print lines
				theSQL3 = "INSERT INTO fabric.item24_cxns_mar28_expanded"
				theSQL3 = theSQL3 + " VALUES ('" + str(i[0]) + "', '" + str(i[1])
				theSQL3 = theSQL3 + "', '" + str(i[2]) + "', '" + str(i[3]) + "', '"
				theSQL3 = theSQL3 + str(i[4]) + "', " + str(i[5]) + ", " + str(i[6]) + "); commit;"
				print theSQL3
				theCur.execute(theSQL3)
				j = j + 1
		conn.commit()	
	theCur.close()
	del theCur
	del conn, myConn
	now = time.localtime(time.time())
	print "local time:", time.asctime(now)
	
except psycopg2.ProgrammingError as e:
    # Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
    print "psycopg2 error code %s" % e.pgcode
    raise e
