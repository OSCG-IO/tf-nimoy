PSSH="pssh -i -h hosts"
pgXX=pg11
psql="/db/bigsql/$pgXX/bin/psql -U postgres -h localhost -p 5432 -c \"$1\" demo"

if [ $# == 1 ]; then
  echo ""
  echo "# $psql"
  echo ""
  $PSSH "$psql"
  sleep 1
else
  echo "ERROR!  parm count must be 1"
fi

echo ""
exit 0
