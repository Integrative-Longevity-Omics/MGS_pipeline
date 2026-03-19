import pandas as pd
import numpy as np
import sys
import os

#input arguments are path to input and directory for outputs
raw_df = sys.argv[1]
output_dir = sys.argv[2]

#import metaphlan4 full dataframe
#bugs_df = pd.read_csv(raw_df, skiprows=1, sep='\t')
bugs_df = pd.read_csv(raw_df, sep='\t')

#clean and save one dataset with all the taxa up to the metaphlan4 t__label -- defined for a certain species genome bin 
sgb_df = bugs_df[bugs_df['clade_name'].str.contains('t__')]
sgb_df = sgb_df.set_index('clade_name', drop=True)
sgb_df = sgb_df.drop(['NCBI_tax_id'], axis=1)
sgb_df = sgb_df / sgb_df.sum()
sgb_df.to_csv(os.path.join(output_dir, 'metaphlan4_sgb.tsv'), sep='\t')

'''
sgb_df = sgb_df.mul(1000000)
sgb_df = sgb_df.add(1)
sgb_df = np.log10(sgb_df)
#sgb_df.to_csv('log_metaphlan4_sgb.tsv',sep='\t')
'''

#clean and save one dataset with all the taxa fully characterized by NCBI, at least down to the s__ metaphlan4 level
sp_df = bugs_df[bugs_df['clade_name'].str.contains('s__')]
sp_df = sp_df[~sp_df['clade_name'].str.contains('t__')]
full_sp_df = sp_df[~sp_df['NCBI_tax_id'].str.endswith('|')]
full_sp_df = full_sp_df[~full_sp_df['NCBI_tax_id'].str.contains('||', regex=False)]
full_sp_df = full_sp_df.set_index('clade_name', drop=True)

#sum taxa with duplicate NCBI id's  ##SKIP THIS SECTION
'''
duplicate_ids = list(set(full_sp_df['NCBI_tax_id'][full_sp_df['NCBI_tax_id'].duplicated()].tolist()))
for ncbi_id in duplicate_ids:
    subset = full_sp_df.loc[full_sp_df.NCBI_tax_id == ncbi_id]
    clade_name = subset.index[0]
    sum_abun = subset.sum(axis=0)
    sum_abun[0] = ncbi_id
    full_sp_df = full_sp_df[~(full_sp_df.NCBI_tax_id == ncbi_id)]
    full_sp_df.loc[clade_name,:] = sum_abun
'''

taxa_list = full_sp_df['NCBI_tax_id']
full_sp_df = full_sp_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = full_sp_df.sum(axis=0)
nonlog_sp_df = pd.DataFrame(index=full_sp_df.index.to_list())

#missingness = (full_sp_df == 0).astype(int).sum(axis=1)/220
#missingness_cutoff_df = full_sp_df[missingness <= 0.20]

#renormalize to get relative abundances to sum to 1
for i, samp in enumerate(full_sp_df.columns.to_list()):
    col = (full_sp_df.iloc[:,i]/prop_sample_characterized[i])
    full_sp_df.loc[:,samp] = col
full_sp_df['NCBI_tax_id'] = taxa_list
full_sp_df.to_csv(os.path.join(output_dir,'metaphlan4_ncbi_species.tsv'), sep='\t')


#get dataframe for the genus, family, order, class, phylum and kingdom level
genera_df = bugs_df[bugs_df['clade_name'].str.contains('g__')]
genera_df = genera_df[~genera_df['clade_name'].str.contains('s__')]
genera_df = genera_df[~genera_df['NCBI_tax_id'].str.endswith('|')]
genera_df = genera_df[~genera_df['NCBI_tax_id'].str.contains('||', regex=False)]
genera_df = genera_df.set_index('clade_name')
taxa_list = genera_df['NCBI_tax_id']
genera_df = genera_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = genera_df.sum(axis=0)
for i, samp in enumerate(genera_df.columns.to_list()):
    col = (genera_df.iloc[:,i]/prop_sample_characterized[i])
    genera_df.loc[:,samp] = col
genera_df['NCBI_tax_id'] = taxa_list
genera_df.to_csv(os.path.join(output_dir, 'metaphlan4_ncbi_genus.tsv'), sep='\t')

family_df = bugs_df[bugs_df['clade_name'].str.contains('f__')]
family_df = family_df[~family_df['clade_name'].str.contains('g__')]
family_df = family_df[~family_df['NCBI_tax_id'].str.endswith('|')]
family_df = family_df[~family_df['NCBI_tax_id'].str.contains('||', regex=False)]
family_df = family_df.set_index('clade_name', drop=True)
taxa_list = family_df['NCBI_tax_id']
family_df = family_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = family_df.sum(axis=0)
for i, samp in enumerate(family_df.columns.to_list()):
    col = (family_df.iloc[:,i]/prop_sample_characterized[i])
    family_df.loc[:,samp] = col
family_df['NCBI_tax_id'] = taxa_list
family_df.to_csv(os.path.join(output_dir,'metaphlan4_ncbi_family.tsv'), sep='\t')

order_df = bugs_df[bugs_df['clade_name'].str.contains('o__')]
order_df = order_df[~order_df['clade_name'].str.contains('f__')]
order_df = order_df[~order_df['NCBI_tax_id'].str.endswith('|')]
order_df = order_df[~order_df['NCBI_tax_id'].str.contains('||', regex=False)]
order_df = order_df.set_index('clade_name', drop=True)
taxa_list = order_df['NCBI_tax_id']
order_df = order_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = order_df.sum(axis=0)
for i, samp in enumerate(order_df.columns.to_list()):
    col = (order_df.iloc[:,i]/prop_sample_characterized[i])
    order_df.loc[:,samp] = col
order_df['NCBI_tax_id'] = taxa_list
order_df.to_csv(os.path.join(output_dir,'metaphlan4_ncbi_order.tsv'), sep='\t')

class_df = bugs_df[bugs_df['clade_name'].str.contains('c__')]
class_df = class_df[~class_df['clade_name'].str.contains('o__')]
class_df = class_df[~class_df['NCBI_tax_id'].str.endswith('|')]
class_df = class_df[~class_df['NCBI_tax_id'].str.contains('||', regex=False)]
class_df = class_df.set_index('clade_name', drop=True)
taxa_list = class_df['NCBI_tax_id']
class_df = class_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = class_df.sum(axis=0)
for i, samp in enumerate(class_df.columns.to_list()):
    col = (class_df.iloc[:,i]/prop_sample_characterized[i])
    class_df.loc[:,samp] = col
class_df['NCBI_tax_id'] = taxa_list
class_df.to_csv(os.path.join(output_dir,'metaphlan4_ncbi_class.tsv'), sep='\t')

phylum_df = bugs_df[bugs_df['clade_name'].str.contains('p__')]
phylum_df = phylum_df[~phylum_df['clade_name'].str.contains('c__')]
phylum_df = phylum_df[~phylum_df['NCBI_tax_id'].str.endswith('|')]
phylum_df = phylum_df[~phylum_df['NCBI_tax_id'].str.contains('||', regex=False)]
phylum_df = phylum_df.set_index('clade_name', drop=True)
taxa_list = phylum_df['NCBI_tax_id']
phylum_df = phylum_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = phylum_df.sum(axis=0)
for i, samp in enumerate(phylum_df.columns.to_list()):
    col = (phylum_df.iloc[:,i]/prop_sample_characterized[i])
    phylum_df.loc[:,samp] = col
phylum_df['NCBI_tax_id'] = taxa_list
phylum_df.to_csv(os.path.join(output_dir,'metaphlan4_ncbi_phylum.tsv'), sep='\t')

kingdom_df = bugs_df[bugs_df['clade_name'].str.contains('k__')]
kingdom_df = kingdom_df[~kingdom_df['clade_name'].str.contains('p__')]
kingdom_df = kingdom_df[~kingdom_df['NCBI_tax_id'].str.endswith('|')]
kingdom_df = kingdom_df[~kingdom_df['NCBI_tax_id'].str.contains('||', regex=False)]
kingdom_df = kingdom_df.set_index('clade_name', drop=True)
taxa_list = kingdom_df['NCBI_tax_id']
kingdom_df = kingdom_df.drop(['NCBI_tax_id'], axis=1)
prop_sample_characterized = kingdom_df.sum(axis=0)
for i, samp in enumerate(kingdom_df.columns.to_list()):
    col = (kingdom_df.iloc[:,i]/prop_sample_characterized[i])
    kingdom_df.loc[:,samp] = col
kingdom_df['NCBI_tax_id'] = taxa_list
kingdom_df.to_csv(os.path.join(output_dir,'metaphlan4_ncbi_kingdom.tsv'), sep='\t')






