set -x 

rm stelthy.db
cat providers.sql | sqlite3 stelthy.db
cat locations.sql | sqlite3 stelthy.db
cat images.sql    | sqlite3 stelthy.db

cat sel_v_rgn.sql | sqlite3 stelthy.db
