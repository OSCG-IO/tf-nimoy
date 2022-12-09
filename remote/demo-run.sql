pip3 install fire --user
sudo yum install gcc
sudo yum install python3-devel
sudo yum install libpq-devel
pip3 install psycopg2 --user

./bms-build-1.sh && ./bms-dump-1.sh
sleep 2

source env.sh

./bms-restore.sh node1-1
psql -h node1-1 -U postgres demo -f demo-regionalize.sql --variable=REGION=2
psql -h node1-1 -U postgres demo -f demo-regionalize.sql --variable=REGION=3

./bms-restore.sh node2-1
psql -h node2-1 -U postgres demo -f demo-regionalize.sql --variable=REGION=1
psql -h node2-1 -U postgres demo -f demo-regionalize.sql --variable=REGION=3

./bms-restore.sh node3-1
psql -h node3-1 -U postgres demo -f demo-regionalize.sql --variable=REGION=1
psql -h node3-1 -U postgres demo -f demo-regionalize.sql --variable=REGION=2


