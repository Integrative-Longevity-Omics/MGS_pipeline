#!/bin/bash

#input to script is directory with all single-sample metaphlan output files and nothing else, and output directory where final cleaned merged files for each level of taxonomy will be stored

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <data_directory> <output_directory>"
    exit 1
fi

# Assign command line arguments to variables
data_directory=$1
output_directory=$2

# Check if data directory exists
if [ ! -d "$data_directory" ]; then
    echo "Error: Data directory '$data_directory' not found."
    exit 1
fi

# Check if output directory exists, if not create it
if [ ! -d "$output_directory" ]; then
    mkdir -p "$output_directory"
fi

# List all files in the data directory
file_list=$(ls "$data_directory")


echo "Merging Metaphlan Tables, keeping NCBI names."
python merge_metaphlan_tables_ncbi-included.py $data_directory/*.tsv > "$output_directory/raw_merged_metaphlan4_ncbi.tsv"
echo "Tables Merged!"

echo "Clean sample names to be just stoolkits"
python clean_names_ilo.py "$output_directory/raw_merged_metaphlan4_ncbi.tsv" "$output_directory/merged_metaphlan4_ncbi.tsv"
echo "Done renaming merged output"

echo "Filtering and Subsetting Table by Taxonomic Level"
python metaphlan4_clean_split_table.py "$output_directory/merged_metaphlan4_ncbi.tsv" "$output_directory"
echo "Processing complete."
