dump_dir=/db/dump_dir
this_dir=`pwd`
RUN=$this_dir/benchmarksql/run
PSSH="pssh -i -h hosts"
PSCP="pscp -h hosts"
pgXX=pg14
IO_DIR=/db/oscg
io=$IO_DIR/io
PG=$IO_DIR/$pgXX
psql="$PG/bin/psql -U postgres"

key1=aws-oregon-key.pem
ip_d1=35.91.141.86
ip_n1=34.221.185.99
ssh_d1=$ip_d1
ssh_n1=$ip_n1

key2=aws-oregon-key.pem
ip_d2=35.92.23.233
ip_n2=52.26.16.7
ssh_d2=$ip_d2
ssh_n2=$ip_n2

key3=aws-oregon-key.pem
ip_d3=35.88.246.204
ip_n3=54.189.222.210
ssh_d3=$ip_d3
ssh_n3=$ip_n3

export DRIVER1=$ip_d1
export NODE1=$ip_n1
export NODE1_IP=$ip_n1

export DRIVER2=$ip_d2
export NODE2=$ip_n2
export NODE2_IP=$ip_n2

export DRIVER3=$ip_d3
export NODE3=$ip_n3
export NODE3_IP=$ip_n3

