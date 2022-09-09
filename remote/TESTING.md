The objective is to run a series of tests on a TPC-C like workload,
using BenchmarkSQL, against a standard configuration across 2 regions.
Four identically configured instances will be used for simplicity sake.
A Driver instance in each region and a Database node in each region.
 
-----------------------  EC2 Instances -----------------------
  REGIONS: us-west-1 & us-west-2
       OS: Amazon Linux 2
INSTANCES: r5.8xLarge (32 vCPUs, 256 GB RAM, 10 Gigabit Network)
  STORAGE: 8 GB gp2  ssd root partion
           500 GB EBS Volume with 25,000 provisioned IOPS
 
-------------------- BenchmarkSQL Configuration --------------
       NUM WAREHOUSES: 100
PARALELL LOAD WORKERS: 10
        NUM TERMINALS: 50
 
Performance insights will be turned on to measure & graph 
stats during each test (CPU, IOPS, Network IN/OUT)
and graph the performance characteristics of each test run. Between 
each test all data will be truncated and a clean load will be performed.
 
Test #1 (The system performs we'll under a moderate load):
  Run a 10,000 TPM load on each machine for 10 minutes.  Data lag will
  be measured in 30 second intervals and is expected to be less than
  10 MB and only a second or two.  At the end the correctnes of 
  the database will be verified (via record counts and summary 
  totals) and the TPM Rate will be recorded.
 
Test #2 (The system holds up in heavy/burst load):
  Run a 100,000 TPM load on each machine for 10 minutes.  Data lag
  is expected to increase steadily throughout the test and then 
  to catchup within a few minutes (at most) upon completition of the test.
 
Test #3 (The system holds up under continuous load)
  Run a 2,500 TPM load on each machine for 5 hours.  The Data lag will
  be measured in 30 second intervals and is expected to be less than
  10 MB and only a second or two thoughout.  At the end the correctnes of
  the database will be verified (via record counts and summary totals) and
  the TPM Rate will be recorded.

