
cd benchmarksql/run

./runDatabaseBuild.sh node1-pg.properties

psql -h node1-1 -U postgres demo -f ~/demo.sql
psql -h node1-1 -U postgres demo -f $RMT/demo-pii.sql
