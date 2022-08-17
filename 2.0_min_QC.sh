#!/bin/bash

# To run: ./MinQC.sh

LOCATION=/Users/emilyhumble/Desktop/minION_workflow/scripts # Set path to directory containing MinIONQC.R script
INPUT_DIR=/Users/emilyhumble/Desktop/minION_workflow/data/basecaller # Set path to directory containing output from guppy
OUTPUT_DIR=/Users/emilyhumble/Desktop/minION_workflow/data/qc # Set path to qc output directory

$LOCATION/MinIONQC.R -q 9 -i $INPUT_DIR/sequencing_summary.txt -o $OUTPUT_DIR
