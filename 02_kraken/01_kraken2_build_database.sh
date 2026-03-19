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

#load kraken2
module load miniconda
conda activate mgx_classifiers

OMP_NUM_THREADS=16

#Kraken2 db path
DBNAME="/restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2-DB-06252025/kraken2-06252025"


#download taxonomy
kraken2-build --download-taxonomy --db $DBNAME

#download libraries in standard kraken2db to create custom database
kraken2-build --threads 16 --download-library archaea --db $DBNAME
kraken2-build --threads 16 --download-library bacteria --db $DBNAME
kraken2-build --threads 16 --download-library plasmid --db $DBNAME
kraken2-build --threads 16 --download-library viral --db $DBNAME
kraken2-build --threads 16 --download-library human --db $DBNAME
kraken2-build --threads 16 --download-library UniVec_Core --db $DBNAME

#download CHM13 human reference sequence to be added to human taxid 9606
kraken2-build --add-to-library /restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/chm13v2.0.fa --db $DBNAME

#Download Eupath Sequences for Kraken2 Custom Database#
cd $DBNAME
wget http://ccb.jhu.edu/data/eupathDB/dl/eupathDB.tar.gz
time tar -xvzf eupathDB.tar.gz

#build database based on libraries
kraken2-build --threads 16 --build --db $DBNAME
