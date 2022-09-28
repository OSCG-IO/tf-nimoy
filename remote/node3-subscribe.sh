
source env.sh

echo " "
echo "## node3-subscribe.sh on `hostname` ############"


PSQL="$HOME/oscg/$pgXX/bin/psql -U postgres  -h node3-1 demo"

$PSQL -c "SELECT spock.create_subscription( \
    subscription_name := 'subscription1c', \
    provider_dsn := 'host=node1-1  port=5432 user=replication password=password dbname=demo', \
    forward_origins := '{}', \
    synchronize_data := false \
);"
$PSQL -c "SELECT spock.alter_subscription_add_replication_set( \
    subscription_name := 'subscription1c', \
    replication_set := 'bmsql_set' \
);"
#$PSQL -c "SELECT spock.wait_for_subscription_sync_complete('subscription1c');"


$PSQL -c "SELECT spock.create_subscription( \
    subscription_name := 'subscription2c', \
    provider_dsn := 'host=node2-1 port=5432 user=replication password=password dbname=demo', \
    forward_origins := '{}', \
    synchronize_data := false \
);"
$PSQL -c "SELECT spock.alter_subscription_add_replication_set( \
    subscription_name := 'subscription2c', \
    replication_set := 'bmsql_set' \
);"
#$PSQL -c "SELECT spock.wait_for_subscription_sync_complete('subscription2c');"

