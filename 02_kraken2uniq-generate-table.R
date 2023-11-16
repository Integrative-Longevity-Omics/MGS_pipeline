#Purpose: Generate table of k-mer minimizer counts with samples 
#as columns and taxa as rows

#libraries
library(tidyverse)
library(purrr)
library(phyloseq)

#directories
nov.dir <- "/restricted/projectnb/uh2-sebas/analysis/metagenomics/meg_analyses/kraken2uniq_kneaddata_nov2021/Reports/"
feb.dir <- "/restricted/projectnb/uh2-sebas/analysis/metagenomics/meg_analyses/kraken2uniq_kneaddata_feb2023/Reports/"
out.dir <- "/restricted/projectnb/uh2-sebas/analysis/metagenomics/data_library/"


###Generate table of k-mer minimizer counts###

#list of reports
nov.kraken <- list.files(nov.dir, pattern="aggregated.report.txt")
feb.kraken <- list.files(feb.dir, pattern="aggregated.report.txt")

#read in each sample report and save kmer information
nov.kraken.df <- lapply(1:length(nov.kraken), function(x){
  #read_report(paste0(nov.dir, nov.kraken[x]), has_header = NULL, check_file = FALSE)
  report.res <- read_delim(paste0(nov.dir, nov.kraken[x]), 
             delim = "\t", escape_double = FALSE, 
             col_names = FALSE, trim_ws = TRUE)
  colnames(report.res) <- c("percentage", "cladeReads", "taxonReads", "n_minimizers", "n_unique_minimizers", "taxLineage", "taxID", "scientific_name")
  return(report.res)
})
names(nov.kraken.df) <- nov.kraken


feb.kraken.df <- lapply(1:length(feb.kraken), function(x){
  #read_report(paste0(feb.dir, feb.kraken[x]), has_header = NULL, check_file = FALSE)
  report.res <- read_delim(paste0(feb.dir, feb.kraken[x]),
             delim = "\t", escape_double = FALSE,
             col_names = FALSE, trim_ws = TRUE)
  colnames(report.res) <- c("percentage", "cladeReads", "taxonReads", "n_minimizers", "n_unique_minimizers", "taxLineage", "taxID", "scientific_name")
  return(report.res)
})
names(feb.kraken.df) <- feb.kraken

#combine all reports in one list
combined.kraken.df <- c(nov.kraken.df, feb.kraken.df)
names(combined.kraken.df) <- c(nov.kraken, feb.kraken)

#table of n_minimizers: total number of k-mer minimizer counts per taxa

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
write.csv(combined.n_minimizers, file = paste0(out.dir, "kraken2uniq.n_minimizers.11.03.2023.csv"))

#table of n_unique_minimizers: number of distinct k-mer minimizer counts per taxa
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
write.csv(combined.n_unique_minimizers, file = paste0(out.dir, "kraken2uniq.n_unique_minimizers.11.03.2023.csv"))



