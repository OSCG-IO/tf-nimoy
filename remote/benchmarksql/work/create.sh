
~/bigsql/pg11/bin/psql -U postgres -h node1 -a -f create-benchmark.sql
~/bigsql/pg11/bin/psql -U postgres -h node2 -a -f create-benchmark.sql

cd ../run
./runDatabaseBuild.sh node1-pg.properties

