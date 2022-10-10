source env.sh

HOST="$1"
SSH="ssh -o StrictHostKeyChecking=accept-new"
SCP="scp -o StrictHostKeyChecking=accept-new"

echo ""
echo "####### setupSpock.sh ##################"

set -x

$SSH $HOST "$io install $pgXX"
$SCP ~/.pgpass $HOST:$PG/.pgpass
$SSH $HOST "$io start $pgXX -y -d demo : tune $pgXX : install spock -d demo : install prompgexp --start"

$SCP pg_hba.conf $HOST:$PG/.
