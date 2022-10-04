
source env.sh

./bms-restore.sh node1-1
./bms-spock-create-node.sh node1-1

./bms-restore.sh node2-1
./bms-spock-create-node.sh node2-1

./bms-restore.sh node3-1
./bms-spock-create-node.sh node3-1 

scp ~/.pgpass node1-1:.
scp ~/.pgpass node2-1:.
scp ~/.pgpass node3-1:.

./node1-subscribe.sh
./node2-subscribe.sh
./node3-subscribe.sh
