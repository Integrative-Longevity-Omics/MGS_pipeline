#!/bin/bash -l

#$ -cwd
#$ -j y
#$ -P uh2-sebas 
#$ -pe omp 16 
#$ -l h_rt=24:00:00

##############################################
#      Run Kraken2Uniq Classification 		 #
##############################################

#load kraken2 from conda environmnet
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics

#Directory of fastq files
DIR="/restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/kneaddata_out"
OUTPUT="/restricted/projectnb/uh2-sebas/analysis/metagenomics/meg_analyses/kraken2uniq_kneaddata_feb2023/Reports"

#Kraken2 database
DBNAME="/restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/kraken2uniq-09222023"

#Run Kraken2 of that sample
kraken2 --threads 16 --db $DBNAME \
	--output ${OUTPUT}/${SAMPLE}.kraken.txt \
	--report ${OUTPUT}/${SAMPLE}.aggregated.report.txt \
	--minimum-hit-groups 4 \
	--report-minimizer-data \
	--report-zero-counts \
	--use-names \
	--paired \
	--gzip-compressed ${DIR}/${SAMPLE}_R1_001_kneaddata.fastq.gz  ${DIR}/${SAMPLE}_R2_001_kneaddata.fastq.gz 
