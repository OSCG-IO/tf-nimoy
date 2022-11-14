
import sys, sqlite3, os

import fire

os.chdir(sys.path[0])

#connection = sqlite3.connect("../conf/stelthy.db")

NODES_DIR = os.getcwd() + "/../nodes"
KEYS_DIR  = os.getcwd() + "/../keys"


def launch(cluster, nodes, cloud=None, machine=None, opsys=None, platform=None, pgv=None, key=None):

  clusdir = NODES_DIR + "/" + str(cluster)
  if os.path.isdir(clusdir):
    print("ERROR: Cluster Directory already exists: " + clusdir, file=sys.stderr)
    sys.exit(1)

  os.mkdir(clusdir)
  f = open(clusdir + '/env.sh', 'w')

  set_environ('NN', clusdir, f)

  set_environ('CLUSTER', str(cluster), f)

  if cloud:
    os.environ['CLOUD'] = str(cloud)
  write_cluster_env('CLOUD', os.environ['CLOUD'], f)

  if machine:
    os.environ['MACHINE'] = str(machine)
  write_cluster_env('MACHINE', os.environ['MACHINE'], f)

  if opsys:
    os.environ['OPSYS'] = str(opsys)
  write_cluster_env('OPSYS', os.environ['OPSYS'], f)

  if platform:
    os.environ['PLATFORM'] = str(platform)
  write_cluster_env('PLATFORM', os.environ['PLATFORM'], f)

  if pgv:
    os.environ['PGV'] = str(pgv)
  write_cluster_env('PGV', os.environ['PGV'], f)

  nodes = str(nodes)
  node_arr = nodes.split(',')

  k=0
  for node in node_arr:
    k = k + 1
    nd = node.strip()

    nd_arr = nd.split('-')
    if len(nd_arr) != 2:
      print("ERROR: node '" + nd + "' must contain an AZ")
      sys.exit(1)

    set_environ('N' + str(k), str(nd_arr[0]), f)

    set_environ('N' + str(k) + 'Z', str(nd_arr[1]), f)

    set_environ('NN' + str(k), clusdir + '/n' + str(k), f)

  set_environ('NODE_KOUNT', str(k), f)

  f.close()

  os.system("./launchServers.sh")


def set_environ(p_var, p_val, p_f):
  os.environ[str(p_var)] = str(p_val)
  write_cluster_env(p_var, p_val, p_f)


def write_cluster_env(p_var, p_val, p_f):
  p_f.write("export " + p_var + "=" + p_val + "\n")


def destroy(cluster, nodes=None):
  os.system("./destroyServers.sh " + str(cluster))


def list(cluster_pattern=""):
  os.system("ls -l " + NODES_DIR + "/" + str(cluster_pattern))


def keygen(key=""):
  os.system("ssh-keygen -t rsa -f " + KEYS_DIR + "/" + key)


if __name__ == '__main__':
  fire.Fire({
      'launch': launch,
      'destroy': destroy,
      'list': list,
      'keygen': keygen,
  })

