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
d1=driver1-1

key="keys/${KEY_NAME:-dl-m1book-key.pem}"
usr=centos
SSH="ssh -i $key -o StrictHostKeyChecking=no"
SCP="scp -i $key -o StrictHostKeyChecking=no"



PASS=$(openssl rand -hex 8;)
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
##TODO: move key stuff to cat hosts ansible
$SCP $clDir/ansible_hosts_node  $usr@$d1:.
$SCP $clDir/ansible_hosts_driver  $usr@$d1:.
$SCP ansible/add-key.yml $usr@$d1:.
$SCP $clDir/demo.sql $usr@$d1:.

## Cat hosts to /etc/hosts on each VM
ansible-playbook -i $clDir/ansible_hosts_node --user centos --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" ansible/cat-hosts.yml

## Cat hosts to /etc/hosts on each VM
ansible-playbook -i $clDir/ansible_hosts_driver --user centos --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" ansible/cat-hosts.yml

$SSH $usr@$d1 'mkdir keys'
$SCP $key $usr@$d1:keys/.
$SSH $usr@$d1 'echo -e "\n\n\n" | ssh-keygen -t rsa'

## Add keys to each VM
$SSH $usr@$d1 "ansible-playbook -i ansible_hosts_node --user centos --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" add-key.yml"

## Add keys to each VM
$SSH $usr@$d1 "ansible-playbook -i ansible_hosts_driver --user centos --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" add-key.yml"

## Run io install, io start
ansible-playbook -i $clDir/ansible_hosts_node --user centos --key-file $key -e "PGV=$PGV PASS=$PASS PGFile=$clDir/.pgpass" ansible/io-install.yml

## Run io install, build demo, and set up password file
ansible-playbook -i $clDir/ansible_hosts_driver --user centos --key-file $key -e "PGV=$PGV PASS=$PASS PGFile=$clDir/.pgpass" ansible/demo-install.yml

