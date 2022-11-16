#!/usr/bin/python3

import sys, sqlite3, os

os.chdir(sys.path[0])

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

opsys = os.getenv("OPSYS", "")
plat = os.getenv("PLATFORM", "")

if ((opsys == "") or (plat == "")):
  print("ERROR: The OPSYS & PLATFORM environment variables both need to be set")
  sys.exit(1)

cursor = connection.cursor()

##print("DEBUG: " + provider + ", " + loct + ", " + opsys + ", " + plat)

row = cursor.execute( \
  "SELECT region, location_nm, parent_region, avail_zones, image_id \
     FROM v_images \
    WHERE provider = ? and location = ? and os = ? and platform = ?", [provider, loct, opsys, plat]).fetchone()

if not row:
  print("ERROR: provider/location (" + str(provider) + "/" + str(loct) + ") combo is not valid")
  sys.exit(1)

region = str(row[0])
location_nm = str(row[1])
parent_region = str(row[2])
avail_zones = str(row[3])
image_id = str(row[4])

if zone == "":
  zone = "a"

az = (region + zone)

print('variable "pvdr"        { default = "' + provider + '" }')
print('variable "opsys"       { default = "' + opsys + '" }')
print('variable "platform"    { default = "' + plat + '" }')
print('variable "location"    { default = "' + loct + '" }')
print('variable "location_nm" { default = "' + location_nm + '" }')

print('variable "rgn"         { default = "' + parent_region + '" }')
if region != parent_region:
  print('variable "group"       { default = "' + az + '" }')

print('variable "az"          { default = "' + az + '" }')
print('variable "image"       { default = "' + image_id + '" }')
print('variable "key"         { default = "dl-m1book-key" }')

