HOST=$1
SSH="ssh -o StrictHostKeyChecking=accept-new"

set -x

$SSH $HOST 'cd /db; python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"'

