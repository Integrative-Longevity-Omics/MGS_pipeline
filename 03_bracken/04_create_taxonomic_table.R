library(taxonomizr)

# Build SQLite database from your Kraken2 taxonomy files
# copied .dmp files and accession files to different directory for this step
KrakenDB <- "/restricted/projectnb/ilometagenomics/data/Kraken2-DB/Kraken2-DB-06252025/dmp_files/"
taxdb <- "/restricted/projectnb/ilometagenomics/data/Kraken2-DB/Kraken2-DB-06252025/"

#import taxonomic ids
taxids <- "/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/merged_output/taxids.txt" 
taxids <- read_csv(paste0(taxids), col_names = FALSE)
taxids <- taxids$X1

#build taxonomizr database
# prepareDatabase(
#   sqlFile = paste0(taxdb, "kraken_db.sqlite"),    # this is the database that will be created
#   tmpDir = KrakenDB,              # your directory with existing .dmp files
#   getAccessions = FALSE #don't download accession2taxid mapping
# )


# Then get the taxonomy
taxa_table <- getTaxonomy(
  ids = taxids,
  sqlFile =  paste0(taxdb, "kraken_db.sqlite"),
)

colnames(taxa_table) <- c("kingdom","phylum", "class", "order", "family", "genus", "species")

#convert taxonomic table to tibble with taxonomic IDs as a column
taxa_tbl <- as_tibble(taxa_table, rownames="taxID")

#get rid of spaces in string quotes
updated_string <- trimws(taxa_tbl$taxID)
taxa_tbl$taxID <- updated_string

#add taxonomic rank prefix before each taxa name
# Add k__ prefix to kingdom names
taxa_tbl$kingdom <- paste0("k__", taxa_tbl$kingdom)
#taxa_tbl$kingdom[is.na(taxa_tbl$kingdom)] <- "k__"

# Add p__ prefix to phylum names
taxa_tbl$phylum <- paste0("p__", taxa_tbl$phylum)
#taxa_tbl$phylum[is.na(taxa_tbl$phylum)] <- "p__"

# Add c__ prefix to class names
taxa_tbl$class <- paste0("c__", taxa_tbl$class)
#taxa_tbl$class[is.na(taxa_tbl$class)] <- "c__"

# Add o__ prefix to order names
taxa_tbl$order <- paste0("o__", taxa_tbl$order)
#taxa_tbl$order[is.na(taxa_tbl$order)] <- "o__"

# Add f__ prefix to family names
taxa_tbl$family <- paste0("f__", taxa_tbl$family)
#taxa_tbl$family[is.na(taxa_tbl$family)] <- "f__"

# Add g__ prefix to genus names
taxa_tbl$genus <- paste0("g__", taxa_tbl$genus)
#taxa_tbl$genus[is.na(taxa_tbl$genus)] <- "g__"

# Add s__ prefix to species names
taxa_tbl$species <- paste0("s__", taxa_tbl$species)
#taxa_tbl$species[is.na(taxa_tbl$species)] <- "s__"

#save taxa table
write_delim(taxa_tbl, file="/restricted/projectnb/ilometagenomics/data/ILO_combined_cohort/bracken_data/merged_output/taxa_table_10.08.2025.txt", delim="\t")
