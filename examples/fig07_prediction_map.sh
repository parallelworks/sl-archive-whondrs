#!/bin/bash
#===============================
# Plot predictions at the WHONDRS
# (S19S, SSS) sites and all the sites
# where we can make predictions.
#===============================

# Set output files
outps=/work/fig07-prediction-map.ps
outpdf=/work/fig07-prediction-map.pdf

# Set domain for map
xmin=-124.0
ymin=45.0
xmax=-116.0
ymax=49.0

# Set R-flag, B-flag
ropt=${xmin}/${xmax}/${ymin}/${ymax}

# Make colormaps
gmt makecpt -T-4/0/0.5 -Cno_green > rr.cpt.tmp
gmt makecpt -Cglobe > topo.cpt.tmp
gmt makecpt -Cbathy -T1/10/1 -Ic > so.cpt.tmp

#================================================
echo Download ETOPO1 and decompress...
#================================================
# Commented out because manually copying file, but
# this will work if you don't have your own copy.
#wget -q https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gmt4.grd.gz
#gunzip -c ETOPO1_Ice_g_gmt4.grd.gz > /work/ETOPO1_Ice_g_gmt4.grd

#================================================
echo Plot predictions at GLORICH/WHONDRS sites...
# River network stream order
# Background is topography
#================================================

# Background
gmt psbasemap -JM6i -R${ropt} -Ba2/a2 -P -K -Y6i > $outps
gmt grdimage /work/ETOPO1_Ice_g_gmt4.grd -J -R -B -P -O -K -Ctopo.cpt.tmp >> $outps

# River network

# Plot predictions at WHONDRS sites
#grep S19S /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -S+0.2 -Wred >> $outps

# Plot predictions at GLORICH sites
#awk -F, 'NR > 1 {print $2,$3}' /work/RiverAtlas_GLORICH_colocated_for_prediction.csv | gmt psxy -J -R -B -P -O -K -Sp0.05 -Gblack -Wblack >> $outps

#===============================================
echo Plot predictions on whole river network...
# Background is topography
#===============================================

# Background
gmt psbasemap -JM6i -R${ropt} -Ba2/a2 -P -O -K -Y-4i >> $outps
gmt grdimage /work/ETOPO1_Ice_g_gmt4.grd -J -R -B -P -O -K -Ctopo.cpt.tmp >> $outps

# River network plotted by predicted value

#===============================================
echo Clean up, etc.
#===============================================
# Convert to pdf, output pdf automatically named
ps2pdf $outps $outpdf

# Clean up
rm $outps
rm rr.cpt.tmp
rm topo.cpt.tmp
rm so.cpt.tmp

# Done!

