#!/bin/bash

#To run: gpy_basecaller_hac.sh

guppy_basecaller --cpu_threads_per_caller=12 -i /Users/rob/MinION/training/fast5/fast5 \
-c dna_r9.4.1_450bps_hac.cfg -s /Users/rob/MinION/training/basecaller \
--min_qscore=9 --records_per_fastq=0 --compress_fastq


