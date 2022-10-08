
## arm64 w/ 1 vcpu, 2 GB Memory
TYPE=c6g.medium
N1=pdt	
N2=pdt
N3=pdt

## postgreSQL Version, 14 or 15
PGV=15

## arm64 w/ 2 vcpu, 4 GB Memory
#TYPE=c6g.large 

#N1=mtl
#N2=dub
#N3=syd

creds="keys/aws-creds.sh"
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
