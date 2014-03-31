## ---------------------------------------------------------------------------
### VERSION 0.1 (for postgis)
### fiber_case2.py
### Created on: March 31, 2013
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
schema = "analysis"
theTBL = "nces_pub_full"
districtField = "leaid"


def fiber_marker(myDistrict):
	dCur = conn.cursor()
	theSQL2 = "UPDATE " + schema + "." + theTBL + " SET fiber_case2 = 1 "
	theSQL2 = theSQL2 + "FROM fabric.flat_item24_cxns_feb21, fabric.ben_nces_xwalk "
	theSQL2 = theSQL2 + "WHERE size_sort <= tot_fiber_lines "
	theSQL2 = theSQL2 + "AND flat_item24_cxns_feb21.ben=ben_nces_xwalk.ben "
	theSQL2 = theSQL2 + "AND ben_nces_xwalk.rev_nces_id=" + theTBL + "." + districtField + "; commit;"
	print theSQL2
	dCur.execute(theSQL2)
	dCur.close()

try:
	#set up the connection to the database
	myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
	conn = psycopg2.connect(myConn)
	theCur = conn.cursor()
	#get the total number of records to go through
	theSQL = "SELECT " + districtField + ", count(*) from " + schema + "." + theTBL
	theSQL = theSQL + " group by " + districtField + " order by count desc; "
	theCur.execute(theSQL)
	driver = theCur.fetchall()
	print "going to operate on this many school districts: " + str(theCur.rowcount)
	for r in driver:
		theDistrict = str(r[0])
		print "  working on district: " + theDistrict
		fiber_marker(theDistrict)	
	theCur.close()
	del theCur
	del conn, myConn
	now = time.localtime(time.time())
	print "local time:", time.asctime(now)
	
except psycopg2.ProgrammingError as e:
    # Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
    print "psycopg2 error code %s" % e.pgcode
    raise e
