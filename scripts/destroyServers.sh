#!/bin/bash
cd "$(dirname "$0")"
cd ..

cluster=$1
force=false
if [[ ! -z "$2" && "$2" == '--force' ]]; then
  force=true
fi

if [ ! -d "nodes/$cluster" ]; then
  echo "ERROR: could not find cluster - $PWD/nodes/$cluster"
  exit 1
elif [ ! -f "nodes/$cluster/env.sh" ]; then
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
  ## To Do: finish force_destroy.py
  ##if [ $force ]; then
  ##  python3 scripts/force_destory.py $cluster $N{i}
  ##fi
done

echo "# destroy nodes in progress..."
sleep 1
log=log/${cluster}-n${lastNode}.log
if [ -f "$log" ]; then
  echo "# tail last node destroy log"
  tail -f log/${cluster}-n${lastNode}.log
fi

echo ""
echo "whacking cluster meta data  @ $clDir"
rm -rf $clDir
