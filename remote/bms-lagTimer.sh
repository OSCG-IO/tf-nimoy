
source env.sh 

psql=$HOME/oscg/pgXX/bin/psql

SELECT="select pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) from pg_stat_replication"
sleep 2
timer=1
echo ""

while true; do
  total_lag=`echo "$SELECT" | $psql -qAt -U postgres -h $ip_n1 -d demo`
  if [ "$total_lag" == "0 bytes" ]; then
    if [ "$timer" == "1" ] || [ "$timer" == "2" ]; then
      echo "Total Lag less than 2(s)"
      exit 0
    else
      echo "Total Lag equals approx $timer(s)"
      exit 0
    fi
  else
    echo "Total Lag equals $total_lag after $timer(s)"
    sleep 1
    timer=$(( $timer + 1 ))
  fi
done


