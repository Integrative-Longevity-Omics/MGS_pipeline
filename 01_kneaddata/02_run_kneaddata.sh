#!/bin/bash -l

#Purpose: Run KneadData processing and QC on each sample

#$ -pe omp 28
#$ -P ilometagenomics
#$ -l h_rt=120:00:00
#$ -N kneaddata_batch
#$ -j y
#$ -o /restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kneaddata_fastq/qsub_logs/
#$ -t 1-218 
#number of tasks should match number of samples
#total 218 samples

##############################################################
#Run KneadData on 218 ILO samples from experimental phase 3  #
##############################################################

# load the required modules
module load miniconda

#activate conda environment to run KneadData v0.12.3
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/mgx_classifiers

#output directory
FINAL_OUTPUT_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kneaddata_fastq/kneaddata_out_june2024_07142025/
mkdir $FINAL_OUTPUT_DIR

#data directory for third experimental phase batch of samples
DATA_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_batches/Metagenomic_June_2024/Raw_Sequencing_Data_and_QC_Reports/250220

DB_DIR=/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kneaddata_fastq/chm13v2_reference_db

#enter data directory
cd $DATA_DIR

#list of filenames from all samples
filename=$(ls *_R1*.fastq.gz)
echo "$filename"

#select sample file based on the task ID
input_file=$(echo "$filename" | sed -n "${SGE_TASK_ID}p" )
echo "$input_file"

#extract sample label from filename
#may need to edit this based on filename structure
SAMPLE=$(echo "$input_file" | cut -d'_' -f1)
echo "$SAMPLE"

#create scratch directory to run on, faster with lots of i/o
INT_OUTPUT_DIR=$TMPDIR/${SAMPLE}_kneaddata_out
mkdir $INT_OUTPUT_DIR

#run kneaddata with paired-end samples processed together
kneaddata --input1 $DATA_DIR/${SAMPLE}_*R1*.fastq.gz --input2 $DATA_DIR/${SAMPLE}_*R2*.fastq.gz \
        --reference-db $DB_DIR \
        --output $INT_OUTPUT_DIR \
        --threads $NSLOTS \
        --reorder \
        --output-prefix ${SAMPLE}_kneaddata

#summary table of reads retained at each step
kneaddata_read_count_table --input $INT_OUTPUT_DIR --output $FINAL_OUTPUT_DIR/${SAMPLE}_kneaddata_read_counts.txt

#zip files
gzip $INT_OUTPUT_DIR/*_kneaddata_paired_1.fastq
gzip $INT_OUTPUT_DIR/*_kneaddata_paired_2.fastq
gzip $INT_OUTPUT_DIR/*_kneaddata_unmatched_1.fastq
gzip $INT_OUTPUT_DIR/*_kneaddata_unmatched_2.fastq

#copy output cleaned fastq.gz files and log file to output directory
#intermediate files not necessary
cp $INT_OUTPUT_DIR/*_kneaddata_paired_1.fastq.gz $FINAL_OUTPUT_DIR
cp $INT_OUTPUT_DIR/*_kneaddata_paired_2.fastq.gz $FINAL_OUTPUT_DIR
cp $INT_OUTPUT_DIR/*_kneaddata_unmatched_1.fastq.gz $FINAL_OUTPUT_DIR
cp $INT_OUTPUT_DIR/*_kneaddata_unmatched_2.fastq.gz $FINAL_OUTPUT_DIR
cp $INT_OUTPUT_DIR/*.log $FINAL_OUTPUT_DIR
