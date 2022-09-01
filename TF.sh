
if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

source env.sh

if [ "$#" -ne 2 ]; then
  echo "FATAL ERROR: requires 2 parameters"
  exit 1
fi

runAction() {
  nd="$1"
  ndActn="$2"
  ndDir="$3"
  valid_action=True 
  echo " "
  echo "## $nd ##"
  cd $ndDir
#  if [ "$ndActn" == "destroy" ]; then
#    parms="-input=false -auto-approve"
#    echo "running $ndActn $parms ASNYC"
#    terraform $ndActn $parms >> $PWD/out.log  2>&1 &
#  else
    terraform $ndActn
#  fi
}

############## MAINLINE ##################
#set -x

nn="$1"
action="$2"
valid_action=False

if [ "$nn" == "n1" ] || [ "$nn" == "all" ]; then
  runAction n1 "$action" $NN1
fi

if [ "$nn" == "n2" ] || [ "$nn" == "all" ]; then
  runAction n2 "$action" $NN2
fi

if [ "$nn" == "n3" ] || [ "$nn" == "all" ]; then
  runAction n3 "$action" $NN3
fi

if [ "$valid_action" == "False" ]; then
  echo "FATAL ERROR: first parm must be n1, n2, n3 or 'all'"
  exit 1
fi

exit 0

