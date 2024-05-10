#!/bin/bash -l

#Author: Tanya Karagiannis
#Purpose: Run script to filter Bracken report for each sample

#$ -cwd
#$ -pe omp 8
#$ -P uh2-sebas
#$ -l h_rt=120:00:00
#$ -j y
#$ -M tkaragiannis@tuftsmedicalcenter.org

#########################################################################################

#Filter Bracken reports from ILO cohort #

#########################################################################################

#load conda environment to run kraken2
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics

#put filter_bracken_report.py in path
OMP_NUM_THREADS=8

#directories
TOOL=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics/bin
INPUT=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/Bracken_04.23.2024
#OUTPUT=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/Bracken_Filtered_03.19.2024
#OUTPUT=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/Bracken_Filtered_04.02.2024
OUTPUT=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/Bracken_Filtered_04.24.2024
QC_DIR=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Quality_Control/ILO_cohort
#TAXID=$(cat ${QC_DIR}/taxa_to_keep.txt)
TAXID=$(cat ${QC_DIR}/taxa_to_keep.04.02.2024.txt) #based on updated phyloseq object and QC

#create directory
mkdir $OUTPUT

#filter bracken reports
#include taxa that passed QC
#to remove homo sapiens
python ${TOOL}/filter_bracken.out.py -i ${INPUT}/${SAMPLEARG}.bracken.species.txt \
	-o ${OUTPUT}/${SAMPLEARG}.bracken.species.filtered.txt \
	--include ${TAXID} \
	--exclude 9606
