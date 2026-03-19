#Purpose: upload kraken2uniq data and save minimizer information in tables

#library(pavian)
library(tidyverse)
library(purrr)
#pavian::runApp(port=5000)

#directory
phase1.dir <- "/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_nov2021/Reports/"
phase2.dir <- "/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_feb2023/Reports/"
phase3.dir <- "/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/kraken2uniq_kneaddata_june2024/Reports/"
out.dir <- "/restricted/projectnb/uh2-sebas/data/metagenomics/ILO_combined_cohort/kraken2_data/merged_output/"

#list of reports
phase1.kraken <- list.files(phase1.dir, pattern="aggregated.report.txt")
phase2.kraken <- list.files(phase2.dir, pattern="aggregated.report.txt")
phase3.kraken <- list.files(phase3.dir, pattern="aggregated.report.txt")

#read in each sample report and save kmer information
phase1.kraken.df <- lapply(1:length(phase1.kraken), function(x){
  #read_report(paste0(phase1.dir, phase1.kraken[x]), has_header = NULL, check_file = FALSE)
  report.res <- read_delim(paste0(phase1.dir, phase1.kraken[x]), 
                           delim = "\t", escape_double = FALSE, 
                           col_names = FALSE, trim_ws = TRUE)
  colnames(report.res) <- c("percentage", "cladeReads", "taxonReads", "n_minimizers", "n_unique_minimizers", "taxLineage", "taxID", "scientific_name")
  return(report.res)
})
names(phase1.kraken.df) <- phase1.kraken


phase2.kraken.df <- lapply(1:length(phase2.kraken), function(x){
  #read_report(paste0(phase2.dir, phase2.kraken[x]), has_header = NULL, check_file = FALSE)
  report.res <- read_delim(paste0(phase2.dir, phase2.kraken[x]),
                           delim = "\t", escape_double = FALSE,
                           col_names = FALSE, trim_ws = TRUE)
  colnames(report.res) <- c("percentage", "cladeReads", "taxonReads", "n_minimizers", "n_unique_minimizers", "taxLineage", "taxID", "scientific_name")
  return(report.res)
})
names(phase2.kraken.df) <- phase2.kraken


phase3.kraken.df <- lapply(1:length(phase3.kraken), function(x){
  #read_report(paste0(phase3.dir, phase3.kraken[x]), has_header = NULL, check_file = FALSE)
  report.res <- read_delim(paste0(phase3.dir, phase3.kraken[x]),
                           delim = "\t", escape_double = FALSE,
                           col_names = FALSE, trim_ws = TRUE)
  colnames(report.res) <- c("percentage", "cladeReads", "taxonReads", "n_minimizers", "n_unique_minimizers", "taxLineage", "taxID", "scientific_name")
  return(report.res)
})
names(phase3.kraken.df) <- phase3.kraken


#combine all reports in one list
combined.kraken.df <- c(phase1.kraken.df, phase2.kraken.df, phase3.kraken.df)
names(combined.kraken.df) <- c(phase1.kraken, phase2.kraken, phase3.kraken)

#table of n_minimizers

combined.n_minimizers.list <- combined.kraken.df %>% 
  purrr::map(function(x) select(x, taxID, n_minimizers))

combined.n_minimizers.list <- lapply(1:length(combined.kraken.df), function(x){
  res <- combined.kraken.df[[x]]
  sample.name <- names(combined.kraken.df)[x]
  res_set <- res %>% dplyr::select(taxID, n_minimizers)
  colnames(res_set) <- c("taxID", sample.name)
  return(res_set)
})

combined.n_minimizers <- combined.n_minimizers.list %>% purrr::reduce(inner_join, by = "taxID")

#save file
write.csv(combined.n_minimizers, file = paste0(out.dir, "kraken2uniq.n_minimizers.09.09.2025.csv"))

#table of n_unique_minimizers
combined.n_unique_minimizers.list <- combined.kraken.df %>% 
  purrr::map(function(x) select(x, taxID, n_unique_minimizers))

combined.n_unique_minimizers.list <- lapply(1:length(combined.kraken.df), function(x){
  res <- combined.kraken.df[[x]]
  sample.name <- names(combined.kraken.df)[x]
  res_set <- res %>% dplyr::select(taxID, n_unique_minimizers)
  colnames(res_set) <- c("taxID", sample.name)
  return(res_set)
})

combined.n_unique_minimizers <- combined.n_unique_minimizers.list %>% purrr::reduce(inner_join, by = "taxID")

#save file
write.csv(combined.n_unique_minimizers, file = paste0(out.dir, "kraken2uniq.n_unique_minimizers.09.09.2025.csv"))


