
if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

source env.sh

setNodesCommon () {
  echo "variable \"nn\" { default = \"1-1\" }"     >  $NN1/variables.tf
  echo "variable \"type\" { default = \"$TYPE\" }" >> $NN1/variables.tf

  echo "variable \"nn\" { default = \"2-1\" }"     >  $NN2/variables.tf
  echo "variable \"type\" { default = \"$TYPE\" }" >> $NN2/variables.tf

  echo "variable \"nn\" { default = \"3-1\" }"     >  $NN3/variables.tf
  echo "variable \"type\" { default = \"$TYPE\" }" >> $NN3/variables.tf
}

cpNodes () {
  cp $1 $NN1
  cp $1 $NN2
  cp $1 $NN3
}

initNodesDir () {
  echo "### Initialize 3 node cluster of Drivers & Nodes"
  destroy="destroy -auto-approve"
  if [ -d $NN1 ]; then
    ./TF.sh n1 "$destroy"
  fi
  if [ -d $NN2 ]; then
    ./TF.sh n2 "$destroy"
  fi
  if [ -d $NN3 ]; then
    ./TF.sh n3 "$destroy"
  fi

  rm -rf $NN
  mkdir -p $NN1
  mkdir -p $NN2
  mkdir -p $NN3

  cpNodes main.tf
  cpNodes outputs.tf 
}


echo "### MAINLINE for setupTF.sh"

initNodesDir

cp variables.$N1.tf   $NN1
cp variables.$N2.tf   $NN2
cp variables.$N3.tf   $NN3

setNodesCommon
