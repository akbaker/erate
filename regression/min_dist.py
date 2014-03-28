## ---------------------------------------------------------------------------
### VERSION 0.1 (for postgis)
### erate_mindist.py
### Created on: Jan. 23, 2014
### Created by: Allison Baker
### Federal Communications Commission 
##
## ---------------------------------------------------------------------------
##this script calculates the minimum distance to existing fiber source

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
theTBL = "nces_optring"
eq_prj = "3786"

#function for finding the closest existing fiber source based on NBM classes
def closest_fiber(myGID):
        dCur = conn.cursor()
        theSQL = "SELECT least(address, block, cai, middlemile, road) "
        theSQL = theSQL + "FROM " + schema + "." + theTBL 
        theSQL = theSQL + " WHERE gid = " + str(myGID)
        theSQL = theSQL + " LIMIT 1"
        dCur.execute(theSQL)
        #print "test pt1"
        if dCur.rowcount == 1:
                #update theTable with the distance
                r = dCur.fetchone()
                theDist = r[0]
                upd_val("min_dist", theDist, myGID)
            	#print "test pt2"
        dCur.close()


#function for updating values
def upd_val(myField, myVal, myID):
        uCur = conn.cursor()
        theSQL = "UPDATE " + schema + "." + theTBL + " set " + myField + " = " + str(myVal) 
        theSQL = theSQL + " where gid = " + str(myID)
        uCur.execute(theSQL)                        
        conn.commit()
        uCur.close()


try:
        #set up the connection to the database
        myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
        conn = psycopg2.connect(myConn)
        theCur = conn.cursor()
        #add new column for minimum distance
        dropSQL = "ALTER " + schema + "." + theTBL 
        dropSQL = dropSQL + " DROP COLUMN" + " IF EXISTS" + " min_dist"
        os.system(dropSQL)
        addSQL = "ALTER " + schema + "." + theTBL
        addSQL = addSQL + " ADD COLUMN" " min_dist" + " numeric"   
        os.system(addSQL)     
        #get the total number of records to go through
        theSQL = "SELECT max(gid) from " + schema + "." + theTBL + ";"
        theCur.execute(theSQL)
        theID = theCur.fetchone()[0]
        theCur.close()
        del theCur
        print "going to be operating on this many locations: " + str(theID)
        i = 1
        while i <= theID:
        #while i <= 50:
                print "    begining work on row: " + str(i)
                closest_fiber(i)
                i = i + 1
        now = time.localtime(time.time())
        print "local time:", time.asctime(now)
except:
        print "something bad happened"     
