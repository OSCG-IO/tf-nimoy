
if [ ! -f "env.sh" ]; then
  echo "FATAL ERROR: missing env.sh file"
  exit 1
fi

source env.sh

cd scripts

python3 pge_cluster.py "$@"


