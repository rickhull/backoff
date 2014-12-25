#!/bin/bash

if [ ! -f $1 ]; then
  echo "bad arg: $1"
  exit 1
fi
if [ ! -x $1 ]; then
  echo "not executable: $1"
  exit 1
fi

if [ "$2" == "" ]; then
  seq="20 3 35"
else
  seq=$2
fi

status() {
  echo -n "Load Avg: "; cat /proc/loadavg
  date +"%T.%6N"
}

status
for i in `seq $seq`; do
  echo; echo "===    time $1 $i    ==="
  time $1 $i
done
echo
status
