#!/bin/bash -l
#$ -pe omp 1
#$ -P cometsfba
#$ -l h_rt=02:00:00
#$ -N kraken-db
#$ -j y
#$ -o /restricted/projectnb/uh2-sebas/analysis/biobakery_output_feb2023/qsub_logs/

#######################################################
#Download Eupath Sequences for Kraken2 Custom Database#
#######################################################

cd /restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/library
curl -O -s http://ccb.jhu.edu/data/eupathDB/dl/eupathDB.tar.gz



