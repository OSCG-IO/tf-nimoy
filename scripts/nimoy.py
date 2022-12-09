#!/usr/bin/python3

import boto3,sys,os,json
from secrets import token_bytes
from base64 import b64encode
from botocore.exceptions import ClientError

command=sys.argv[1]
cluster=sys.argv[2]
json_file=sys.argv[3]

with open(json_file) as f:
  parsed_json = json.load(f)

if command=="updatePass":
  nodei=1;
  pg_pass_file=""
  new_pass=b64encode(token_bytes(32)).decode()
  rep_user_pass=b64encode(token_bytes(32)).decode()
  print("Starting Password Reset")
  if parsed_json["samePass"]=="true":
    for i in parsed_json["nodes"]:
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \"ALTER ROLE postgres WITH PASSWORD '" + new_pass + "';\"")
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \"DROP ROLE IF EXISTS replication;\"")
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \"CREATE ROLE replication WITH SUPERUSER REPLICATION LOGIN ENCRYPTED PASSWORD '" + rep_user_pass +"';\"")
      pg_pass_file=pg_pass_file + "node" + str(nodei) + "-1:5432:*:postgres:" + new_pass + "\n"
      pg_pass_file=pg_pass_file + i["ip"] + ":5432:*:postgres:" + new_pass + "\n"
      pg_pass_file=pg_pass_file + "node" + str(nodei) + "-1:5432:*:replication:" + rep_user_pass + "\n"
      pg_pass_file=pg_pass_file + i["ip"] + ":5432:*:replication:" + rep_user_pass + "\n"
      nodei=nodei+1
  pg_pass_file="localhost:5432:*:postgres:" + new_pass + "\n" + pg_pass_file
  pg_pass_file="localhost:5432:*:replication:" + rep_user_pass + "\n" + pg_pass_file
  print(pg_pass_file) 

if command=="create-node":
  nodei=1;
  print("Creating All Spock Nodes")
  db=parsed_json["dbname"]
  for i in parsed_json["nodes"]:
    dns="host=" + i["ip"] + " port=5432 user=replication dbname=" + db
    io_cmd="\"cd /db/oscg && ./io spock create-node node" + str(nodei) + " '" + dns + "' " + db  +"\""
    cmd="ssh centos@" + i["ip"] + " " + io_cmd
    data = os.system(cmd)
    nodei=nodei+1
    print(data)

if command=="show-subscription-status":
  nodei=1;
  print("Showing All Subscription Status")
  db=parsed_json["dbname"]
  for i in parsed_json["nodes"]:
    io_cmd="\"cd /db/oscg && ./io spock show-subscription-status all " + db + "\"" 
    cmd="ssh centos@" + i["ip"] + " " + io_cmd
    data = os.system(cmd)
    nodei=nodei+1
    print(data)

if command=="create-replication-set":
  print("Creating All Replication Sets")
  db=parsed_json["dbname"]
  for i in parsed_json["nodes"]:
    io_cmd="\"cd /db/oscg && ./io spock create-replication-set " + db  + "_replication_set " + db + "\""
    cmd="ssh centos@" + i["ip"] + " " + io_cmd
    data = os.system(cmd)
    print(data)

if command=="get-replication-rules":
  db=parsed_json["dbname"]
  cmd="ssh centos@" + parsed_json["nodes"][0]["ip"] + " \"cd /db/oscg && ./io spock get-replication-tables " + db + " --json \""
  data = os.system(cmd)
  print(data)

if command=="replication-set-add-table":
  print("Adding Table to All Replication Sets")
  db=parsed_json["dbname"]
  tab="bmsql_item"
  for i in parsed_json["nodes"]:
    io_cmd="\"cd /db/oscg && ./io spock replication-set-add-table " + db + " " + db + "_replication_set " + tab + "\""
    cmd="ssh centos@" + i["ip"] + " " + io_cmd
    data = os.system(cmd)
    print(data)
