#!/usr/bin/python3

import boto3,sys,os,json
from secrets import token_bytes
from base64 import b64encode
from botocore.exceptions import ClientError
from subprocess import check_output


def print_error(p_error):
  print('')
  print('ERROR: ' + p_error)
  return


## ---- Main functions to execute on nodes
def run_spock(node_ip,io_cmd):
  ##print(io_cmd)
  cmd="ssh centos@" + node_ip + " \"cd /db/oscg && ./io spock " + io_cmd + " --json \""
  out = check_output(cmd, shell=True).decode('utf-8')
  data = json.loads(out)
  ##print(json.dumps(data))
  return data


def run_io(node_ip,io_cmd):
  ##print(io_cmd)
  cmd="ssh centos@" + node_ip + " \"cd /db/oscg && ./io " + io_cmd + " --json \""
  out = check_output(cmd, shell=True).decode('utf-8')
  data = json.loads(out)
  ##print(json.dumps(data))
  return data
    

## ---- Basic Spock Commands
def create_node(db, node_id, ip):
  print("Creating Spock Nodes for: " + node_id)
  dns="host=localhost user=replication  dbname=" + db
  io_cmd="create-node " + node_id  + " '" + dns + "' " + db
  data=run_spock(ip,io_cmd)
  return data


def create_replication_set(db, node_id, ip):
  print("Creating Replication Set for: " + node_id)
  io_cmd="create-replication-set " + db  + "_replication_set " + db
  data=run_spock(ip,io_cmd)
  return data


def show_subscription_status(db, node_id, ip):
  print("Showing Subscription Status for: " + node_id)
  io_cmd="show-subscription-status all " + db 
  data=run_spock(ip,io_cmd)
  return data


def get_pii_columns():
  db=parsed_json["dbname"]
  io_cmd="get-pii-columns " + db
  data=run_spock(parsed_json[0]["ip"],io_cmd)
  return data


def get_replication_rules():
  db=parsed_json["dbname"]
  io_cmd="get-replication-tables " + db
  data=run_spock(parsed_json[0]["ip"],io_cmd)
  return data


def replication_set_add_table(db, node_id, ip, table, col):
  print("Adding Table: " + table  + " to Replication Set")
  ## TODO: Find right formmating to pass col
  io_cmd="replication-set-add-table " + db + " " + db + "_replication_set " + table
  data=run_spock(ip,io_cmd) 
  return data


## ---- Business Logic to run full set ups
def run_for(function,nodes):
  if nodes == "all":
    db=parsed_json["dbname"]
    for i in parsed_json["nodes"]:
      data=globals()[function](db, i["nodename"], i["ip"])
      print(json.dumps(data))


def add_tables_with_pii(db, node_id, ip):
  io_cmd="get-replication-tables " + db
  data=run_spock(ip,io_cmd)
  ##print(json.dumps(data))
  for i in data:
    data2=replication_set_add_table(db, node_id, ip,i["table_name"], i["array_agg"])
  return data2


## ---- Basic io Commands
def io_status(db,node_id,ip):
  io_cmd="status"
  data=run_io(ip,io_cmd)
  return data



## ---- Main Block
command=sys.argv[1]
cluster=sys.argv[2]
nodes_to_process=sys.argv[3]
json_file=sys.argv[4]

try:
  with open(json_file) as f:
    parsed_json = json.load(f)
except Exception as e:
  print_error(p_errordata)

command=command.replace("-","_")

rc = run_for(command,nodes_to_process)


## ---- Leftover code
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
