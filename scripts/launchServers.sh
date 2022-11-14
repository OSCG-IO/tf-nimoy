#!/bin/bash
cd "$(dirname "$0")"
cd ..

setNodesVars () {
  echo "## setNodesVar() for NN & MACHINE=$MACHINE"

  for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
  do
    NNn=NN$i
    tf=${!NNn}/variable.tf
    echo "variable \"nn\" { default = \"${i}-1\" }" > $tf
    echo "variable \"cluster\" { default = \"$CLUSTER\" }" >> $tf
    echo "variable \"machine\" { default = \"$MACHINE\" }" >> $tf
  done
}


genTFvars() {
  echo "## genTFvars($1, $2, $3, $4)"
  cld="$1" 
  regn="$2"
  zone="$3"
  dir="$4"

  lctn=$cld-$regn.tf
  out=$dir/variables.$lctn

  scripts/gen_tf_vars.py $cld $regn $zone > $out
  rc=$?
  cat $out
  if [ ! "$rc" == "0" ]; then
    exit 1
  fi
}


cpNodes () {
  for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
  do
    NNn=NN$i
    cp $1 ${!NNn}
  done
}


setupNodesDir () {

  for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
  do
    NNn=NN$i
    mkdir -p ${!NNn}
  done

  sleep 1

  echo "## copying common terraform files"
  cpNodes main.tf
  cpNodes outputs.tf 
  sleep 1

  echo "## copying IO variables file"
  cpNodes variables.IO.tf
  sleep 1
}


echo "######### Launch PGE Cluster ##########"
echo "#"
echo "#  Cluster Name: $CLUSTER"
echo "#         Count: $NODE_KOUNT"
echo "#         Cloud: $CLOUD"
echo "#  Machine Type: $MACHINE"
echo "#       Version: $PGV"
echo "#"

for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
do
   Nn=N$i
   Nz=N${i}Z 
   NNn=NN$i
   echo "#            n$i : ${!Nn} - ${!Nz} - ${!NNn}"
done

setupNodesDir

map="$NN/nodes.html"
echo ""
echo "generate the geo map ($map)"
python3 scripts/generate.py map --provider aws --location "$N1, $N2, $N3" > $map
rc=$?
if [ ! "$rc" == "0" ]; then
  exit 1
fi

echo ""
echo "# copy location files"
for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
do
   Nn=N$i
   Nz=N${i}Z 
   NNn=NN$i
   genTFvars $CLOUD ${!Nn} ${!Nz} ${!NNn}
done

echo ""
echo "# create node specfic variables"
setNodesVars

./TF.sh "$CLUSTER" "all" "init"
./TF.sh "$CLUSTER" "all" "apply -auto-approve"

echo " "
echo "configuring localhost"
./updateLocalhost.sh $CLUSTER

echo ""
echo "  run './scripts/configServers.sh <cluster_name>' next"

echo "sleeping for a couple mins so servers can init & reboot"
yes | pv -SL1 -F 'Resuming in %e' -s 150 > /dev/null


os=`uname -s`
if [ "$os" == "Darwin" ]; then
  sudo reboot
fi

