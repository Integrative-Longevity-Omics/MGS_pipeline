#!/bin/bash -l

#$ -cwd
#$ -j y
#$ -P uh2-sebas 
#$ -pe omp 1 
#$ -o krakenuniq-biom.log 
#$ -N krakenuniq-biom

##############################################
#      kraken2uniq BIOM table       		 #
##############################################

#load kraken2 from conda environment
module load gcc
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics

#directories
DIR="/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Kraken_Analysis/kraken_analysis_feb2023"
INPUT="/restricted/projectnb/uh2-sebas/analysis/metagenomics/meg_analyses/kraken2uniq_kneaddata_feb2023/Reports" 
OUTPUT="/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Kraken_Analysis/kraken_analysis_feb2023/kraken2uniq_kneaddata_reports"
BIOM="/restricted/projectnb/uh2-sebas/analysis/metagenomics/data_library"

#Loop through sample names (from samplesheet)
FILENAME="${DIR}/filename_feb.txt"
SAMPLES=$(cat $FILENAME)

#Create kraken2 standard report with reads counts
for SAMPLE in $SAMPLES; do
	SUBSTRING=$(echo "${SAMPLE%%_R1_001.fastq.gz}")
	cut -f1-3,6-8 ${INPUT}/${SUBSTRING}.aggregated.report.txt > ${OUTPUT}/${SUBSTRING}.std.report.txt
done

#run kraken-biom function to generate biom object from kraken report output files
kraken-biom ${OUTPUT}/*.std.report.txt --fmt json -o ${BIOM}/kraken2uniq_kneaddata_integrated.11.03.2023.biom

#In R, import biom table  to generate OTU table and taxonomic table using phyloseq R package
#library(phyloseq)
#phyoseq::import_biom("kraken2uniq_kneaddata_integrated.11.03.2023.biom")
