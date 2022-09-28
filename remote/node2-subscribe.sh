
source env.sh

echo " "
echo "## node2-subscribe.sh on `hostname` ############"


PSQL="$HOME/oscg/pg15/bin/psql -U postgres  -h node2-1 demo"

$PSQL -c "SELECT spock.create_subscription( \
    subscription_name := 'subscription1b', \
    provider_dsn := 'host=node1-1  port=5432 user=replication password=password dbname=demo', \
    forward_origins := '{}', \
    synchronize_data := false \
);"
$PSQL -c "SELECT spock.alter_subscription_add_replication_set( \
    subscription_name := 'subscription1b', \
    replication_set := 'bmsql_set' \
);"
#$PSQL -c "SELECT spock.wait_for_subscription_sync_complete('subscription1b');"


$PSQL -c "SELECT spock.create_subscription( \
    subscription_name := 'subscription3b', \
    provider_dsn := 'host=node3-1 port=5432 user=replication password=password dbname=demo', \
    forward_origins := '{}', \
    synchronize_data := false \
);"
$PSQL -c "SELECT spock.alter_subscription_add_replication_set( \
    subscription_name := 'subscription3b', \
    replication_set := 'bmsql_set' \
);"
#$PSQL -c "SELECT spock.wait_for_subscription_sync_complete('subscription3b');"

