
set -x

./TF.sh all output > my.out

python3 make_hosts_file.py

d1=`head -1 hosts | awk '{print $1;}'`
key="~/keys/aws-oregon-key.pem"
usr=ubuntu

scp -i $key  ansible_hosts  $usr@$d1:.
scp -i $key  add-key.yml    $usr@$d1:.
scp -i $key  hosts          $usr@$d1:.

ssh -i $key $usr@$d1 'ansible-playbook add-key.yml -i ansible_hosts --user ubuntu --key-file ~/keys/aws-oregon-key.pem -e "key=~/.ssh/id_rsa.pub"'
ssh -i $key $usr@$d1 'sudo cat hosts >> /etc/hosts'

