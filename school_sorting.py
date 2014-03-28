## ---------------------------------------------------------------------------
### VERSION 0.1 (for postgis)
### school_sorting.py
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
schema = "analysis"
theTBL = "nces_pub_full"
districtField = "leaid"


def school_sort(myDistrict): 
	dCur = conn.cursor()
	#sort schools within districts by level and size
	theSQL = "SELECT school_id, " + districtField + " from "
	theSQL = theSQL + schema + "." + theTBL + " WHERE " + districtField + "= '" + myDistrict 
	theSQL = theSQL + "' AND tot_students > 0;" 
	print theSQL
	dCur.execute(theSQL)
	theCnt = dCur.rowcount
	myCnt = 1
	dCur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
	#sort schools within districts by level and size
	theSQL2 = "SELECT " + districtField + ", school_id, school_level, tot_students from "
	theSQL2 = theSQL2 + schema + "." + theTBL + " WHERE " + districtField + " = '" + myDistrict
	theSQL2 = theSQL2 + "' AND tot_students > 0"
	theSQL2 = theSQL2 + " ORDER BY " + districtField + ", school_level, tot_students desc;"
	dCur.execute(theSQL2)
	while myCnt <= theCnt:
		rec = dCur.fetchone()
		print str(myCnt) + " out of " + str(theCnt)
		#print rec['school_id']
		update_value(myCnt, rec['school_id'])
		myCnt = myCnt + 1
	dCur.close()

def update_value (myVal, myID):
	print myID
	print myVal
	uCur = conn.cursor()
	theSQL = "UPDATE " + schema + "." + theTBL + " SET size_sort = " + str(myVal)
	theSQL = theSQL + " WHERE school_id = '" + str(myID) + "'; commit;"
	uCur.execute(theSQL)
	conn.commit()
	uCur.close()

		
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
		#run optimal
		school_sort(theDistrict)	
	theCur.close()
	del theCur
	del conn, myConn
	now = time.localtime(time.time())
	print "local time:", time.asctime(now)
	
except psycopg2.ProgrammingError as e:
    # Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
    print "psycopg2 error code %s" % e.pgcode
    raise e
