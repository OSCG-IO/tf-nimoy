psql -U postgres -h node1-1 -p 5432 -c "select \
  pid, \
  application_name, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) sending_lag, \
  pg_size_pretty(pg_wal_lsn_diff(sent_lsn, flush_lsn)) receiving_lag, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) total_lag \
from pg_stat_replication" -d demo

psql -U postgres -h node2-1 -p 5432 -c "select \
  pid, \
  application_name, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) sending_lag, \
  pg_size_pretty(pg_wal_lsn_diff(sent_lsn, flush_lsn)) receiving_lag, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) total_lag \
from pg_stat_replication" -d demo


psql -U postgres -h node3-1 -p 5432 -c "select \
  pid, \
  application_name, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) sending_lag, \
  pg_size_pretty(pg_wal_lsn_diff(sent_lsn, flush_lsn)) receiving_lag, \
  pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) total_lag \
from pg_stat_replication" -d demo


