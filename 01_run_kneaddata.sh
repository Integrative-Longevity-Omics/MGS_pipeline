#!/bin/bash -l

#$ -pe omp 16
#$ -P cometsfba
#$ -l h_rt=08:00:00
#$ -N kneaddata_b2
#$ -j y
#$ -o /restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/qsub_logs/
#$ -t 1-184
#total 184 sample, 36 pilot

###################################################################
#Run KneadData on 220 ILO samples, paired-end reads run separately#
###################################################################

export PATH="/usr3/graduate/sibald/.local/bin/:$PATH"

# load the required modules
module load biobakery_workflows/3.0.0-alpha.7
module load trimmomatic
module load trf
module load humann/3.0
module load python3/3.7.9
module load bowtie2/2.4.2
module load metaphlan/3.0

FINAL_OUTPUT_DIR=/restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/kneaddata_out/
mkdir $FINAL_OUTPUT_DIR

#directory for pilot samples
#DATA_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/Metagenomics_Nov_2021/Raw_Sequencing_Data_and_QC_Reports

#directory for second batch of samples
DATA_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/Metagenomics_Feb_2023/Raw_Sequencing_Data_and_QC_Reports/230124-0036A-7404

DB_DIR=/restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/chm13v2_reference_db

#create scratch directory to run on, faster with lots of i/o
INT_OUTPUT_DIR=$TMPDIR/${SGE_TASK_ID}_kneaddata_out
mkdir $INT_OUTPUT_DIR

#run paired-end samples separately
kneaddata --unpaired $DATA_DIR/*S${SGE_TASK_ID}_R1*.fastq.gz --reference-db $DB_DIR --output $INT_OUTPUT_DIR --threads $NSLOTS
kneaddata --unpaired $DATA_DIR/*S${SGE_TASK_ID}_R2*.fastq.gz --reference-db $DB_DIR --output $INT_OUTPUT_DIR --threads $NSLOTS

gzip $INT_OUTPUT_DIR/*R1*kneaddata.fastq
gzip $INT_OUTPUT_DIR/*R2*kneaddata.fastq

#save output cleaned fastq.gz files and log file, rest of intermediate files not necessary
cp $INT_OUTPUT_DIR/*R1*kneaddata.fastq.gz $FINAL_OUTPUT_DIR
cp $INT_OUTPUT_DIR/*R2*kneaddata.fastq.gz $FINAL_OUTPUT_DIR
cp $INT_OUTPUT_DIR/*.log $FINAL_OUTPUT_DIR 


