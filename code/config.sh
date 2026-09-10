#!/usr/bin/env bash
## For any special handling needed for app panel parameters

# -e: exit immediately if any command exits with a non-zero status
# -x: print each command to stderr before executing it (so you can see what each round of a for loop does, for example)
set -ex

# 1. Check whether the script was invoked with any positional arguments ($# is
# the argument count). If none were passed, just note that the script is
# running. If arguments were passed, print each one individually — this is
# purely informational/logging, it doesn't affect control flow later.

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

# 3. Find the BAM file. We want to set this up to be able to generalize across whatever data asset we get. PathseqFilter can run on bam/sam/cram but will need a .crai if it gets a cram. 
some_alignment=$(find -L ../data \( -name "*.bam" -o -name "*.sam" -o -name "*.cram" \) | head -1)
if [[ "$some_alignment" == *.cram ]]; then
  cram_base=$(basename "$some_alignment")
  some_index=$(find -L ../data \( -name "${cram_base}.crai" -o -name "${cram_base%.cram}.crai" \) | head -1)
  if [ -z "$some_index" ]; then
    echo "Error: no .crai index found for $some_alignment" >&2 ## todo - test
    exit 1
  fi
fi

# 4. Find the host kmer file 
kmer_file=$(find -L ../data \( -name "*.hss" -o -name "*.bfi" \) | head -1)

if [ -z "$kmer_file" ]; then
    echo "Error: No host kmer file found" >&2
    exit 1
else
    echo "Host kmer file: $kmer_file"
fi

# 5. Find the host BWA img file 
host_img=$(find -L ../data \( -name "*.img$" ))

