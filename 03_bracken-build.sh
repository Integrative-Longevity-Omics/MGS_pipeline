#!/bin/bash -l

#$ -j y
#$ -P uh2-sebas
#$ -pe omp 16
#$ -l mem_per_core=16G
#$ -l h_rt=12:00:00
#$ -m beas
#$ -M Tanya.Karagiannis@tuftsmedicine.org
#$ -N bracken_database

##############################################
#Create Bracken Database file              ###
##############################################

#load kraken2 conda environment
module load miniconda
conda activate /restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/conda_envs/metagenomics

#go into directory
cd /restricted/projectnb/uh2-sebas/data/metagenomics/Kraken2-DB/Kraken2Uniq-DB-09222023/

#put Bracken in path
#adjusted kraken_processing.cpp based on issue: https://github.com/jenniferlu717/Bracken/issues/54
export PATH=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Bracken/src:$PATH
#suggested by github to run with 20 threads
OMP_NUM_THREADS=16

#directories
TOOL=/restricted/projectnb/uh2-sebas/analysis/metagenomics/tanya_analyses/Bracken/src

#Kraken2 database name
DBNAME="kraken2uniq-09222023"

#build bracken database file based on kraken2uniq databases
#bracken-build -d $DBNAME -t 28 -k 35 -l 150

#build step by step
KMER_LEN=35
READ_LEN=150
THREADS=16

#Step 1a: Search all library input sequences against the database
#Run one of the following three commands, depending on your kraken installation/project:
kraken2 --db $DBNAME --threads ${THREADS} <( find -L $DBNAME/library \( -name "*.fna" -o -name "*.fa" -o -name "*.fasta" \) -exec cat {} + ) > $DBNAME/database.kraken
#rm ${DBNAME}/input.fasta

#Step 1b: Compute classifications for each perfect read from one of the input sequences
kmer2read_distr --seqid2taxid ${DBNAME}/seqid2taxid.map \
	--taxonomy ${DBNAME}/taxonomy \
	--kraken ${DBNAME}/database.kraken \
	--output ${DBNAME}/database${READ_LEN}mers.kraken \
	-k ${KMER_LEN} -l ${READ_LEN} -t ${THREADS}

#Step 1c: Generate the kmer distribution file
python $TOOL/generate_kmer_distribution.py -i ${DBNAME}/database${READ_LEN}mers.kraken -o ${DBNAME}/database${READ_LEN}mers.kmer_distrib
