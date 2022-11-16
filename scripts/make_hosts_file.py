import os

f = open('nodes/' + os.environ['CLUSTER']+ '/' + os.environ['CLUSTER'] + '.out', 'r')
fa = open('nodes/' + os.environ['CLUSTER']+ '/' + 'ansible_hosts', 'w')
fd = open('nodes/' + os.environ['CLUSTER']+ '/' + 'ansible_hosts_driver', 'w')
fh = open('hosts', 'w')

fh.write("" + os.linesep)
fa.write("[hosts_to_add_key]" + os.linesep)
fd.write("[hosts_to_io]" + os.linesep)

Lines = f.readlines()
nn=""

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
        fa.write(ii + os.linesep)
        fh.write(ii +  "   node" + n + "-1" + os.linesep)
        break

  if l.startswith('driver_public_ip'):
    for i in ls:
      if i.startswith('"') and i.endswith('"'):
        ii = i.replace('"',"")
        fa.write(ii + os.linesep)
        fd.write(ii + os.linesep)
        fh.write(ii +  "   driver" + n + "-1" + os.linesep)
        break

fh.write("" + os.linesep)
fa.write(os.linesep + "[hosts_to_add_key:vars]" + os.linesep + \
   'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' + os.linesep)
fd.write(os.linesep + "[hosts_to_io:vars]" + os.linesep + \
   'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' + os.linesep)
