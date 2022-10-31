
import sys, sqlite3, os

import fire

os.chdir(sys.path[0])
connection = sqlite3.connect("../conf/stelthy.db")


def launch(cluster_nm, nodes, cloud=None, type=None, opsys=None, platform=None, pgv=None):
  os.environ['CLUSTER_NM'] = str(cluster_nm)
  if cloud:
    os.environ['CLOUD'] = str(cloud)
  if type:
    os.environ['TYPE'] = str(type)
  if opsys:
    os.environ['OS'] = str(opsys)
  if platform:
    os.environ['PLATFORM'] = str(platform)
  if pgv:
    os.environ['PGV'] = str(pgv)

  clusdir = os.getcwd() + "/../nodes/" + str(cluster_nm)
  os.environ['NN'] =  clusdir

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

    NN = "N" + str(k)

    os.environ['N' + str(k)] = str(nd_arr[0])  
    os.environ['N' + str(k) + 'Z'] = str(nd_arr[1])  
    os.environ['NN' + str(k)] = clusdir + "/n" + str(k)

  os.environ['NODE_KOUNT'] = str(k)

  os.system("./launchServers.sh")


if __name__ == '__main__':
  fire.Fire({
      'launch': launch,
  })

