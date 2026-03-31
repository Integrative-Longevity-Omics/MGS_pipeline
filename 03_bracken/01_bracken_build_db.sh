#!/bin/bash -l

#$ -j y
#$ -P ilometagenomics
#$ -pe omp 16
#$ -l mem_per_core=16G
#$ -l h_rt=12:00:00
#$ -N bracken_database

###################################################
# Create Bracken k-mer distribution database file #
###################################################

#load required modules and conda environment
#Bracken v.3.0.1 
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers

#move into directory
database_dir=/restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2-DB-06252025
cd $database_dir

#environment variable to set number of cores
#suggested by github to run with 16-20 threads
OMP_NUM_THREADS=16

#Kraken2 database name
DBNAME="kraken2-06252025"

#build bracken database file based on kraken2uniq database
bracken-build -d $DBNAME -t 16 -k 35 -l 150
