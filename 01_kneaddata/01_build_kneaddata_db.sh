#!/bin/bash -l

#$ -pe omp 16
#$ -P ilometagenomics
#$ -l h_rt=08:00:00
#$ -N kneaddata_db
#$ -j y
#$ -o /restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kneaddata_fastq/qsub_logs/

###########################################################################
#Build KneadData Database with CHM13v2.0 Human Genomes for Decontamination#
###########################################################################

# load the required modules and/or conda environment
module load awscli
module load bowtie2

#output directory
KNEADDATA_PATH=/restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq

#download chm13v2.0.fa file
#aws s3 --no-sign-request cp s3://human-pangenomics/T2T/CHM13/assemblies/analysis_set/chm13v2.0.fa.gz $KNEADDATA_PATH
#gunzip ${KNEADDATA_PATH}/chm13v2.0.fa.gz

#Build KneadData Reference Database
bowtie2-build ${KNEADDATA_PATH}/chm13v2.0.fa chm13v2_reference_db
