#!/bin/bash

#To run: nanofilt.sh

#source /Users/rob/anaconda3/etc/profile.d/conda.sh
#conda activate nanofilt


TARGET_DIR=/Users/emilyhumble/Desktop/minION_workflow/data/demultiplexed


for f in barcode01 barcode02 barcode03 barcode04 barcode06 \
barcode06 barcode07 barcode08 barcode09 barcode10 barcode11 barcode12; do
echo $TARGET_DIR/$f/*
gunzip $TARGET_DIR/$f/*
  nanofilt -q 7 -l 300 --maxlength 600 \
  < $TARGET_DIR/$f/* \
  > $TARGET_DIR/$f/${f}_filtered.fastq
done



