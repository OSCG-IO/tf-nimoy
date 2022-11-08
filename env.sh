
export CLUSTER=luss
export CLOUD=aws
export TYPE=c6g.medium
export OPSYS=cos8
export PLATFORM=arm
export PGV=15
export NODE_KOUNT=3

export N1=pdt
export N1Z=a
export N2=pdt
export N2Z=b
export N3=pdt
export N3Z=c

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
export NN=$DIR/nodes/$CLUSTER
export NN1=$NN/n1
export NN2=$NN/n2
export NN3=$NN/n3
