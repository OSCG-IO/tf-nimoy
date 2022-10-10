dump_dir=/db/dump_dir
this_dir=`pwd`
RUN=$this_dir/benchmarksql/run
PSSH="pssh -i -h hosts"
PSCP="pscp -h hosts"
pgXX=pg15
IO_DIR=/db/oscg
io=$IO_DIR/io
PG=$IO_DIR/$pgXX
psql="$PG/bin/psql -U postgres"

