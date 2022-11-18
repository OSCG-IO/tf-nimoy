
source env.sh

./bms-restore.sh node1-1
psql -h node1-1 -U postgres demo -f demo-regonalize.sql --variable=REGION=1 
./bms-spock-create-node.sh node1-1

./bms-restore.sh node2-1
psql -h node2-1 -U postgres demo -f demo-regonalize.sql --variable=REGION=2
./bms-spock-create-node.sh node2-1

./bms-restore.sh node3-1
psql -h node3-1 -U postgres demo -f demo-regonalize.sql --variable=REGION=3
./bms-spock-create-node.sh node3-1 

SCP="scp -o StrictHostKeyChecking=accept-new"

$SCP ~/.pgpass node1-1:.
$SCP ~/.pgpass node2-1:.
$SCP ~/.pgpass node3-1:.

$SCP ~/.pgpass driver2-1:.
$SCP ~/.pgpass driver3-1:.

./node1-subscribe.sh
./node2-subscribe.sh
./node3-subscribe.sh
