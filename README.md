# MGS_pipeline

Pipeline for metagenomics sequencing processing: This pipeline includes pre-processing steps using KneadData and two options for running taxonomic classification for shotgun metagenomics sequencing including MetaPhlan4 and Kraken2. The steps of the pipeline are described below, with detailed documentation available [here](Metagenomic_pipeline_description.pdf).

![Pipeline Overview](https://github.com/Integrative-Longevity-Omics/MGS_pipeline/blob/main/workflow/pipeline_overview.SVG)

- KneadData (01_build_kneaddata_db.sh -> 01_run_kneaddata.sh)
  - Trim adapters
  - Trim repetitive sequences
  - Remove host (human) DNA
 
- Kraken2
  - Build custom database of k-mer minimizer sequences (02_kraken2-build.sh)
  - Taxonomic classification for each sample (02_kraken2-classification.sh)
  - Generate BIOM table of merged Kraken2 report outputs (02_kraken2-generate-biom.sh)
  - Generate table of k-mer minimizer counts (02_kraken2-generate-table.R)
  
![Kraken2 Workflow](https://github.com/Integrative-Longevity-Omics/MGS_pipeline/blob/main/workflow/Kraken2_workflow.SVG)


- MetaPhlan4 
  - Taxonomic classification for each sample (03_run_mp4.sh)


![MetaPhlan4 Workflow](https://github.com/Integrative-Longevity-Omics/MGS_pipeline/blob/main/workflow/MetaPhlan4_workflow.SVG)



