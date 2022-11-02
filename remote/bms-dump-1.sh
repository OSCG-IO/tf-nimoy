
source env.sh

if [ $# == 1 ]; then
  dump_file=dump-$1.custom
  is_binary=true
else
  is_binary=false
  dump_file=dump.sql
fi

if [ ! -d $dump_dir ]; then
  user=`whoami`
  sudo mkdir -p $dump_dir
  sudo chown -R $user:$user /db
fi
dumper=$dump_dir/$dump_file

DUMP="pg_dump -U postgres -h node1-1 -v -d demo"

if [ "$is_binary" == "true" ]; then
  if [ -f $dumper ]; then
    read -p "Overwrite what's there? (y or n) " -n 1 -r
    echo ""
    if [ "$REPLY" == "y" ]; then
      rm -f $dumper
    else
      echo "Goodbye!"
      exit 1
    fi
  fi
  DUMP="$DUMP -Fc -f $dumper"
else
  # always overlay without warning
  rm -f $dumper
  DUMP="$DUMP -f $dumper"
fi

echo ""
echo "$DUMP"
$HOME/oscg/$pgXX/bin/$DUMP
rc=$?
echo ""
ls -sh $dumper
exit $rc

