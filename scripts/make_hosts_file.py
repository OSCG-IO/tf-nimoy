import os

f = open('nodes/' + os.environ['CLUSTER']+ '/' + os.environ['CLUSTER'] + '.out', 'r')
fn = open('nodes/' + os.environ['CLUSTER']+ '/' + 'ansible_hosts_node', 'w')
fd = open('nodes/' + os.environ['CLUSTER']+ '/' + 'ansible_hosts_driver', 'w')
fh = open('hosts', 'w')

fh.write("" + os.linesep)
fn.write("[hosts]" + os.linesep)
fd.write("[hosts]" + os.linesep)

Lines = f.readlines()
nn=""
drive_ip=0

for line in Lines:
  l = line.strip()
  if l == "":
    continue

  if l.startswith("## "):
      n=l[-11]
      continue

  ls = l.split()
  if l.startswith('node_public_ip'):
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"")
        fn.write(ii + os.linesep)
        fh.write(ii +  "   node" + n + "-1  aws-" + n + "-" +  os.environ['N'+n]  + os.linesep)
        break

  if l.startswith('driver_public_ip'):
    drive_ip=1
    continue

  if drive_ip == 1:
    drive_ip=0
    for i in ls:
      ii = i.replace('"',"")
      ii = ii.replace(",","")
      fd.write(ii + os.linesep)
      fh.write(ii +  "   driver" + n + "-1" + os.linesep)
      break

fh.write("" + os.linesep)
fn.write(os.linesep + "[hosts:vars]" + os.linesep + \
   'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' + os.linesep)
fd.write(os.linesep + "[hosts:vars]" + os.linesep + \
   'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' + os.linesep)
