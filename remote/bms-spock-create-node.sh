
source env.sh

echo " "
echo "## bms-spock-create-node.sh on `hostname`  for node $1 ####"

psql="$HOME/oscg/pg14/bin/psql -U postgres "

function add_table {
  table="public.bmsql_$1"
  sql="select spock.replication_set_add_table('bmsql_set', '$table')"
  echo ""
  echo "$sql"
  $psql -h $node -q demo -c "$sql"
}

#### mainline ######################

if [ $# -ne 1 ]; then
  echo "ERROR! Must supply node name as only parm"
  exit 1
fi

node=$1
echo ""

$psql -h $node demo -c "SELECT
  spock.create_node(
    node_name := '$node',
    dsn := 'host=$node port=5432 user=replication password=password dbname=demo')"

$psql -h $node demo -c "SELECT
  spock.create_replication_set('bmsql_set', true, true, true, true);"

add_table warehouse
add_table item
add_table stock
add_table customer
add_table oorder
add_table order_line
add_table new_order
add_table district

