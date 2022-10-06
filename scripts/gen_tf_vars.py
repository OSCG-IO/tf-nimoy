#!/usr/bin/python3

import sys, sqlite3

kount = 0
connection = sqlite3.connect("../conf/stelthy.db")

if len(sys.argv) < 3 or len(sys.argv) > 4:
  print("ERROR: Two or three parms must be specified: provider location [zone]")
  sys.exit(1)


############### MAINLINE ######################
provider = sys.argv[1]
loct = sys.argv[2]
zone = ""
if len(sys.argv) == 4:
  zone = sys.argv[3]

cursor = connection.cursor()

row = cursor.execute( \
  "SELECT region, location_nm, parent_region, avail_zones, image_id \
     FROM v_regions \
    WHERE provider = ? and location = ?", [provider, loct]).fetchone()

if not row:
  print("ERROR: provider/location combo is not valid")
  sys.exit(1)

region = str(row[0])
location_nm = str(row[1])
parent_region = str(row[2])
avail_zones = str(row[3])
image_id = str(row[4])

if zone == "":
  zone = "a"

az = (region + zone)

print('variable "provider"    { default = "' + provider + '" }')
print('variable "location"    { default = "' + loct + '" }')
print('variable "location_nm" { default = "' + location_nm + '" }')

print('variable "region"      { default = "' + parent_region + '" }')
if region != parent_region:
  print('variable "group"       { default = "' + az + '" }')

print('variable "az"          { default = "' + az + '" }')
print('variable "image"       { default = "' + image_id + '" }')
print('variable "key"         { default = "dl-m1book-key" }')

