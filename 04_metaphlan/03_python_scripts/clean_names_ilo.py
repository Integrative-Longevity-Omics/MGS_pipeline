import pandas as pd
import os
import sys


#input arguments are path to input and directory for outputs
raw_merged_df = sys.argv[1]
output_df = sys.argv[2]

df = pd.read_table(raw_merged_df, skiprows=1, index_col=0)
cols = [col.removesuffix('_metaphlan4.2_bugs_list') for col in df.columns]
df.columns = cols
df.to_csv(output_df, sep='\t')