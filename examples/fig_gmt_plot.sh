#!/bin/bash
#==============================
# Start a container and run
# the plotting script specified in
# $1 in the container, e.g:
#
# gmt_plot.sh fig01_sites_map.sh
#
#==============================

# Docker will automatically pull the container
# if it is not already present on the system.

# Get location of this repo
pushd ../
data_dir=`pwd`
popd
work_dir=`pwd`

# Name of script to run
run_script=$1

# Start container and run the plotting job
sudo docker run -v ${data_dir}:/data -v ${work_dir}:/work parallelworks/gmt /work/${run_script}

# Done!
