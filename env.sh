
export CLUSTER_NM=demo
export CLOUD=aws
export TYPE=c6g.medium
export OS=ubu22
export PLATFORM=arm
export PGV=15
export NODE_KOUNT=3

N1=pdt
N1Z=a
N2=pdt
N2Z=b
N3=pdt
N3Z=c

#N1=mtl
#N1Z=a
#N2=dub
#N2Z=a
#N3=syd
#N3Z=a

creds="keys/aws-creds.sh"
if [ -f "$creds" ]; then
  source "$creds"
else
  echo "FATAL ERROR: file $creds is missing"
  exit 1
fi

DIR=$PWD
NN=$DIR/nodes/$CLUSTER_NM
NN1=$NN/n1
NN2=$NN/n2
NN3=$NN/n3
