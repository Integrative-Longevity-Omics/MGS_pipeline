#!/bin/bash -l

#Purpose: Run script to combine Bracken estimated abundances across samples

#$ -cwd
#$ -pe omp 2
#$ -P uh2-sebas
#$ -l h_rt=120:00:00
#$ -N combine_bracken
#$ -j y
#$ -o /restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/scripts

################################################

# Combine Bracken output files from ILO cohort #

################################################

#load required modules and conda environment
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers
OMP_NUM_THREADS=2

#directories
#directory with krakentools python script to run step
TOOL=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers/bin
#bracken data directory for each experimental phase
PHASE1=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/Bracken_R1/Bracken_R1_nov2021
PHASE2=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/Bracken_R1/Bracken_R1_feb2023
PHASE3=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/Bracken_R1/Bracken_R1_june2024
OUTPUT=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/merged_output
#list of Bracken output files for each experimental
FILE1=$(ls ${PHASE1}/*.bracken.species.txt | cat)
FILE2=$(ls ${PHASE2}/*.bracken.species.txt | cat)
FILE3=$(ls ${PHASE3}/*.bracken.species.txt | cat)

#combine bracken output files into a combined output file
#creates a table of species-level estimated abundances across all samples
python ${TOOL}/combine_bracken_outputs.py --files ${FILE1} ${FILE2} ${FILE3} --output ${OUTPUT}/merged.bracken.species_R1_10.07.2025.txt

#Extract taxonomic IDs from combined output file and save
cut -f2 ${OUTPUT}/merged.bracken.species_R1_10.07.2025.txt | tail -n +2 > ${OUTPUT}/taxids.txt