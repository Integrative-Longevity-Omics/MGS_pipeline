#!/bin/bash -l

#$ -pe omp 16
#$ -P uh2-sebas
#$ -l h_rt=02:00:00
#$ -N mp4
#$ -j y
#$ -t 1-18
#$ -o /restricted/projectnb/uh2-sebas/analysis/metaphlan4/qsub_logs/

#########################################################################################
#Run MetaPhlAn4 on 220 ILO samples with default newest database downloaded Oct, 23, 2023#
#########################################################################################

#submit in three batches with different file structure to preserve samples together
#first t 1-9 with file structure 00$id_
#second t 10-99 with file structure 0$id_
#last t 1-184 with file structure $id_, will fail on some, 37-99

#pilot batch names are 1-36
#second batch names are 001-184, all 3 digits with leading 0's

#load MetaPhlAn4 conda environment
module load miniconda
conda activate mph4

#create directory on scratch, lots of i/o scratch directory is faster
INT_OUTPUT_DIR=$TMPDIR/${SGE_TASK_ID}_metaphlan_out
mkdir $INT_OUTPUT_DIR

#file/directory locations
DATA_DIR=/restricted/projectnb/uh2-sebas/analysis/kneaddata_fastq_10122023/kneaddata_out
DB_DIR=/restricted/projectnb/uh2-sebas/analysis/metaphlan4/metaphlan_db
OUTPUT_FILE=/restricted/projectnb/uh2-sebas/analysis/metaphlan4/metaphlan_out/${SGE_TASK_ID}_metaphlan4_bugs_list.tsv

#print file names
ls $DATA_DIR/${SGE_TASK_ID}_*.fastq.gz

#concatenate paired read files
cat $DATA_DIR/${SGE_TASK_ID}_*R1*.fastq.gz $DATA_DIR/${SGE_TASK_ID}_*R2*.fastq.gz > $INT_OUTPUT_DIR/${SGE_TASK_ID}.fastq.gz

#run MetaPhlAn4 on concatinated fastq file
metaphlan $INT_OUTPUT_DIR/${SGE_TASK_ID}.fastq.gz --nproc 16 --bowtie2db $DB_DIR --input_type fastq -o $OUTPUT_FILE
