# MGS_pipeline

Pipeline for metagenomics sequencing processing: This pipeline includes pre-processing steps using KneadData and two options for running taxonomic classification for shotgun metagenomics sequencing including MetaPhlan4 and Kraken2. The steps of the pipeline are described below, with detailed documentation available [here](Metagenomic_pipeline_description.pdf).

![Pipeline Overview](https://github.com/Integrative-Longevity-Omics/MGS_pipeline/blob/main/workflow/pipeline_overview.SVG)

- KneadData (01_kneaddata: 01_build_kneaddata_db.sh -> 01_run_kneaddata.sh)
  - Trim adapters
  - Trim repetitive sequences
  - Remove host (human) DNA
 
- Kraken2 (02_kraken2)
  - Build custom database of k-mer minimizer sequences (01_kraken2_build_db.sh)
  - Taxonomic classification for each sample (02_kraken2_classification.sh)
  - Generate table of k-mer minimizer counts (03_kmer_minimizer_table.R)
  
- Bracken (03_bracken)
  - Build k-mer distribution file (03_bracken_build_db.sh)
  - Taxonomic relative abundance estimation for each sample (03_bracken_abundance_estimation.sh)
  - Generate table of merged Bracken report outputs (03_bracken_combined_report.sh)
  
  
![Kraken2 Workflow](https://github.com/Integrative-Longevity-Omics/MGS_pipeline/blob/main/workflow/Kraken2_workflow.SVG)

  
- MetaPhlan4 (04_metaphlan)
  - Build MetaPhlAn4 database (01_build_mp4.2_db.sh)
  - Taxonomic classification for each sample (02_run_mp4.2.sh)
  - Generate combined species-level abundance table (03_clean_merge_metaphlan.py)


![MetaPhlan4 Workflow](https://github.com/Integrative-Longevity-Omics/MGS_pipeline/blob/main/workflow/MetaPhlan4_workflow.SVG)



