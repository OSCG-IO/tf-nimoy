
## arm64 w/ 1 vcpu, 2 GB Memory
##TYPE=c6g.medium

## arm64 w/ 2 vcpu, 4 GB Memory
TYPE=c6g.large 

## now:    oregon, montreal, dublin, sydney
## soon:   dallas, osaka
N1=montreal
N2=dublin
N3=sydney

creds="./aws-creds.sh"
if [ -f "$creds" ]; then
  source "$creds"
else
  echo "FATAL ERROR: file $creds is missing"
  exit 1
fi

DIR=$PWD
NN=$DIR/nodes
NN1=$NN/n1
NN2=$NN/n2
NN3=$NN/n3
