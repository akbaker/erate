## ---------------------------------------------------------------------------
### VERSION 0.1 (for postgis)
### nces_pub_blockfips.py
### Created on: Feb. 26, 2014
### Created by: Allison Baker
### Federal Communications Commission 
##
## ---------------------------------------------------------------------------
##this script adds a block fips code for ea. obs. in the NCES public school table

##dependencies
##software
##runs in python
##postgres/gis (open geo suite)
##data
##import shape files for each state in the State list
##outputs one table as an append of every shape input
##uses a template shape (from the state of RI) which is truncated
##appends all others to this blank table

# Import system modules
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
theTBL = "nces_pub"
eq_prj = "4326"


def location():
		for myState in ["01","02","04","05","06","08","09","10","11","12","13","15","16",
				"17","18","19","20","21","22","23","24","25","26","27","28","29","30","31",
        		"32","33","34","35","36","37","38","39","40","41","42","44","45","46",
        		"47","48","49","50","51","53","54","55","56","60","69","72","78"]:
        		print myState
        		myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
       			conn = psycopg2.connect(myConn)
       			c = conn.cursor()
    			theSQL = "UPDATE " + schema + "." + theTBL
        		theSQL = theSQL + " SET block_fips=block_" + myState + ".geoid10"
    			theSQL = theSQL + " FROM census2010.block_" + myState 
        		theSQL = theSQL + " WHERE st_contains(block_" + myState + ".geom, " + theTBL + ".geom);"
        		theSQL = theSQL + "commit;"
        		print theSQL
        		c.execute(theSQL)

		
try:
        #set up the connection to the database
        myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
        conn = psycopg2.connect(myConn)
        theCur = conn.cursor()
        #add new column for block fips
    	dropSQL = "psql -p 5432 -h " + myHost + " " + db + " -c "
        dropSQL = dropSQL + "'ALTER TABLE " + schema + "." + theTBL 
        dropSQL = dropSQL + " DROP COLUMN" + " IF EXISTS" + " block_fips'"
        os.system(dropSQL)
        addSQL = "psql -p 5432 -h " + myHost + " " + db + " -c "
        addSQL = addSQL + "'ALTER TABLE " + schema + "." + theTBL 
        addSQL = addSQL + " ADD COLUMN" + " block_fips character(15)'"   
        os.system(addSQL)
        del theCur
        location()
        now = time.localtime(time.time())
        print "local time:", time.asctime(now)
except:
        print "something bad happened"     