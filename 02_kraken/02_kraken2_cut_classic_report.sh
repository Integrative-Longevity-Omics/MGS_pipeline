#!/bin/bash -l

#Author: Tanya Karagiannis
#Purpose: Run script to run Kraken2 on each sample

#$ -cwd
#$ -j y
#$ -P lcproject
#$ -pe omp 1
#$ -l h_rt=24:00:00
#$ -m ea
#$ -M tkaragiannis@tuftsmedicalcenter.org


#directory
DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_june2024/Reports

#enter directory
cd $DIR

#list of filenames from all samples
filename=$(ls *.aggregated.report.txt)
echo "$filename"

#get sample label from filename
SAMPLES=$(echo "$filename" | cut -d'.' -f1)
echo "$SAMPLES"

#Subset kraken2 report to make standard kraken2 report for each sample
for SAMPLE in $SAMPLES; do
        cut -f1-3,6-8 ${DIR}/${SAMPLE}.aggregated.report.txt > ${DIR}/${SAMPLE}.std.report.txt
done