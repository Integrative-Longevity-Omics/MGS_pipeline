#!/bin/bash -l

#$ -pe omp 16
#$ -l mem_per_core=12G
#$ -P ilometagenomics
#$ -l h_rt=04:00:00
#$ -N mph4.2
#$ -j y
#$ -o /restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/metaphlan4.2/qsub_logs/
#$ -t 1-218
#total of 218 samples

#########################################################
#Run MetaPhlAn on ILO samples from experimental phase 3 #
#########################################################

#load MetaPhlAn4 conda environment
#MetaPhlAn4.2.2
module load miniconda
conda activate mph4.2

#extract sample name
SAMPLE=$(sed -n "${SGE_TASK_ID}p" /restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/metaphlan4.2/phase3_kneaddata_fastq_files.txt)

#file/directory locations
DATA_DIR=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/kneaddata_fastq/kneaddata_out_feb2023_07142025
DB_DIR=/restricted/projectnb/ilometagenomics/data/Metaphlan4.2-DB
OUTPUT_FILE=/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/metaphlan4.2/metaphlan4.2_out/${SAMPLE}_metaphlan4.2_bugs_list.tsv

#print file names
ls $DATA_DIR/${SAMPLE}_kneaddata_paired*.fastq.gz

#run MetaPhlAn4 on paired fastq files
metaphlan $DATA_DIR/${SAMPLE}_kneaddata_paired_1.fastq.gz,$DATA_DIR/${SAMPLE}_kneaddata_paired_2.fastq.gz --nproc 16 --db_dir $DB_DIR --input_type fastq -o $OUTPUT_FILE --mapout $TMPDIR/${SAMPLE}.bowtie2.bz2
