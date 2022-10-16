
CLUSTER_NM=demo
CLOUD=aws
TYPE=c6g.large
PGV=15
NODE_KOUNT=3

#N1=pdt
#N1Z=a
#N2=pdt
#N2Z=b
#N3=pdt
#N3Z=c

N1=mtl
N1Z=a
N2=dub
N2Z=a
N3=syd
N3Z=a

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
