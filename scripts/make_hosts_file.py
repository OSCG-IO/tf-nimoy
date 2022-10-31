import os

f = open('nodes/' + os.environ['CLUSTER_NM']+ '/' + os.environ['CLUSTER_NM'] + '.out', 'r')
fa = open('ansible_hosts', 'w')
fh = open('hosts', 'w')

fh.write("" + os.linesep)
fa.write("[hosts_to_add_key]" + os.linesep)

Lines = f.readlines()
nn=""

for line in Lines:
  l = line.strip()
  if l == "":
    continue

  if l.startswith("## "):
      n=l[4:5]
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
        fh.write(ii +  "   driver" + n + "-1" + os.linesep)
        break

fh.write("" + os.linesep)
fa.write(os.linesep + "[hosts_to_add_key:vars]" + os.linesep + \
   'ansible_ssh_common_args="-o StrictHostKeyChecking=no"' + os.linesep)

