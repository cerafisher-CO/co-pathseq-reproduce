#!/usr/bin/env bash
## For any special handling needed for app panel parameters


set -ex

if [ $# -eq 0 ]; then
  echo "Running"
else
  echo "args:"
  for i in $*; do 
    echo $i 
  done
  echo ""
fi
