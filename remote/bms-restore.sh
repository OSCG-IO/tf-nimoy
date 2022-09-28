
source env.sh

PGBIN="$HOME/oscg/$pgXX/bin"

echo " "
echo "## bms_restore.sh on `hostname` ############"

if [ $# -ne 1 ]; then
  echo "ERROR! Must supply node name"
  exit 1
fi

node=$1

dump_file=$dump_dir/dump.sql
RESTORE="psql -U postgres -h $node demo -f $dump_file"

echo ""
ls -sh $dump_file
echo ""
RESTORE="$PGBIN/$RESTORE"
echo "RESTORE=$RESTORE"
$RESTORE
rc=$?

REPL="$PGBIN/psql -U postgres -h $node demo -f create-replication-role.sql"
echo "REPL=$REPL"
$REPL

echo ""
$PGBIN/psql -U postgres -h $node -c "select count(*) from bmsql_oorder" demo
echo ""
exit $rc

