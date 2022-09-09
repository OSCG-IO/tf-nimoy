
HOST="$1"
SSH="ssh -o StrictHostKeyChecking=accept-new"

set -x

$SSH $HOST "/db/oscg/io stop > /dev/null 2>&1"

$SSH $HOST "sudo rm -rf /db/oscg"

