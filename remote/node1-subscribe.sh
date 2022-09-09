
source env.sh

echo " "
echo "## node1-subscribe.sh on `hostname` ############"

PSQL="$HOME/oscg/pg14/bin/psql -U postgres  -h node1-1 demo"

$PSQL -c "SELECT spock.create_subscription( \
    subscription_name := 'subscription2a', \
    provider_dsn := 'host=node2-1 port=5432 user=replication password=password dbname=demo', \
    forward_origins := '{}', \
    synchronize_data := false \
);"
$PSQL -c "SELECT spock.alter_subscription_add_replication_set( \
    subscription_name := 'subscription2a', \
    replication_set := 'bmsql_set' \
);"
#$PSQL -c "SELECT spock.wait_for_subscription_sync_complete('subscription2');"


$PSQL -c "SELECT spock.create_subscription( \
    subscription_name := 'subscription3a', \
    provider_dsn := 'host=node3-1 port=5432 user=replication password=password dbname=demo', \
    forward_origins := '{}', \
    synchronize_data := false \
);"
$PSQL -c "SELECT spock.alter_subscription_add_replication_set( \
    subscription_name := 'subscription3a', \
    replication_set := 'bmsql_set' \
);"
#$PSQL -c "SELECT spock.wait_for_subscription_sync_complete('subscription3');"


