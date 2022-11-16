#!/usr/bin/python3

import sys, sqlite3, os
os.chdir(sys.path[0])
connection = sqlite3.connect("../conf/stelthy.db")
cursor = connection.cursor()

max=len(sys.argv)
nodes=sys.argv[1:max]
id=1
for i in nodes:
   row = cursor.execute("SELECT country FROM locations WHERE location = '" + i + "'").fetchone()
   if not row:
      print("ERROR: provider/location (" + str(provider) + "/" + str(loct) + ") combo is not valid")
      sys.exit(1)
   print("UPDATE bmsql_warehouse SET w_location='" + i + "' , w_country='" + str(row[0]) + "' WHERE w_id=" + str(id) + ";")
   print("UPDATE bmsql_customer SET c_location='" + i + "' , c_country='" + str(row[0]) + "' WHERE c_w_id=" + str(id) + ";")
   id=id+1
