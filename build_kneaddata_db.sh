#!/bin/bash -l

#$ -pe omp 16
#$ -P cometsfba
#$ -l h_rt=08:00:00
#$ -N kneaddata_db
#$ -j y
#$ -o /restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/qsub_logs/

###########################################################################
#Build KneadData Database with CHM13v2.0 Human Genomes for Decontamination#
###########################################################################

# load the required modules
module load biobakery_workflows/3.0.0-alpha.7
module load trimmomatic
module load trf
module load humann/3.0
module load python3/3.7.9
module load bowtie2/2.4.2
module load metaphlan/3.0

bowtie2-build /restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/chm13v2.0.fa chm13v2_reference_db
