
if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

source env.sh

if [ "$#" -ne 2 ]; then
  echo "FATAL ERROR: requires 2 parameters"
  exit 1
fi

## set -x

nn="$1"
action="$2"

valid_action=False

if [ "$nn" == "n1" ] || [ "$nn" == "all" ]; then
  valid_action=True 
  cd $NN1
  terraform $action
fi

if [ "$nn" == "n2" ] || [ "$nn" == "all" ]; then
  valid_action=True 
  cd $NN2
  terraform $action
fi

if [ "$nn" == "n3" ] || [ "$nn" == "all" ]; then
  valid_action=True 
  cd $NN3
  terraform $action
fi

if [ "$valid_action" == "False" ]; then
  echo "FATAL ERROR: first parm must be n1, n2, n3 or 'all'"
  exit 1
fi

exit 0

