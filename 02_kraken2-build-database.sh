#!/bin/bash -l

#$ -j y
#$ -P uh2-sebas
#$ -pe omp 28
#$ -l h_rt=18:00:00

##############################################
#Create and Build Custom Kraken2Uniq Database#
##############################################

#load kraken2 from conda environment
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics

cd /restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/

OMP_NUM_THREADS=28

#Kraken2 database name
DBNAME="kraken2uniq-09222023"

#download taxonomy
kraken2-build --download-taxonomy --db $DBNAME

#download libraries in standard kraken2db to create custom database
kraken2-build --threads 28 --download-library archaea --db $DBNAME
kraken2-build --threads 28 --download-library bacteria --db $DBNAME
kraken2-build --threads 28 --download-library plasmid --db $DBNAME
kraken2-build --threads 28 --download-library viral --db $DBNAME
kraken2-build --threads 28 --download-library human --db $DBNAME
kraken2-build --threads 28 --download-library UniVec_Core --db $DBNAME

#download CHM13 human reference sequence to be added to human taxid 9606
kraken2-build --add-to-library /restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/chm13v2.0.fa --db $DBNAME

#download EuPathDB sequences into database library
cd library
curl -O -s http://ccb.jhu.edu/data/eupathDB/dl/eupathDB.tar.gz

#build database based on libraries
kraken2-build --threads 28 --build --db $DBNAME
