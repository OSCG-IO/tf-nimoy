#!/usr/bin/python3

import sys
import sqlite3

connection = sqlite3.connect("stelthy.db")


if len(sys.argv) != 4:
  print("ERROR: Three locations must be specified")
  sys.exit(1)

for i in range(1,len(sys.argv)):
  cursor = connection.cursor()
  loct = sys.argv[i]

  row = cursor.execute( \
    "SELECT location_nm, latitude, longitude \
       FROM locations \
      WHERE location = ?", (loct,)).fetchone()

  if not row:
    print("ERROR: '" + loct + "' is not valid")
    sys.exit(1)

  print(row)

#print ('Number of arguments:', len(sys.argv), 'arguments.')
#print ('Argument List:', str(sys.argv))

