
set -x

./TF.sh all output > my.out

## create the 'hosts' & 'ansible_hosts' files from the 'my.out' file
python3 make_hosts_file.py

## create a new local hosts file with all the new machines
cp hosts.base.osx hosts.new
cat hosts >> hosts.new
sudo cp hosts.new  /etc/hosts
d1=driver1-1

key="~/keys/dl-m1book-key.pem"
usr=ubuntu
SSH="ssh -o StrictHostKeyChecking=no"
SCP="scp -o StrictHostKeyChecking=no"

$SCP -i $key  ansible_hosts  $usr@$d1:.
$SCP -i $key  add-key.yml    $usr@$d1:.
$SCP -i $key  hosts          $usr@$d1:.
$SCP -i $key  catHosts.sh    $usr@$d1:.

$SSH -i $key $usr@$d1 'mkdir keys'
$SCP -i $key ~/keys/dl-m1book-key.pem  $usr@$d1:keys/.
$SSH -i $key $usr@$d1 'echo -e "\n\n\n" | ssh-keygen -t rsa'

$SSH -i $key $usr@$d1 'ansible-playbook add-key.yml -i ansible_hosts --user ubuntu --key-file ~/keys/dl-m1book-key.pem  -e "key=/home/ubuntu/.ssh/id_rsa.pub"'
$SSH -i $key $usr@$d1 'sudo ./catHosts.sh'

bs='cd test/nimoy/remote/benchmarksql; /home/ubuntu/apache-ant-1.9.16/bin/ant'
io='python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"; cd oscg; ./io install pg14; echo "*:5432:*:postgres:password" >> /home/ubuntu/.pgpass; chmod 600 /home/ubuntu/.pgpass'

$SSH $usr@driver1-1 "$bs"
$SSH $usr@driver1-1 "$io"

$SSH $usr@driver2-1 "$bs"
$SSH $usr@driver2-1 "$io"

$SSH $usr@driver3-1 "$bs"
$SSH $usr@driver3-1 "$io"
