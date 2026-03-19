#!/bin/bash -l

#$ -pe omp 8
#$ -P ilometagenomics
#$ -l h_rt=12:00:00
#$ -N mph4.2-DB
#$ -m bea 
#$ -M sibald@bu.edu
#$ -j y

# load the required modules
# metaphlan v4.2.2
module load miniconda
conda activate mph4.2

metaphlan --install --db_dir /restricted/projectnb/ilometagenomics/data/Metaphlan4.2-DB