#!/bin/bash
cd "$(dirname "$0")"
cd ..

command=$1
cluster=$2
json_file=$3

clDir=$PWD/nodes/$cluster
json=$clDir/$json_file

if [ ! -f "$json" ]; then
  echo $json
  echo "FATAL ERROR: missing json file"
  exit 1
fi

python3 scripts/nimoy.py $command $cluster $json
