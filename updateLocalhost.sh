./TF.sh ${CLUSTER_NM} all output > nodes/${CLUSTER_NM}/${CLUSTER_NM}.out

## create the 'hosts' & 'ansible_hosts' files from the 'my.out' file
python3 scripts/make_hosts_file.py
python3 scripts/make_sg_rules.py

## create a new local hosts file with all the new machines
os=`uname`
if [ "$os" == "Darwin" ]; then
  cp conf/hosts.base.osx   hosts.new
else
  cp conf/hosts.base.linux hosts.new
fi
cat hosts >> hosts.new
sudo cp hosts.new  /etc/hosts
sudo touch /etc/hosts
rm hosts.new

##rm nodes/${CLUSTER_NM}/${CLUSTER_NM}.out
rm -f ~/.ssh/known_hosts
