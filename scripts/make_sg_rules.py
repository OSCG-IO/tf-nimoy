#!/usr/bin/python3

import boto3,sys,os, sqlite3
from botocore.exceptions import ClientError

f = open('nodes/' + os.environ['CLUSTER_NM'] + '/' + os.environ['CLUSTER_NM'] + '.out', 'r')
Lines = f.readlines()
cidr=[]
nn=""
sgid=[]
ipval=""

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
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"")
        cidr.append(ii)  
        break
  if l.startswith('sg_id'):
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"")
        sgid.append(ii)

for x in sgid:
  ec2 = boto3.client('ec2',region_name='us-west-2')
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
      print('Ingress rule set: %s' % data)
    except ClientError as e:
      print(e)
