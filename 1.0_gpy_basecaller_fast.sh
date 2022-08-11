#!/bin/bash

#To run: basecaller_fast.sh

FAST5=/Users/emilyhumble/Desktop/minION_workflow/data/fast5
OUT=/Users/emilyhumble/Desktop/minION_workflow/data/basecalled

guppy_basecaller --cpu_threads_per_caller 4 -i $FAST5 \
-c dna_r9.4.1_450bps_fast.cfg -s $OUT \
--min_qscore 9 --records_per_fastq 0 --compress_fastq


