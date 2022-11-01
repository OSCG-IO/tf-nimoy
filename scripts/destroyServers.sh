#!/bin/bash
cd "$(dirname "$0")"
cd ..

cluster=$1

if [ ! -d "nodes/$CLUSTER_NM" ]; then
  echo "ERROR: could not find cluster terrafrom"
  exit 1
elif [ ! -f "nodes/$CLUSTER_NM/env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

clDir=$PWD/nodes/$cluster
source $clDir/env.sh
NODE_KOUNT=`find $clDir/. -mindepth 1 -maxdepth 1 -type d | wc -l`
mkdir -p log

read -n1 -s -r -p $'press Y to destroy cluster' key
if [ ! "$key" == "Y" ]; then
  echo "see ya. :-)"
  exit 1
fi

trap ' ' INT

echo ""
echo "# destroy any nodes that may be present in cluster $cluster"
destroy="destroy -auto-approve"

for (( i=1 ; i<=$NODE_KOUNT ; i++ ));
do
  echo "## destroy n${i}"
  ./TF.sh $cluster n${i} "$destroy" >> log/${cluster}-n${i}.log 2>&1 &
  lastNode=$i
done

echo "# destroy nodes in progress..."
sleep 2
echo "# tail last node destory log"
tail -f log/${cluster}-n${lastNode}.log

echo ""
echo "whacking $cluster terraform files"
rm -rf $clDir
