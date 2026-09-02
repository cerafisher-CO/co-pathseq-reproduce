#!/usr/bin/env bash
set -euo pipefail

#### PathSeqFilterSpark — named-parameter entry point

# ── Defaults ──────────────────────────────────────────────────────────────────
input_bam=""
out_base="filtered_reads"
kmer_file=""
is_host_aligned="false"
filter_bwa_image=""
filter_metrics="metrics.txt"

# ── Parse --flag=value arguments ──────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --input_bam=*)        input_bam="${1#*=}"       ;;
    --out_base=*)         out_base="${1#*=}"         ;;
    --kmer-file=*)        kmer_file="${1#*=}"        ;;
    --is-host-aligned=*)  is_host_aligned="${1#*=}"  ;;
    --filter-bwa-image=*) filter_bwa_image="${1#*=}" ;;
    --filter-metrics=*)   filter_metrics="${1#*=}"   ;;
    *) echo "Unknown argument: $1" >&2; exit 1       ;;
  esac
  shift
done

# ── Validate required parameters ──────────────────────────────────────────────
[[ -n "$input_bam" ]]        || { echo "Missing required argument: --input_bam=<path>"        >&2; exit 1; }
[[ -n "$kmer_file" ]]        || { echo "Missing required argument: --kmer-file=<path>"        >&2; exit 1; }
[[ -n "$filter_bwa_image" ]] || { echo "Missing required argument: --filter-bwa-image=<path>" >&2; exit 1; }

# ── Normalise boolean to lowercase (GATK expects true/false) ──────────────────
is_host_aligned="${is_host_aligned,,}"

# ── Prepare scratch dir ───────────────────────────────────────────────────────
mkdir -p /scratch/tmpdir

# ── Step 1: PathSeqFilterSpark ────────────────────────────────────────────────
cmd=(gatk --java-options "-Xmx4G" PathSeqFilterSpark
  --input              "${input_bam}"
  --is-host-aligned    "${is_host_aligned}"
  --paired-output      "../results/${out_base}_paired.bam"
  --unpaired-output    "../results/${out_base}_unpaired.bam"
  --min-clipped-read-length 60
  --kmer-file          "${kmer_file}"
  --filter-bwa-image   "${filter_bwa_image}"
  --bam-partition-size 4000000
  --spark-master       'local[*]'
  --conf               "spark.local.dir=/scratch/tmpdir"
)

[[ -n "$filter_metrics" ]] && cmd+=(--filter-metrics "../results/${filter_metrics}")

"${cmd[@]}"
