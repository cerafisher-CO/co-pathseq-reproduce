#!/usr/bin/env bash
set -euo pipefail
bash /code/PathSeqFilter.sh --input_bam=/data/ubams/Sample1.bam --out_base=Sample1_filtered_reads --kmer-file=/data/host-kmers/saccro_host_kmers.hss.bfi --is-host-aligned=False --filter-bwa-image=/data/host-img/GCF_000146045.2_R64_genomic.img --filter-metrics=metrics.txt

