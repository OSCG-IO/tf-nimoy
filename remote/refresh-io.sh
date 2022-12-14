if  [ ! -f ".pword" ]; then
   PASS=$(openssl rand -hex 8;)
   echo $PASS >> .pword
   rm -f ~/.pgpass
   touch ~/.pgpass
   chmod 600 ~/.pgpass
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

rm .pword
