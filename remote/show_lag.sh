
./run_sql.sh "select \
  pid, \
  application_name, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) sending_lag, \
  pg_size_pretty(pg_wal_lsn_diff(sent_lsn, flush_lsn)) receiving_lag, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) total_lag \
from pg_stat_replication"

