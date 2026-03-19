#!/bin/bash -l

#Author: Tanya Karagiannis
#Purpose: Run Kraken2 on each sample

#$ -pe omp 28
#$ -P ilometagenomics
#$ -l h_rt=120:00:00
#$ -N kraken2_batch
#$ -j y
#$ -o /restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_june2024/scripts/logs
#$ -t 1-218
#total 218 samples

#load kraken2
module load miniconda
conda activate mgx_classifiers

#kneaddata directory
DATA_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kneaddata_fastq/kneaddata_out_june2024_07142025

#enter kneaddata directory
cd $DATA_DIR

#list of filenames from all samples
filename=$(ls *_kneaddata_paired_1.fastq.gz)
echo "$filename"

#select sample based on the task ID
input_file=$(echo "$filename" | sed -n "${SGE_TASK_ID}p" )
echo "$input_file"

#get sample label from filename
SAMPLEARG=$(echo "$input_file" | cut -d'_' -f1)
echo "$SAMPLEARG"

#output directory
OUTPUT=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_june2024/Reports
mkdir $OUTPUT

#Kraken2 database
DBNAME=/restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2-DB-06252025/kraken2-06252025

#Run Kraken2 of that sample
kraken2 --threads 28 --db $DBNAME \
        --output ${OUTPUT}/${SAMPLEARG}.kraken.txt \
        --report ${OUTPUT}/${SAMPLEARG}.aggregated.report.txt \
		--minimum-hit-groups 4 \
        --report-minimizer-data \
		--report-zero-counts \
        --use-names \
        --paired \
        --gzip-compressed ${DATA_DIR}/${SAMPLEARG}*_kneaddata_paired_1.fastq.gz  ${DATA_DIR}/${SAMPLEARG}*_kneaddata_paired_2.fastq.gz