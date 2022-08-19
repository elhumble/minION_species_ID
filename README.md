# Species ID workflow with ONT amplicon data

This pipeline is designed for processing and analyzing Oxford Nanopore Technologies (ONT) 
MinION DNA-barcoding sequence data for species identification. 
Assumes barcoded reads sequenced on a Flongle flow cell. 

-------------
# Table of contents
1. [Basic shell scripting](#shell)
2. [Download this GitHub repository to local machine](#clone)
2. [Software dependencies](#Dependencies)
3. [Input files](#inputs)
4. [Run the pipeline](#runpipe)
    1. [Inspect raw data](#raw)
    2. [Basecalling](#base)
    3. [Concatenate files](#cat)
    4. [Quality assessment](#qc)
    5. [Adaptor trimming and demultiplexing](#demult)
    6. [Filtering](#filt)
    7. [NGSpeciesID](#ngspeciesid)
5. [Software installation advice](#installadvice)

[Back to top](#top)

## Basic shell scripting <a name="shell"></a>

This workflow assumes a basic understanding of shell scripting. [This tutorial](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)
and [cheat sheet](https://bioinformaticsworkbook.org/Appendix/Unix/UnixCheatSheet.html#gsc.tab=0)
may be helpful to get started.

## Download this GitHub repository to local machine <a name="clone"></a>

First retrieve a copy of this repository and save it onto your local machine by clicking on the green
Code button at the top of this page followed by Download ZIP.

> Your own copy of this directory will be referred to as BASEDIR in many of the commands and scripts below. 

Take a look around:

``` bash
# Move into your new minION_species_ID directory and examine its contents

BASEDIR=~/Desktop/minION_species_ID # Full path to repository

cd $BASEDIR 
ls
```
You should see the following subdirectories:

-   `data` contains subdirectories for storing data associated with the pipeline
-   `data/meta` is for storing metadata associated with the pipeline
-   `data/out` is for storing output data produced by the pipeline
-   `data/raw` is for storing raw data
-   `docs` is for storing any relevant documents relating to the pipeline e.g. publications
-   `scripts` is for storing scripts

> Tip: The `cd` command in the Unix shell is used to move between directories and the `ls` command
is used to view the contents of directories

<br>
<a href="#top">Back to top</a>

## Software dependencies <a name="Dependencies"></a>

The following software is required to run the pipeline. You will find further information on 
installing these in the [software installation advice](#installadvice) section at the bottom of this repository.
Make sure you have got these up and running before proceeding.
 
- Guppy
- hd5
- NanoFilt
- NGSpeciesID
- R & RStudio
- MobaXterm (for Windows users only)
- Text editor for example BBEdit for MacOSX or NotePad++ for Windows


<a href="#top">Back to top</a>

## Input files <a name="inputs"></a>

We need to transfer the raw sequencing files from MinKNOW into our new `minION_species_ID` repository
so that we can analyse the data. Let's first locate the raw sequencing files:

- Open MinKNOW
- Go to ‘Experiments’ in the left menu bar
- Choose the relevant sampling run e.g. CVRI_test_2
- Click on this sampling run
- Note the file path listed under ‘Current output directory’ e.g.
`/Library/MinKNOW/data/CVRI_test_2/sample_1/flowcell_2`

Copy this directory of raw data into your `minION_species_ID` repository.

``` bash
MINKNOW_DIR=/Library/MinKNOW/data/CVRI_test_2/sample_1/flowcell_2 # Change to where raw data is saved in MinKNOW
BASEDIR=~/Desktop/minION_species_ID # Change to minION_species_ID directory

cp -r $MINKNOW_DIR $BASEDIR/data/raw

#Check the files have been copied across

cd data/raw
ls
```
> Tip: The fast5 files for a given sequencing run should be in their own folder within the `data/raw` folder.

We will need a file containing our primer sequences for later on in the pipeline. Create this using
a text editor and save into `data/meta`.

Example:
```
>Tryp_R2_UT__rev
CAGGTCTGTGATGCTCCTCRATGGAAGATAGAGCGACAGGCAAGT
>Tryp_R2_UT
ACTTGCCTGTCGCTCTATCTTCCATYGAGGAGCATCACAGACCTG
>Tryp_R2_rev
CAGGTCTGTGATGCTCCTCRATG
>Tryp_R2
CATYGAGGAGCATCACAGACCTG
>Tryp_F6_UT_rev
GGATCTCGTCCGTTGACGGAAGCAATATCAGCACCAACAGAAA
>Tryp_F6_UT
TTTCTGTTGGTGCTGATATTGCTTCCGTCAACGGACGAGATCC
>Tryp_F6__rev
GGATCTCGTCCGTTGACGGAA
>Tryp_F6
TTCCGTCAACGGACGAGATCC
```

## Run the workflow <a name="runpipe"></a>

### 1. Inspect raw data <a name="raw"></a>

We will use the HDF5 software library to explore our raw ONT data.

``` bash

# First load conda environment containing the hdf5 package

conda activate hdf5

# View complete file content in readable form

h5dump $BASEDIR/data/raw/fast5/<filename.fast5> | more

# Get an overview of all the reads within a fast5 file

h5ls $BASEDIR/data/raw/fast5/<filename.fast5>

Count the reads in a fast5 file

h5ls $BASEDIR/data/raw/fast5/<filename.fast5>

# To inspect information stored for a specific read you can specify the read as though it were
a directory in the command line

h5ls $BASEDIR/data/raw/fast5/<filename.fast5>/<readname>

# Inspect the raw signal for a specific read

h5ls -d $BASEDIR/data/raw/fast5/<filename.fast5>/<readname>/Raw/Signal

# deactivate conda env

conda deactivate

```


### 2. Basecalling <a name="base"></a>

Basecalling is the process in which we convert the raw sequencing signal stored within
the fast5 files into bases. We will use guppy to basecall our raw sequencing reads.

There are two scripts available within this pipeline to do this: `gpy_basecaller_fast.sh`
and `gpy_basecaller_hac.sh.` These reflect the two modes in which guppy can be run: fast and
high accuracy. For our training dataset, run time for the fast basecaller is around 2 hours while
run time for the high accuracy basecaller is around 12-15 hours. The high accuracy basecaller
is recommended. Both are executed in the same way.

```bash
# Create a directory for basecalled data

mkdir $BASEDIR/data/out/basecalled

```
Edit the basecaller script so that the variable names point to the correct directories.

```bash

# Run the script

./1.1_gpy_basecaller_hac.sh

```
The `basecalled` directory should now contain the log files, a sequencing_summary.txt file
and two new directories: `pass` and `fail`.

Take a look in these new folders. What files can you see?

### 3. Concatenate files <a name="cat"></a>

We will now concatenate all passed `fastq.gz` files generated by guppy into one file.

```bash

# Make a new directory for this file

mkdir $BASEDIR/data/out/basecalled/passed_reads

# Concatenate passed fastq files

cat data/out/basecalled/pass/*.fastq.gz > data/out/basecalled/passed_reads/passed_reads.fastq.gz

```

### 4. Quality assessment <a name="qc"></a>

We will use the R script MinIONQC to generate diagnostic plots and data for quality control (QC) of our sequencing data.
This R package works directly with the `sequencing_summary.txt` file produced by Guppy. More info 
[here](https://github.com/roblanf/minion_qc).

```bash
# Create a directory for QC data

mkdir data/out/qc

```
Edit the `2.0_min_QC.sh` script so that the variable names point to the correct directories.


```bash
# Run R through the terminal

R

# install required packages

install.packages(c("data.table","futile.logger","ggplot2","optparse","plyr","readr","reshape2","scales","viridis","yaml"))

# Quit R
quit()

# Run the script

./2.0_min_QC.sh
```

The output folder should contain summary plots of sequencing performance. Take a look at these.

### 5. Adaptor trimming and demultiplexing <a name="demult"></a>

We will next use Guppy to demultiplex our data according to barcode and trim barcodes of sequencing reads.
The barcode kit is specified in the script, in this case: EXP-PBC001

```bash
# Create a directory for demultiplexed data

mkdir data/out/demultiplexed

```

Edit the `3.0_gpy_barcoder.sh` script so that the variable names point to the correct directories.

```bash
# Run the script

./2.0_gpy_barcoder.sh
```

The output folder should now contain folders for each barcoded set of sequences that correspond to samples.

### 6. Filtering <a name="filt"></a>

We will now filter our fastq files for quality and read length. This step is optional as
NGSpeciesID performs well without filtered reads.

Edit the `4.0_nanofilt.sh` script so that the variable names point to the correct directories.

```bash
# Run the script

./4.0_nanofilt.sh
```

The output is a filtered fastq file in each barcode directory.


### 7. NGSpeciesID <a name="ngspeciesid"></a>

NGSpeciesID is a tools for generating highly accurate consensus sequences from ONT data. We will run it
using the script `5.0_NGSpeciesID.sh` which filters reads on size, clusters reads based on the isONclust algorithm, 
creates draft consensus sequences using spoa and refines consensus sequences using racon and removes primer sequences. 

```bash
# Create a directory for NGSpeciesID output

mkdir data/out/ngspecies_id
```

Edit the `5.0_NGSpeciesID.sh` script so that the variable names point to the correct directories.

Edit the `--m` (mean amplicon length), `--s` (size range) and `--abundance_ratio`
(threshold proportion of total reads for a cluster to be retained) parameters in the `5.0_NGSpeciesID.sh`
script.

Ensure primer files are correct.

Suggested parameters for COI fish primers:

Parameter | Value
--- | ---
--m | 500
--s | 100
--abundance_ratio | 0.05

The output is one directory per barcode containing fasta consensus sequences. These can be used
for blasting against a database.

## Software installation advice <a name="installadvice"></a>

One of the easiest ways to install most of the software required for this pipeline is to use `conda` from Anaconda.

- Download Miniconda3 [here](https://docs.conda.io/en/latest/miniconda.html#:~:text=Miniconda%20is%20a%20free%20minimal,zlib%20and%20a%20few%20others).
We want Miniconda3 so that it downloads Python3.
Follow installation instructions from website.

- Once you have miniconda, configure the conda command to tell it where to look online for software. It does not matter what directory you’re in.
  - `conda config --add channels bioconda`  
  - `conda config --add channels conda-forge` 

#### Basecall: Guppy
https://community.nanoporetech.com/downloads

- I downloaded Mac OSX version  
- `unzip ont-guppy-cpu_2.3.1_osx64.zip`  
- Add guppy to bashrc path (`export PATH=$PATH:<your path>/ont-guppy-cpu/bin`) 


#### HDF5
https://anaconda.org/anaconda/hdf5

Create and activate a new environment called minion-spid. This is where we will install most of the packages needed for the
pipeline and will help us isolate and manage our project.

`conda create -n hdf5 python=3.6 pip`  
`conda activate hdf5`  

Install nanofilt into that environment. Deactivate env.

`conda install -c anaconda hd5`  
`h5dump`  
`conda deactivate` 

#### Nanofilt
https://github.com/wdecoster/nanofilt

`conda create -n nanofilt python=3.6 pip`  
`conda activate nanofilt`  
`conda install -c bioconda nanofilt`  
`NanoFilt --help`  
`conda deactivate`  
 

#### NGSpeciesID
https://github.com/ksahlin/NGSpeciesID

`conda create -n NGSpeciesID python=3.6 pip`  
`conda activate NGSpeciesID`  
`conda install --yes -c conda-forge -c bioconda medaka==0.11.5 openblas==0.3.3 spoa racon minimap2`  
`pip install NGSpeciesID`  
`NGSpeciesID --help`  
`conda deactivate` 
 

