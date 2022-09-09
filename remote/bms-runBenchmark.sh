
this_host=`hostname`

if [ "$this_host" == "driver1-1" ]; then
  node_prop="node1-pg.properties"
elif [ "$this_host" == "driver2-1" ]; then
  node_prop="node2-pg.properties"
elif [ "$this_host" == "driver3-1" ]; then
  node_prop="node3-pg.properties"
else
  echo "ERROR! I don't know how to run from $this_host"
  exit 1
fi

echo "##### runBenchmark from $this_host using $node_prop #######"

cd benchmarksql/run
./runBenchmark.sh $node_prop
cd ../..

##./bms-lagTimer.sh
