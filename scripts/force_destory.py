#!/usr/bin/python3

import boto3,sys,os, sqlite3
from botocore.exceptions import ClientError

cluster=sys.argv[1]
cloud=sys.argv[2]
location=sys.argv[3]
connection = sqlite3.connect("conf/stelthy.db")
cursor = connection.cursor()

row = cursor.execute("SELECT parent_region FROM regions \
    WHERE provider = ? and location = ?", [cloud, location]).fetchone()

if not row:
  print("ERROR: provider/location (" + str(cloud) + "/" + str(location) + ") combo is not valid")
  sys.exit(1)

region = str(row[0])
ec2 = boto3.client('ec2',region_name=region)
     
sn_all = ec2.describe_subnets()
for sn in sn_all['Subnets'] :
  if 'Tags' not in sn:
    continue
  for tag in sn['Tags']:
    if tag['Key'] != 'Name': continue
    print(tag['Value'])
    if tag['Value'].startswith(cluster):
      ec2.delete_subnet(SubnetId=sn[id])
               

 
