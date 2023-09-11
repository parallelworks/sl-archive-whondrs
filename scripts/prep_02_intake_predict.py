# Coordinate data intake

import pandas as pd
import numpy as np
import o2sat
import argparse

#print("Parsing input arguments...")
parser = argparse.ArgumentParser()
parsed, unknown = parser.parse_known_args()
for arg in unknown:
    if arg.startswith(("-", "--")):
        parser.add_argument(arg)
        #print(arg)

args = parser.parse_args()
#print(args.__dict__)
target_name = args.target_name

data = pd.read_csv("prep_01_output_train.csv")

# List the variables we want here.
# Order of the list sets left-to-right column order in dataframe/csv output
# Sample_Kit_ID is not unique - shared among sites
# Put oxygen last b/c need to add DOSAT on the left side.
vars_to_use=[
    'Site_ID',
    'Sample_Longitude',
    'Sample_Latitude',
    'Mean_Temp_Deg_C',
    'pH',
    'Mean_DO_mg_per_L'
]

# Grab a view of just the subset we want
#core_vars = data[vars_to_use]
# SKIP FOR NOW
core_vars = data

# PREDICT DATA IS SAME AS TRAINING DATA
# No need for oxygen reconstruction.

# Drop the target
core_vars.pop(target_name)

# Overwrite existing file if it exists
core_vars.to_csv('prep_02_output_predict.csv', mode='w', index=False)
