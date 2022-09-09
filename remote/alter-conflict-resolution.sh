source env.sh

$psql -h $NODE1 -a -c "alter system set $spock.conflict_resolution = 'keep_local'" demo

$psql -h $NODE2 -a -c "alter system set $spock.conflict_resolution = 'apply_remote'" demo

./run_pgc.sh "restart $pgXX"

./run_sql.sh "show $spock.conflict_resolution;"




