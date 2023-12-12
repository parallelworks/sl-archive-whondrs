#!/bin/bash
#=========================
# Postprocessing orchestration
#=========================

# ASSUMING THAT THIS SCRIPT IS RUNNING IN ./dynamic-learning-rivers/scripts

miniconda_loc=$1
my_env=$2

# Activate Conda
source ${miniconda_loc}/etc/profile.d/conda.sh
conda activate $my_env

# Step 1: Use Pandas to flatten all results from each ML model
python post_01_flatten.py

# Step 2: Cut data to CONUS, Remove sites already sampled, sort
# NOT NEEDED FOR S19S
#./post_02_filter_sort.sh

# Check that outputs dir is created
mkdir -p ../output_data

# Send a copy of the key output to ../output_data
mv post_01_output_ml_predict_avg.csv ../output_data/unfiltered_predict_output_avg.csv
mv post_01_output_ml_predict_std.csv ../output_data/unfiltered_predict_output_std.csv
mv post_01_output_holdout_score.txt ../output_data/holdout_score.txt

mv post_01_output_fpi_avg.csv ../output_data/fpi_avg.csv
mv post_01_output_fpi_std.csv ../output_data/fpi_std.csv
mv post_01_output_FPI.png ../output_data/FPI.png

