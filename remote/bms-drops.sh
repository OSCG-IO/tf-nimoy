source env.sh

./run_sql.sh "select $spock.drop_replication_set('bmsql_set', false)"

$psql -h $NODE1 demo -c \
    "select $spock.drop_subscription('subscription2', false)"
$psql -h $NODE2 demo -c \
    "select $spock.drop_subscription('subscription1', false)"

./run_sql.sh "drop table bmsql_config"

./run_sql.sh "drop table bmsql_new_order"

./run_sql.sh "drop table bmsql_order_line"

./run_sql.sh "drop table bmsql_oorder"

./run_sql.sh "drop table bmsql_history"

./run_sql.sh "drop table bmsql_customer"

./run_sql.sh "drop table bmsql_stock"

./run_sql.sh "drop table bmsql_item"

./run_sql.sh "drop table bmsql_district"

./run_sql.sh "drop table bmsql_warehouse"

./run_sql.sh "drop sequence bmsql_hist_id_seq"
