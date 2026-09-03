#!/usr/bin/env bash
## For any special handling needed for app panel parameters

# -e: exit immediately if any command exits with a non-zero status
# -x: print each command to stderr before executing it (useful for debugging pipeline runs)
set -ex

# 1. Check whether the script was invoked with any positional arguments ($# is
# the argument count). If none were passed, just note that the script is
# running. If arguments were passed, print each one individually — this is
# purely informational/logging, it doesn't affect control flow later.
#### Note to self added while WIP, I'm going to use named arguments, so I might need to use 
#### different stuff here. 
if [ $# -eq 0 ]; then
  echo "Running"
else
  echo "args:"
  for i in $*; do 
    echo $i 
  done
  echo ""
fi

# 2. Thread count resolution. If no first argument was supplied, fall back to a helper 
# variable from CO utils, #get_cpu_count. 
if [ -z "${1}" ]; then
  num_thread=$(get_cpu_count)
else
  if [ "${1}" -gt $(get_cpu_count) ]; then
    echo "Requesting more threads than available. Setting to Max Available."
    num_thread=$(get_cpu_count)
  else
    num_thread="${1}"
  fi
fi



