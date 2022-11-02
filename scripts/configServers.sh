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

$SCP ansible_hosts  $usr@$d1:.
$SCP add-key.yml    $usr@$d1:.

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

bs='cd test/tf-nimoy/remote/benchmarksql; /home/centos/apache-ant-1.9.16/bin/ant'
io='python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"; cd oscg; ./io install pg'
io+=$PGV
io+='; touch /home/centos/.pgpass; chmod 600 /home/centos/.pgpass'
pw='echo '
pw+=$PASS
pw+=' >> test/tf-nimoy/remote/.pword'

for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
do
  $SSH $usr@driver${i}-1 "$bs"
  $SSH $usr@driver${i}-1 "$io"
  if [ $i==1 ]; then
    $SSH $usr@driver1-1 "$pw"
  fi
done
