#!/bin/bash
cd "$(dirname "$0")"
cd ..

cluster=$1
clDir=$PWD/nodes/$cluster
rm $clDir/.pgpass

if [ ! -f "$clDir/env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi
source $clDir/env.sh

key="keys/${KEY_NAME:-dl-m1book-key.pem}"
usr=centos
PASS=$(openssl rand -hex 8;)

## Construct pgpass
echo "localhost:5432:*:postgres:$PASS" >> $clDir/.pgpass
echo "127.0.0.1:5432:*:postgres:$PASS" >> $clDir/.pgpass
input="$clDir/ansible_hosts_node"
item=1
while IFS= read -r line
do
   if [[ $line == "[hosts]" ]]; then
      continue
   elif [[ $line == "" ]]; then
      break
   else
      echo "node${item}-1:5432:*:postgres:$PASS" >> $clDir/.pgpass
      echo "$line:5432:*:postgres:$PASS" >> $clDir/.pgpass
      item=$((item+1))
   fi
done < "$input"

echo "Configuring Nodes"

## Cat hosts to /etc/hosts on each VM
ansible-playbook -i $clDir/ansible_hosts_node --user $usr --key-file $key ansible/cat-hosts.yml

## Add keys to each VM
ansible-playbook -i $clDir/ansible_hosts_node --user $usr --key-file $key -e "KEYFILE=../${key/.pem/.pub}" ansible/add-key.yml

## Run io install, io start
ansible-playbook -i $clDir/ansible_hosts_node --user $usr --key-file $key -e "PGV=$PGV PASS=$PASS PGFile=$clDir/.pgpass" ansible/io-install.yml

if [[ $DEMO=="True" ]]; then
  echo "Configuring Drivers"

  ## Cat hosts to /etc/hosts on each VM
  ansible-playbook -i $clDir/ansible_hosts_driver --user $usr --key-file $key ansible/cat-hosts.yml

  ## Add keys to each VM
  ansible-playbook -i $clDir/ansible_hosts_driver --user $usr --key-file $key -e "KEYFILE=../${key/.pem/.pub}" ansible/add-key.yml

  ## Run io install, build demo, and set up password file
  ansible-playbook -i $clDir/ansible_hosts_driver --user $usr --key-file $key -e "PGV=$PGV PASS=$PASS PGFile=$clDir/.pgpass DEMSQL=$clDir/demo.sql" ansible/demo-install.yml
  rm $clDir/demo.sql
fi

##rm $clDir/.pgpass
##rm $clDir/ansible_hosts*

echo "Database Cluster Ready"

