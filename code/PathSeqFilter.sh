#!/usr/bin/env bash
set -euo pipefail

source ./config.sh
#### PathSeqFilterSpark — named-parameter entry point

# ── Defaults 
input_bam="../data/ubams/Sample1.bam"
out_base="Sample1"
kmer_file="../data/host-kmers/saccro_host_kmers.hss.bfi"
is_host_aligned="false"
filter_bwa_image="../data/host-img/GCF_000146045.2_R64_genomic.img"
filter_metrics="metrics.txt"



echo "gatk --java-options '-Xmx4G' PathSeqFilterSpark \  --input              ${input_bam} \  --is-host-aligned    ${is_host_aligned} \  --paired-output      /results/${out_base}_paired.bam \  --unpaired-output    /results/${out_base}_unpaired.bam \  --min-clipped-read-length 60   --kmer-file          ${kmer_file} \  --filter-bwa-image   ${filter_bwa_image} \  --bam-partition-size 4000000 \  --spark-master       'local[*]' \  --conf               spark.local.dir=/scratch/tmpdir \"
