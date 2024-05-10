#!/bin/bash -l

#Author: Tanya Karagiannis
#Purpose: Run script to filter Bracken report for each sample

#$ -cwd
#$ -pe omp 2
#$ -P uh2-sebas
#$ -l h_rt=120:00:00
#$ -N combine_bracken
#$ -j y
#$ -M tkaragiannis@tuftsmedicalcenter.org
#$ -o /restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/scripts/logs

#########################################################################################

# Combined filtered Bracken reports from ILO cohort #

#########################################################################################

#load conda environment to run kraken2
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics
OMP_NUM_THREADS=2

#directories
TOOL=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Bracken/analysis_scripts/
DATA_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/Bracken_Filtered_04.24.2024
FILE=$(ls ${DATA_DIR}/*.bracken.species.filtered.txt | cat)

#combine bracken output reports into a combined report
python ${TOOL}/combine_bracken_outputs.py --files ${FILE} --output ${DATA_DIR}/merged.bracken.species.filtered_04.24.2024.txt
