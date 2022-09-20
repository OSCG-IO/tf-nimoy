set -x 

rm stelthy.db
cat locations.sql | sqlite3 stelthy.db
cat images.sql    | sqlite3 stelthy.db

sqlite3 stelthy.db < sel_v_rgn.sql
