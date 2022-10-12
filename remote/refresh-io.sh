if  [ ! -f .pword ]; then
   PASS=$(openssl rand -hex 8;)
   echo $PASS >> .pword
fi

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

SCP="scp -o StrictHostKeyChecking=accept-new"
$SCP node1-1:/home/ubuntu/.pgpass /home/ubuntu/.pgpass
rm .pword
