#!/bin/bash -l

#Purpose: Download MetaPhlAn reference database

#$ -pe omp 8
#$ -P ilometagenomics
#$ -l h_rt=12:00:00
#$ -N mph4.2-DB
#$ -j y

# load the required modules and conda environment
# metaphlan v4.2.2
module load miniconda
conda activate mph4.2

#download database
metaphlan --install --db_dir /restricted/projectnb/ilometagenomics/data/Metaphlan4.2-DB