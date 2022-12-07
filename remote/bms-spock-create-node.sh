
source env.sh

echo " "
echo "## bms-spock-create-node.sh on `hostname`  for node $1 ####"

psql="$HOME/oscg/$pgXX/bin/psql -U postgres "

function add_table {
  table="public.bmsql_$1"
  sql="select spock.replication_set_add_table('bmsql_set', '$table')"
  if [ "$1" = "customer" ]; then
     sql="select spock.replication_set_add_table('bmsql_set', '$table', columns := '{c_w_id, c_d_id, c_id, c_discount, c_ytd_payment, c_payment_cnt, c_delivery_cnt, c_since, c_credit, c_credit_lim, c_balance, c_city , c_state, c_zip, c_location, c_country}')"
  fi
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
    dsn := 'host=$node port=5432 user=replication dbname=demo')"

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

