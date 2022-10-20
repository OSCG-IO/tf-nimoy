import boto3
import os

os.chdir(sys.path[0])
f = open('my.out', 'r')
Lines = f.readlines()
nn=""
cidr=""
ipPerm=""i

ec2 = boto3.client('ec2')

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
        ii = i.replace('"',"'")
        cidr=cidr+ii + ","
        break
  if l.startswith('driver_public_ip'):
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"'")
        cidr=cidr+ii + ","  
        break

cidr=cidr[:-1]
ipPerm="""IpPermissions=[
            {'IpProtocol': 'tcp',
             'FromPort': 22,
             'ToPort': 22,
             'IpRanges': [{'CidrIp': """ + cidr + """}]},
            {'IpProtocol': 'tcp',
             'FromPort': 5432,
             'ToPort': 5432,
             'IpRanges': [{'CidrIp': """ + cidr + """}]}
        ]"""

print('Ingress Successfully Set %s' % ipPerm)
