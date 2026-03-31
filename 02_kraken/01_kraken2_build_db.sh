#!/bin/bash -l
#$ -pe omp 16
#$ -P ilometagenomics
#$ -l h_rt=96:00:00
#$ -N build_db
#$ -j y
#$ -o /restricted/projectnb/ilometagenomics/data/Kraken2-DB/Kraken2-DB-06252025/logs/

##############################################
#Create and Build Custom Kraken2Uniq Database#
##############################################

#load required modules
#activate conda environment to run KneadData v0.12.3
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers

#environment variable to set number of cores
OMP_NUM_THREADS=16

#Kraken2 db path
DBNAME="/restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2-DB-06252025/kraken2-06252025"


#download taxonomy
kraken2-build --download-taxonomy --db $DBNAME

#download reference libraries
kraken2-build --threads 16 --download-library archaea --db $DBNAME
kraken2-build --threads 16 --download-library bacteria --db $DBNAME
kraken2-build --threads 16 --download-library plasmid --db $DBNAME
kraken2-build --threads 16 --download-library viral --db $DBNAME
kraken2-build --threads 16 --download-library human --db $DBNAME
kraken2-build --threads 16 --download-library UniVec_Core --db $DBNAME

#Add CHM13 human reference sequence to library
kraken2-build --add-to-library chm13v2.0.fa --db $DBNAME

#Download Eupath Sequences
cd $DBNAME
wget http://ccb.jhu.edu/data/eupathDB/dl/eupathDB.tar.gz
time tar -xvzf eupathDB.tar.gz

#build custom database based on libraries
kraken2-build --threads 16 --build --db $DBNAME
