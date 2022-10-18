source env.sh

HOST="$1"
SSH="ssh -o StrictHostKeyChecking=accept-new"
SCP="scp -o StrictHostKeyChecking=accept-new"

echo ""
echo "####### setupSpock.sh ##################"

set -x

$SSH $HOST "$io install $pgXX"
$SCP .pword $HOST:$PG/.pgpass
$SSH $HOST "$io start $pgXX -y -d demo : tune $pgXX : install spock -d demo : install prompgexp --start"

set +x

PASS=`cat .pword`
echo "localhost:5432:*:postgres:$PASS" >> ~/.pgpass
echo "$HOST:5432:*:postgres:$PASS" >> ~/.pgpass
$SCP pg_hba.conf $HOST:$PG/.
