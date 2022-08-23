#!/bin/bash

# To run: ./MinQC.sh

LOCATION=/Users/emilyhumble/Desktop/minION_species_ID/scripts # Set path to directory containing MinIONQC.R script

INPUT_DIR=/Users/emilyhumble/Desktop/minION_species_ID/data/out/basecalled/anjani  # Set path to directory containing output from guppy
OUTPUT_DIR=/Users/emilyhumble/Desktop/minION_species_ID/data/out/qc # Set path to qc output directory

$LOCATION/MinIONQC.R -q 9 -i $INPUT_DIR/sequencing_summary.txt -o $OUTPUT_DIR
