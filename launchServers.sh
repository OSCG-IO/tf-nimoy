
if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

source env.sh


setNodesVars () {
  echo "## setNodesVar() for NN & TYPE=$TYPE"

  echo "variable \"nn\" { default = \"1-1\" }"     >  $NN1/variables.node.tf
  echo "variable \"type\" { default = \"$TYPE\" }" >> $NN1/variables.node.tf

  echo "variable \"nn\" { default = \"2-1\" }"     >  $NN2/variables.node.tf
  echo "variable \"type\" { default = \"$TYPE\" }" >> $NN2/variables.node.tf

  echo "variable \"nn\" { default = \"3-1\" }"     >  $NN3/variables.node.tf
  echo "variable \"type\" { default = \"$TYPE\" }" >> $NN3/variables.node.tf
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
  cp $1 $NN1
  cp $1 $NN2
  cp $1 $NN3
}


setupNodesDir () {

  echo ""
  echo "# create new nodes/nn directory tree" 
  rm -rf $NN
  mkdir -p $NN1
  mkdir -p $NN2
  mkdir -p $NN3
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
echo "   Cluster Name: $CLUSTER_NM"
echo "#         Count: $NODE_KOUNT"
echo "#            n1: $N1 $N1Z"
if [ ! "$N2" ==  "" ]; then
  echo "#            n2: $N2 $N2Z"
fi
if [ ! "$N3" == "" ]; then
  echo "#            n3: $N3 $N3Z"
fi

exit 1

setupNodesDir

map="$NN/demo-nodes.html"
echo ""
echo "generate the geo map ($map)"
scripts/gen_map.py $N1:$N1Z $N2:$N2Z $N3:$N3Z > $map
rc=$?
if [ ! "$rc" == "0" ]; then
  exit 1
fi


echo ""
echo "# copy location files"
genTFvars  aws $N1 $N1Z $NN1
genTFvars  aws $N2 $N2Z $NN2
genTFvars  aws $N3 $N3Z $NN3

echo ""
echo "# create node specfic variables"
setNodesVars

./TF.sh all init
./TF.sh all "apply -auto-approve"

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

