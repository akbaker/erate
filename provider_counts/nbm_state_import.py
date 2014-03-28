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
schema = "nbm2013june"
srcdir = "/users/FCC/Documents/allison/data/nbm_by_state/output"
theEPSG = "4326"

#function for importing table files
def import_table(myState,myShp):
		print myState
		thepSQL = "psql -p 5432 -h " + myHost + " " + db + " -c "
		thepSQL = thepSQL + "'DROP TABLE if exists " + schema + "." + myState + "_" + myShp +  "'"
		os.system(thepSQL)
		srcshp = srcdir + "/" + myState + "_" + myShp + ".shp"
		print srcshp
		myFile = srcdir + '/' + myState + '_' + myShp + '.shp'
		print myFile
		if os.path.isfile(myFile):
			print "file exists"
			thepSQL = "shp2pgsql -s " + theEPSG + " -I -W latin1 -g geom " + srcshp + " " + schema + "."
			thepSQL = thepSQL + myState + "_" + myShp + " " +  db + " | psql -p 5432 -h localhost " + db
			os.system(thepSQL)
		else:
			print "skipping " + myState + "_" + myShp
							
try:
	for state in ["AS"]:
	#["AK","AL","AS","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","ID","IL",
	#	"IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MP","MT","NE","NV","NH",
	#	"NJ","NM","NY","NC","ND","OH","OK","OR","PA","PR","RI","SC","TN","TX","UT","VA",
	#	"VI","VT","WA","WI","WV","WY"]:
		for shp in ["Block","Road","Address"]:
			import_table(state,shp)

except psycopg2.ProgrammingError as e:
		# Err code lookup at http://www.postgresql.org/docs/9.1/static/errcodes-appendix.html
		print "psycopg2 error code %s" % e.pgcode
		raise e
