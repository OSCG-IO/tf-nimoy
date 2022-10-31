
if [ "$#" -ne 3 ]; then
  echo "FATAL ERROR: requires 3 parms: CLUSTER NODE_NUM ACTION"
  exit 1
fi

runAction() {
  cl="$1"
  nd="$2"
  ndActn="$3"
  ndDir="$4"
  echo " "
  echo "## terraform $ndDir $ndActn ##"
  if [ ! -d $ndDir ]; then
    echo "ERROR: Node directory not found \'$ndDir\'"
    exit 1
  fi
  cd $ndDir
  terraform $ndActn
}


############## MAINLINE ##################
##set -x

cluster="$1"
node="$2"
action="$3"

clDir=$PWD/nodes/$cluster
if [ ! -d $clDir ]; then
  echo "ERROR: Cluster \'$clDir\' not found"
fi

if [ "$node" == "all" ]; then
  NODE_KOUNT=`find $clDir/. -mindepth 1 -maxdepth 1 -type d | wc -l`
  for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
  do
     runAction "$cluster" "n$i" "$action"  "$clDir/n$i"
  done
else
  runAction "$cluster" "$node" "$action"  "$clDir/$node"
fi

exit 0

