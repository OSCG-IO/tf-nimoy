#!/bin/bash
cd "$(dirname "$0")"
cd ..

cluster=$1

setupEtcHosts () {
  $SCP hosts          $usr@$1:.
  $SCP catHosts.sh    $usr@$1:.
  $SSH $usr@$1 'sudo ./catHosts.sh'
}

clDir=$PWD/nodes/$cluster

if [ ! -f "$clDir/env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi
source $clDir/env.sh
NODE_KOUNT=`find $clDir/. -mindepth 1 -maxdepth 1 -type d | wc -l`

d1=driver1-1

key="keys/dl-m1book-key.pem"
usr=centos
SSH="ssh -i $key -o StrictHostKeyChecking=no"
SCP="scp -i $key -o StrictHostKeyChecking=no"
PASS=$(openssl rand -hex 8;)

$SCP $clDir/ansible_hosts  $usr@$d1:.
$SCP ansible/add-key.yml    $usr@$d1:.

for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
do
  setupEtcHosts driver${i}-1
  setupEtcHosts node${i}-1
done 

$SSH $usr@$d1 'mkdir keys'
$SCP $key $usr@$d1:keys/.
$SSH $usr@$d1 'echo -e "\n\n\n" | ssh-keygen -t rsa'

$SSH $usr@$d1 'ansible-playbook add-key.yml -i ansible_hosts --user centos --key-file keys/dl-m1book-key.pem  -e "key=/home/centos/.ssh/id_rsa.pub"'
$SSH $usr@$d1 'sudo ./catHosts.sh'

ansible-playbook -i $clDir/ansible_hosts_driver --user centos --key-file keys/dl-m1book-key.pem -e "PGV=$PGV" ansible/io-install.yml
pw='echo '
pw+=$PASS
pw+=' >> test/tf-nimoy/remote/.pword'
$SSH $usr@driver1-1 "$pw"

