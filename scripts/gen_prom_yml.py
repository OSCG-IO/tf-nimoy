#!/usr/bin/python3

import sys, os, shutil

os.chdir(sys.path[0])

if len(sys.argv) < 2:
  print("ERROR: At least one server must be specified")
  sys.exit(1)


############### MAINLINE ######################

shutil.copyfile('../conf/prometheus.yml.sample', '../prometheus.yml')

print(str(sys.argv))
