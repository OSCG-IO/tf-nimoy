
set -x

./TF.sh all output > my.out

## create the 'hosts' & 'ansible_hosts' files from the 'my.out' file
python3 make_hosts_file.py

## driver-1 is the first ip address in the local 'hosts' file
d1=`head -1 hosts | awk '{print $1;}'`
key="~/keys/aws-oregon-key.pem"
usr=ubuntu

scp -i $key  ansible_hosts  $usr@$d1:.
scp -i $key  add-key.yml    $usr@$d1:.
scp -i $key  hosts          $usr@$d1:.
scp -i $key  catHosts.sh    $usr@$d1:.

ssh -i $key $usr@$d1 'mkdir keys'
scp -i $key ~/keys/aws-oregon-key.pem $usr@$d1:keys/.
ssh -i $key $usr@$d1 'echo -e "\n\n\n" | ssh-keygen -t rsa'

ssh -i $key $usr@$d1 'ansible-playbook add-key.yml -i ansible_hosts --user ubuntu --key-file ~/keys/aws-oregon-key.pem -e "key=/home/ubuntu/.ssh/id_rsa.pub"'
ssh -i $key $usr@$d1 'sudo ./catHosts.sh'

ssh -i $key $usr@$d1 'cd test/nimoy/remote/benchmarksql; /home/ubuntu/apache-ant-1.9.16/bin/ant'

