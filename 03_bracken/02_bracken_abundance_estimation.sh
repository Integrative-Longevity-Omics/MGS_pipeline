#!/bin/bash -l

#Purpose: Run Bracken abundance estimation on each sample

#$ -cwd
#$ -pe omp 2
#$ -P llfs
#$ -l h_rt=120:00:00
#$ -N bracken_R1_b3
#$ -j y
#$ -o /restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/scripts/logs
#$ -t 1-218
#total 218 samples

##############################################################
#Run Bracken on 218 ILO samples from experimental phase 3  #
##############################################################

#load required modules and conda environment
#Bracken v.3.0.1
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers

#environment variable to set number of cores
OMP_NUM_THREADS=2

#directories
TOOL=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers/bin
INPUT=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_june2024/Reports
OUTPUT=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/Bracken_R1/Bracken_R1_june2024

#enter kraken2 data directory
cd $INPUT

#list of filenames from all samples
filename=$(ls *.aggregated.report.txt)
#echo "$filename"

#select sample file based on the task ID
input_file=$(echo "$filename" | sed -n "${SGE_TASK_ID}p" )
#echo "$input_file"

#extract sample label from filename
#may need to edit this based on filename structure
SAMPLEARG=$(echo "$input_file" | cut -d'.' -f1)
echo "$SAMPLEARG"

#Kraken2 database
DBNAME=/restricted/projectnb/ilometagenomics/data/Kraken2-DB/Kraken2-DB-06252025/kraken2-06252025

#bracken argument inputs
READ_LEN=150
CLASSIFICATION_LVL='S'
THRESHOLD=10

#create output directory
mkdir $OUTPUT

#Run Bracken to re-estimate abundances for that sample at the species level
python ${TOOL}/est_abundance.py -i ${INPUT}/${SAMPLEARG}.aggregated.report.txt \
  -k ${DBNAME}/database${READ_LEN}mers.kmer_distrib \
  -l ${CLASSIFICATION_LVL} \
  -t ${THRESHOLD} \
  -o ${OUTPUT}/${SAMPLEARG}.bracken.species.txt \
  --out-report ${OUTPUT}/${SAMPLEARG}.bracken.report