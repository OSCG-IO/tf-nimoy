
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

copyLocation() {
  echo "## copyLocation($1, $2, $3)"
  cld="$1" 
  n="$2"
  nn="$3"
  
  lctn=$cld-$n.tf
  cp locations/$lctn  $nn/variables.$lctn
}

cpNodes () {
  cp $1 $NN1
  cp $1 $NN2
  cp $1 $NN3
}

destroyNodes () {
  echo ""
  echo "# destroy any nodes that may be present"
  destroy="destroy -auto-approve"
  if [ -d $NN1 ]; then
     echo "## destroy n1 $N1"  
    ./TF.sh n1 "$destroy" 2> /dev/null
  fi
  if [ -d $NN2 ]; then
     echo "## destroy n2 $N2" 
    ./TF.sh n2 "$destroy" 2> /dev/null
  fi
  if [ -d $NN3 ]; then
     echo "## destroy n3 $N3" 
    ./TF.sh n3 "$destroy" 2> /dev/null
  fi
  sleep 1

}

setupNodesDir () {
  ##destroyNodes

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


echo "###### Setup Multi-Region Demo Cluster ######"
echo "# n1: $N1"
echo "# n2: $N2"
echo "# n3: $N3"

setupNodesDir

echo ""
echo "# copy location files"
copyLocation aws $N1 $NN1
copyLocation aws $N2 $NN2
copyLocation aws $N3 $NN3

echo ""
echo "# create node specfic variables"
setNodesVars

./TF.sh all init
./TF.sh all "apply -auto-approve"

echo " "
echo "configuring localhost"
./updateLocalhost.sh

echo ""
echo "  run './configServers.sh' next"

echo "sleeping for a couple mins so servers can init & reboot"
yes | pv -SL1 -F 'Resuming in %e' -s 210 > /dev/null


os=`uname -s`
if [ "$os" == "Darwin" ]; then
  sudo reboot
fi

