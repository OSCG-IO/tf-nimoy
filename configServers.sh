setupEtcHosts () {
  $SCP hosts          $usr@$1:.
  $SCP catHosts.sh    $usr@$1:.
  $SSH $usr@$1 'sudo ./catHosts.sh'
}

if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi
source env.sh

set -x

d1=driver1-1

key="keys/dl-m1book-key.pem"
usr=centos
SSH="ssh -i $key -o StrictHostKeyChecking=no"
SCP="scp -i $key -o StrictHostKeyChecking=no"
PASS=$(openssl rand -hex 8;)

$SCP ansible_hosts  $usr@$d1:.
$SCP add-key.yml    $usr@$d1:.

setupEtcHosts driver1-1
setupEtcHosts node1-1
setupEtcHosts driver2-1
setupEtcHosts node2-1
setupEtcHosts driver3-1
setupEtcHosts node3-1

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


$SSH $usr@driver1-1 "$bs"
$SSH $usr@driver1-1 "$io"
$SSH $usr@driver1-1 "$pw"

$SSH $usr@driver2-1 "$bs"
$SSH $usr@driver2-1 "$io"

$SSH $usr@driver3-1 "$bs"
$SSH $usr@driver3-1 "$io"
