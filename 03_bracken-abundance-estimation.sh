#!/bin/bash -l

#Author: Tanya Karagiannis
#Purpose: Run script to run Bracken on each sample

#$ -cwd
#$ -pe omp 8
#$ -P uh2-sebas
#$ -l h_rt=120:00:00
#$ -j y
#$ -M tkaragiannis@tuftsmedicalcenter.org
#$ -o /restricted/projectnb/uh2-sebas/data/metagenomics/ILO_cohort_combined/scripts/logs

#########################################################################################

#Run Bracken on ILO cohort - without read threshold default #

#########################################################################################

#load conda environment to run kraken2
module load miniconda
conda activate metagenomics

#put Bracken in path
export PATH=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Bracken/src:$PATH
OMP_NUM_THREADS=8

#directories
TOOL=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Bracken/src
#INPUT=/restricted/projectnb/uh2-sebas/analysis/metagenomics/meg_analyses/kraken2uniq_kneaddata_nov2021/Reports
INPUT=/restricted/projectnb/uh2-sebas/analysis/metagenomics/meg_analyses/kraken2uniq_kneaddata_feb2023/Reports
OUTPUT=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/Bracken_04.23.2024

#Kraken2 database
DBNAME=/restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/kraken2uniq-09222023

#bracken input
READ_LEN=150
CLASSIFICATION_LVL='S'
THRESHOLD=0

#create output directory
mkdir $OUTPUT

#Run Bracken to restimate abundances of that sample at the species level
python ${TOOL}/est_abundance.py -i ${INPUT}/${SAMPLEARG}.aggregated.report.txt \
	-k ${DBNAME}/database${READ_LEN}mers.kmer_distrib \
	-l ${CLASSIFICATION_LVL} \
	-t ${THRESHOLD} \
	-o ${OUTPUT}/${SAMPLEARG}.bracken.species.txt
