# The process to run from driver1-1 instance

1.) ssh to nodes (node1-1, node2-1 & node3-1) to make sure passwordless ssh works without warning

2.) Change the pg version in env.sh if it was changed from what is in the repo.

3.) Run refresh-io.sh to start over on each database node.
     - Make sure each node is clean and ready for IO remove-io.sh
     - install-io.sh to install io on each node
     - run setup.sh to do following on each node using pssh;
         + use io to install/tune pg & install spock into the demo db
         + replace pghba.conf with a permissive version for logical rep
         + create the replication role

4.) run ./bms-build-1.sh && ./bms-dump-1.sh

5.) run bms-setup.sh to:
        restore the dump from above step to each multi-master node
        create each node in spock
        setup spock multi-master on each node

6.) run "bms-runBenchmark.sh" on each driver

7.) rinse & repeat for different size nodes by varying the 
    nodeN-pg.properties file on the driver(N) machines.
    you must make sure that the data that is loaded corrsponds
    to the number of warehouses in the properties file.
