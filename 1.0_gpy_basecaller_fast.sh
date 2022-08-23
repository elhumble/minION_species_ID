#!/bin/bash

#To run: gpy_basecaller_fast.sh

FAST5=/Users/emilyhumble/Desktop/minION_species_ID/data/raw/Anjani/20220819_1442_MN40942_AMF553_854054a3/fast5 # set path to directory containing fast5 files
OUT_DIR=/Users/emilyhumble/Desktop/minION_species_ID/data/out/basecalled/Anjani # set path to basecalled output directory

guppy_basecaller --cpu_threads_per_caller 4 -i $FAST5 \
-c dna_r9.4.1_450bps_fast.cfg -s $OUT_DIR \
--min_qscore 9 --records_per_fastq 0 --compress_fastq


