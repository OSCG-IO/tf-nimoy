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

if command=="initReplication":
  nodei=1;
  print("Starting Replication Set Up")
  if parsed_json["samePass"]=="true":
    for i in parsed_json["nodes"]:
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \" spock.create_replication_set('spock_replication_set', true, true, true, true);\"")    
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \"SELECT table_name from pg_catalog\"")
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \"SELECT * from spock.pii\"")      
      print("psql -h " + i["ip"] + " -U postgres --password " + i["pass"] + "-c \"select spock.replication_set_add_table('bmsql_set', '$table')\"")      
