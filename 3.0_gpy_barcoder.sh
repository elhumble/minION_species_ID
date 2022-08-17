#!/bin/bash

#To run: gpy_barcoder.sh

INPUT_DIR=/Users/emilyhumble/Desktop/minION_workflow/data/basecaller/passed_reads # Set path to directory containing concatenated fastq file
OUTPUT_DIR=/Users/emilyhumble/Desktop/minION_workflow/data/demultiplexed # Set path to output directory for demultiplexed data

guppy_barcoder --worker_threads 8 \
-i $INPUT_DIR \
--trim_barcodes \
--barcode_kits EXP-PBC001 \
-s $OUTPUT_DIR \
--records_per_fastq 0 \
--compress_fastq

#--min_score 60 \
