#!/bin/bash
cd "$(dirname "$0")"
cd ..

setNodesVars () {
  echo "## setNodesVar() for NN & TYPE=$TYPE"

  for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
  do
    NNn=NN$i
    tf=${!NNn}/variable.tf
    echo "variable \"nn\" { default = \"${i}-1\" }" > $tf
    echo "variable \"cluster_nm\" { default = \"$CLUSTER_NM\" }" >> $tf
    echo "variable \"type\" { default = \"$TYPE\" }" >> $tf
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
  if [ -d "$NN" ]; then
    echo "ERROR: Cluster definition directory exists: $NN"
    exit 1
  fi

  echo ""
  echo "# create new cluster directory tree" 
  mkdir -p $NN

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
echo "####### Default Settings ##############"
echo "#         Cloud: $CLOUD"
echo "#  Machine Type: $TYPE"
echo "#       Version: $PGV"
echo "#"
echo "####### Database Nodes ################"
echo "#  Cluster Name: $CLUSTER_NM"
echo "#         Count: $NODE_KOUNT"

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

./TF.sh "$CLUSTER_NM" "all" "init"
./TF.sh "$CLUSTER_NM" "all" "apply -auto-approve"

echo " "
echo "configuring localhost"
./updateLocalhost.sh

##echo " "
##echo "configure security groups"
##./sgUpdate.sh

echo ""
echo "  run './configServers.sh' next"

echo "sleeping for a couple mins so servers can init & reboot"
yes | pv -SL1 -F 'Resuming in %e' -s 150 > /dev/null


os=`uname -s`
if [ "$os" == "Darwin" ]; then
  sudo reboot
fi

