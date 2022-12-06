
SSH="ssh -o StrictHostKeyChecking=accept-new"
set -x

$SSH node1-1 "/db/oscg/io stop prompgexp > /dev/null 2>&1"
$SSH node1-1 "/db/oscg/io start prompgexp > /dev/null 2>&1"

$SSH node2-1 "/db/oscg/io stop prompgexp > /dev/null 2>&1"
$SSH node2-1 "/db/oscg/io start prompgexp > /dev/null 2>&1"

$SSH node3-1 "/db/oscg/io stop prompgexp > /dev/null 2>&1"
$SSH node3-1 "/db/oscg/io start prompgexp > /dev/null 2>&1"

