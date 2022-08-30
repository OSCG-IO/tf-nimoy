
creds="./aws-credss.sh"
if [ -f "$creds" ]; then
  source "$creds"
else
  echo "FATAL ERROR: file \'$creds\' is missing"
  exit 1
fi


DIR=$PWD
NN=$DIR/nodes
NN1=$NN/n1
NN2=$NN/n2
NN3=$NN/n3

TYPE=c6g.large
N1=oregon
N2=montreal
N3=sydney
