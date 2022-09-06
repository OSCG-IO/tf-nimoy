
set -x

./TF.sh all output > my.out

## create the 'hosts' & 'ansible_hosts' files from the 'my.out' file
python3 make_hosts_file.py

## create a new local hosts file with all the new machines
cp hosts.base.osx hosts.new
cat hosts >> hosts.new
sudo cp hosts.new  /etc/hosts

## driver-1 is the first ip address in the local 'hosts' file
d1=`head -1 hosts | awk '{print $1;}'`
key="~/keys/dl-m1book-key.pem"
usr=ubuntu

scp -i $key  ansible_hosts  $usr@$d1:.
scp -i $key  add-key.yml    $usr@$d1:.
scp -i $key  hosts          $usr@$d1:.
scp -i $key  catHosts.sh    $usr@$d1:.

ssh -i $key $usr@$d1 'mkdir keys'
scp -i $key ~/keys/dl-m1book-key.pem  $usr@$d1:keys/.
ssh -i $key $usr@$d1 'echo -e "\n\n\n" | ssh-keygen -t rsa'

ssh -i $key $usr@$d1 'ansible-playbook add-key.yml -i ansible_hosts --user ubuntu --key-file ~/keys/dl-m1book-key.pem  -e "key=/home/ubuntu/.ssh/id_rsa.pub"'
ssh -i $key $usr@$d1 'sudo ./catHosts.sh'

bs='cd test/nimoy/remote/benchmarksql; /home/ubuntu/apache-ant-1.9.16/bin/ant'
io='python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"; cd oscg; ./io install pg14; echo "*:5432:*:postgres:password" >> /home/ubuntu/.pgpass; chmod 600 /home/ubuntu/.pgpass'

ssh $usr@driver1-1 "$bs"
ssh $usr@driver1-1 "$io"

ssh $usr@driver2-1 "$bs"
ssh $usr@driver2-1 "$io"

ssh $usr@driver3-1 "$bs"
ssh $usr@driver3-1 "$io"
