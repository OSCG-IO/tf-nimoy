#!/bin/bash
cd "$(dirname "$0")"
cd ..

cluster=$1
clDir=$PWD/nodes/$cluster

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
while IFS= read -r line
do
   if [[ $line == "[hosts]" ]]; then
      continue
   elif [[ $line == "" ]]; then
      break
   else
      echo "$line:5432:*:postgres:$PASS" >> $clDir/.pgpass
   fi
done < "$input"

echo "using key: $key"
echo "Configuring Nodes"

## Cat hosts to /etc/hosts on each VM
ansible-playbook -i $clDir/ansible_hosts_node --user $usr --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" ansible/cat-hosts.yml

## Add keys to each VM
ansible-playbook -i ansible_hosts_node --user $usr --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" add-key.yml

## Run io install, io start
ansible-playbook -i $clDir/ansible_hosts_node --user $usr --key-file $key -e "PGV=$PGV PASS=$PASS PGFile=$clDir/.pgpass" ansible/io-install.yml

if [[ $DEMO=="True" ]]; then
  echo "Configuring Drivers"
  d1=driver1-1
  SCP="scp -i $key -o StrictHostKeyChecking=no"
  $SCP $clDir/demo.sql $usr@$d1:.

  ## Cat hosts to /etc/hosts on each VM
  ansible-playbook -i $clDir/ansible_hosts_driver --user $usr --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" ansible/cat-hosts.yml

  ## Add keys to each VM
ansible-playbook -i ansible_hosts_driver --user $usr --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" add-key.yml

  ## Run io install, build demo, and set up password file
  ansible-playbook -i $clDir/ansible_hosts_driver --user $usr --key-file $key -e "PGV=$PGV PASS=$PASS PGFile=$clDir/.pgpass" ansible/demo-install.yml
fi

