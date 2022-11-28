#!/usr/bin/python3

import boto3,sys,os, sqlite3
from botocore.exceptions import ClientError

connection = sqlite3.connect("conf/stelthy.db")
cursor = connection.cursor()

f = open('nodes/' + os.environ['CLUSTER'] + '/' + os.environ['CLUSTER'] + '.out', 'r')
Lines = f.readlines()
cidr=[]
nn=""
sgid=[]
ipval=""

drive_ip=0
for line in Lines:
  l = line.strip()
  if l == "":
    continue

  if l.startswith("## "):
      n=l[4:5]
      continue

  ls = l.split()
  if l.startswith('node_public_ip'):
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"")
        cidr.append(ii)
        break
  if l.startswith('driver_public_ip'):
    drive_ip=1
    continue
  if drive_ip == 1:
    drive_ip=0
    for i in ls:
      ii = i.replace('"',"")
      ii = ii.replace(",","")
      cidr.append(ii)
      break
  if l.startswith('sg_id'):
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"")
        sgid.append(ii)

i=1
for x in sgid:
  row = cursor.execute("SELECT parent_region FROM regions \
    WHERE provider = ? and location = ?", [os.environ['CLOUD'], os.environ['N'+str(i)]]).fetchone()

  if not row:
    print("ERROR: provider/location (" + str(provider) + "/" + str(loct) + ") combo is not valid")
    sys.exit(1)

  i=i+1
  region = str(row[0])
  ec2 = boto3.client('ec2',region_name=region)
  for y in cidr:
    try:
      ipval=y+"/32"
      
      data = ec2.authorize_security_group_ingress( GroupId= x ,IpPermissions= [
            {'IpProtocol': 'tcp',
             'FromPort': 80,
             'ToPort': 80,
             'IpRanges': [{'CidrIp': ipval }]},
            {'IpProtocol': 'tcp',
             'FromPort': 22,
             'ToPort': 22,
             'IpRanges': [{'CidrIp': ipval}]},
	    {'IpProtocol': 'tcp',
             'FromPort': 5432,
             'ToPort': 5432,
             'IpRanges': [{'CidrIp': ipval}]}        
	])
      ##print('Ingress rule set: %s' % data)
    except ClientError as e:
      print(e)
