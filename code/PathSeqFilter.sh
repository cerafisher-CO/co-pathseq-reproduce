#! /usr/bin/env bash

#### Step 1: PathSeqFilterSpark 




gatk PathSeqFilterSpark \
  --input input_reads.bam \
  --paired-output output_reads_paired.bam \
  --unpaired-output output_reads_unpaired.bam \
  --min-clipped-read-length 60 \
  --kmer-file host_kmers.bfi \
  --filter-bwa-image host_reference.img \
  --filter-metrics metrics.txt \
  --bam-partition-size 4000000 \
  --spark-master 'local[8]' \
  --conf spark.driver.memory=32g \
  --conf spark.local.dir=/path/to/tmp