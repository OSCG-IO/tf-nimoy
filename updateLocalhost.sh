
set -x

./TF.sh all output > my.out

## create the 'hosts' & 'ansible_hosts' files from the 'my.out' file
python3 scripts/make_hosts_file.py

## create a new local hosts file with all the new machines
cp conf/hosts.base.osx hosts.new
cat hosts >> hosts.new
sudo cp hosts.new  /etc/hosts
sudo touch /etc/hosts

rm -f ~/.ssh/known_hosts
