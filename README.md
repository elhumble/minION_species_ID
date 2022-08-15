# Species ID workflow with ONT amplicon data

This pipeline is designed for processing and analyzing Oxford Nanopore Technologies (ONT) 
MinION DNA-barcoding sequence data for species identification. 
Assumes barcoded reads sequenced on a Flongle flow cell. 

Basic knowledge of shell required –
this [tutorial](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)
and [cheat sheet](https://bioinformaticsworkbook.org/Appendix/Unix/UnixCheatSheet.html#gsc.tab=0)
may be helpful to get started.

-------------
# Table of contents
1. [Getting started](#start)
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
5. [Output files](#outputs)
6. [Software installation advice](#installadvice)

[top](#top)

## Getting started <a name="start"></a>

1. Download this Github repository onto your own computer

``` bash
cd ~ ## Change this to the directory where you would like to store this GitHub repo

git clone https://github.com/elhumble/minION_species_ID.git

# Go into your new minION_species_ID directory and examine its contents
cd minION_species_ID
ls
```

<br>

Your own copy of the `minION_species_ID` directory will be referred to as `BASEDIR` in the
scripts below. You should see the following subdirectories:

-   `data` has the raw fastq files we’ll be working on today

-   `data/meta` is for storing metadata associated with the pipeline

-   `data/out` is for storing output data produced by the pipeline

-   `data/raw` is for storing raw data

-   `docs` is for storing any relevant documents relating to the pipeline e.g. publications

-   `scripts` is for storing scripts

> The `cd` command in the Unix shell is used to move between directories and the `ls` command
is used to view the contents of directories

<br>

2. Install software. You will find further information on installing software in the
 [software installation advice](#installadvice) section of this repository.

## Software dependencies <a name="Dependencies"></a>
- MobaXterm (for Windows users only)
- Conda
- Guppy v3.1.5+781ed575

<a href="#top">Back to top</a>

## Input files <a name="inputs"></a>

Move MinKNOW folder containing fast5 files to `data/raw` The fast5 
files for a given sequencing run should be in their own folder within the `data/raw` folder.



- Create primer sequence files and save into `data/meta`
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
- If using a reference database, create a fasta file with your reference sequences and
 save it into `data/blastdb`. This file is used during the Blast step. The reliability of 
 the Blast species identification depends on the quality of this reference database - 
 curate carefully! Each sequence header should include the sample name, species identifier, 
 and barcoding gene, separated by spaces.


## Run the workflow <a name="runpipe"></a>

### 1. Inspect raw data <a name="raw"></a>

### 2. Basecalling <a name="base"></a>

### Concatenate files <a name="cat"></a>

### Quality assessment <a name="qc"></a>

### Adaptor trimming and demultiplexing <a name="demult"></a>

### Filtering <a name="filt"></a>

### NGSpeciesID <a name="ngspeciesid"></a>

## Output files <a name="outputs"></a>

## Software installation advice <a name="installadvice"></a>





