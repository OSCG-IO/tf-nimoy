
# delete and re-installthe database
./remove-io.sh node1-1
./remove-io.sh node2-1
./remove-io.sh node3-1

./install-io.sh node1-1
./install-io.sh node2-1
./install-io.sh node3-1

./setupSpock.sh node1-1
./setupSpock.sh node2-1
./setupSpock.sh node3-1

sed -i "1s/^/*:5432:postgres:/" ~/.pgpass
