source env.sh

if [ $# == 1 ]; then
  cmd="$io $1"
  echo ""
  echo "# $cmd"
  echo ""
  $PSSH "$cmd"
else
  echo "ERROR!  parm count must be 1"
fi

echo ""
exit 0

