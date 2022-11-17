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

echo "using key: $key"

$SCP $clDir/ansible_hosts  $usr@$d1:.
$SCP ansible/add-key.yml $usr@$d1:.

## Cat hosts to /etc/hosts on each VM
ansible-playbook -i $clDir/ansible_hosts --user centos --key-file $key ansible/cat-hosts.yml

$SSH $usr@$d1 'mkdir keys'
$SCP $key $usr@$d1:keys/.
$SSH $usr@$d1 'echo -e "\n\n\n" | ssh-keygen -t rsa'

## Add keys to each VM
$SSH $usr@$d1 "ansible-playbook -i ansible_hosts --user centos --key-file $key -e \"key=/home/centos/.ssh/id_rsa.pub\" add-key.yml"

## Run io install and build bmsql, set up password file
ansible-playbook -i $clDir/ansible_hosts_driver --user centos --key-file $key -e "PGV=$PGV" ansible/io-install.yml
pw='echo '
pw+=$PASS
pw+=' >> test/tf-nimoy/remote/.pword'
$SSH $usr@driver1-1 "$pw"

