#==========================================
# Merge the physical properties of a site
# (colocated from RiverAtlas) with the 
# chemical properties of a site (from
# ICON-ModEx_ data and collaborators)
# into single training file and 
# single prediction file.
#==========================================

import pandas as pd
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
target_name=args.target_name

# Load input files
# Phys (colocated) files are space separated
train_chem = pd.read_csv('prep_01_output_train.csv')
train_phys = pd.read_csv(
    'prep_03_output_colocated_train.csv',
    sep = ' ')

predict_chem = pd.read_csv('prep_02_output_predict.csv')
predict_phys = pd.read_csv(
    'prep_04_output_colocated_predict.csv',
    sep = ' ')

train_merged = pd.merge(
    train_chem,
    train_phys, 
    on='Sample_ID', 
    how='outer')

predict_merged = pd.merge(
    predict_chem, 
    predict_phys, 
    on='Sample_ID', 
    how='outer')

# Compute 2 derived variables
# (flow speed avg = flow m3_per_sec avg/reach x-sect area)
# (annual range in flow speed = (max-min)/area
predict_merged['RA_ms_av'] = predict_merged['RA_cms_cyr']/predict_merged['RA_xam2']
predict_merged['RA_ms_di'] = (predict_merged['RA_cms_cmx'] - predict_merged['RA_cms_cmn'])/predict_merged['RA_xam2']

train_merged['RA_ms_av'] = train_merged['RA_cms_cyr']/train_merged['RA_xam2']
train_merged['RA_ms_di'] = (train_merged['RA_cms_cmx'] - train_merged['RA_cms_cmn'])/train_merged['RA_xam2']

# Cut all columns (separate ID, lon, lat as ixy)
csv_cols = [
    "RA_SO",
    "RA_dm",
    "run_mm_cyr",
    "dor_pc_pva",
    "gwt_cm_cav",
    "ele_mt_cav",
    "slp_dg_cav",
    "sgr_dk_rav",
    "tmp_dc_cyr",
    "tmp_dc_cdi",
    "pre_mm_cyr",
    "pre_mm_cdi",
    "for_pc_cse",
    "crp_pc_cse",
    "pst_pc_cse",
    "ire_pc_cse",
    "gla_pc_cse",
    "prm_pc_cse",
    "ppd_pk_cav",
    "Mean_Temp_Deg_C",
    "pH",
    "Mean_DO_mg_per_L",
    "Mean_DO_percent_saturation",
    "RA_ms_av",
    "RA_ms_di"]

ixy_cols = [
    "Sample_ID",
    "Sample_Longitude",
    "Sample_Latitude"]

# Save merged train and predict data.
# Peel off the ixy cols into separate data sets.
for n,col in enumerate(ixy_cols):
    if n == 0:
        predict_merged_ixy = predict_merged.pop(col).to_frame()
        train_merged_ixy = train_merged.pop(col).to_frame()
    else:
        predict_merged_ixy[col] = predict_merged.pop(col).to_frame()
        train_merged_ixy[col] = train_merged.pop(col).to_frame()

# Keep columns= commented to to keep all data.
predict_merged.to_csv(
    'prep_06_output_final_predict.csv',
    #columns=csv_cols,
    mode='w',
    index=False)

predict_merged_ixy.to_csv(
    'prep_06_output_final_predict.ixy',
    columns=ixy_cols,
    mode='w',
    index=False)

train_merged.to_csv(
    'prep_06_output_final_train.csv',
    #columns=csv_cols,
    mode='w',
    index=False)


train_merged_ixy.to_csv(
    'prep_06_output_final_train.ixy',
    columns=ixy_cols,
    mode='w',
    index=False)

