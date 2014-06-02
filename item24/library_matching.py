## ---------------------------------------------------------------------------
### VERSION 0.1 (for postgis)
### ben_matching.py
### Created on: May 23, 2013
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
	theSQL = "SELECT frn" 
	theSQL = theSQL + " FROM fabric.item24_cxns_mar28_expanded"
	theSQL = theSQL + " GROUP BY frn;"
	theCur.execute(theSQL)
	numfrn = theCur.rowcount
	counter = 1
	driver = theCur.fetchall()
	for r in driver:
		print "processing frn " + str(counter) + " out of " + str(numfrn)
		counter = counter + 1
		theSQL2 = "SELECT * FROM fabric.block4_cxns_libonly"
		theSQL2 = theSQL2 + " WHERE frn = '" + str(r[0]) + "'"
		theSQL2 = theSQL2 + " AND size_sort IS NOT NULL"
		theSQL2 = theSQL2 + " ORDER BY frn, size_sort;"
		theCur.execute(theSQL2)
		schools = theCur.fetchall()
		theSQL3 = "SELECT * FROM fabric.item24_cxns_mar28_expanded"
		theSQL3 = theSQL3 + " WHERE frn = '" + str(r[0]) + "'"
		theSQL3 = theSQL3 + " ORDER BY download_speed DESC;"
		theCur.execute(theSQL3)
		cxns = theCur.fetchall()
		for i,j in zip(schools, cxns):
			theSQL4 = "UPDATE fabric.block4_cxns_libonly"
			theSQL4 = theSQL4 + " SET type_cxn = '" + str(j[4]) + "'"
			theSQL4 = theSQL4 + " WHERE frn = '" + str(i[0]) + "'; commit; "
			theCur.execute(theSQL4)		
			theSQL5 = "UPDATE fabric.block4_cxns_libonly"
			theSQL5 = theSQL5 + " SET download_speed = " + str(j[6])
			theSQL5 = theSQL5 + " WHERE frn = '" + str(i[0]) + "'; commit;"
			theCur.execute(theSQL5)
	theCur.close()
	del theCur
	del conn, myConn
	now = time.localtime(time.time())
	print "local time:", time.asctime(now)
	
except psycopg2.ProgrammingError as e:
    # Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
    print "psycopg2 error code %s" % e.pgcode
    raise e
