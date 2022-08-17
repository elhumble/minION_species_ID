#!/bin/bash 

#To Run: NGSpeciesID.sh

source /opt/miniconda3/etc/profile.d/conda.sh
conda activate NGSpeciesID

TARGET_DIR=/Users/emilyhumble/Desktop/minION_species_ID/data/out/demultiplexed # Set path to directory containing demultiplexed data
OUT_DIR=/Users/emilyhumble/Desktop/minION_species_ID/data/out/ngspecies_id # Set path to NGSpeciesID output directory
PRIMER_DIR=/Users/emilyhumble/Desktop/minION_species_ID/data/meta # Set path to directory containing primer sequences

#~~ Create directories


for i in barcode01 barcode02 barcode03 barcode04 barcode06 \
barcode07 barcode08 barcode09 barcode10 barcode11 barcode12; do
mkdir $OUT_DIR/$i
done

#~~ Run NGSpecies ID across of barcode sequences

for i in barcode01 barcode02 barcode03 barcode04 barcode06 \
barcode07 barcode08 barcode09 barcode10 barcode11 barcode12; do

echo $TARGET_DIR/$i/*

NGSpeciesID --ont \
--fastq $TARGET_DIR/$i/*filtered.fastq \
--outfolder $OUT_DIR/$i \
--consensus --m 350 \
--s 100 \
--racon \
--racon_iter 3 \
--abundance_ratio 0.05 \
--primer_file $PRIMER_DIR/RLB_primers.fa 

  
done
