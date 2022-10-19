if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

source env.sh
mkdir -p log

if [ ! -d "$NN" ]; then
  echo "ERROR: cluster not found: $NN"
  exit 1
fi

echo "cluster = $NN"
read -n1 -s -r -p $'press Y to destroy cluster' key
if [ ! "$key" == "Y" ]; then
  echo "see ya. :-)"
  exit 1
fi

trap ' ' INT

echo ""
echo "# destroy any nodes that may be present"
destroy="destroy -auto-approve"
if [ -d $NN1 ]; then
  echo "## destroy n1 $N1"
  ./TF.sh n1 "$destroy" >> log/tf-destroy-n1.log 2>&1 &
fi
if [ -d $NN2 ]; then
  echo "## destroy n2 $N2"
  ./TF.sh n2 "$destroy" >> log/tf-destroy-n2.log 2>&1 &
fi
if [ -d $NN3 ]; then
  echo "## destroy n3 $N3"
  n3log=log/tf-destroy-n3.log
  ./TF.sh n3 "$destroy" >> $n3log 2>&1 &
fi

echo "# destroy nodes in progress..."
sleep 2
echo "# tail n3 log file : $n3log"
tail -f $n3log

echo ""
echo "whacking $NN"
rm -rf $NN
