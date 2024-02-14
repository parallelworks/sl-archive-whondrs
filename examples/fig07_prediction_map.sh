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
gmt makecpt -T0/4/0.5 -Cno_green > rr.cpt.tmp
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
gmt psbasemap -JM5i -R${ropt} -Ba2/a2WeSn -P -K -Y2i > $outps
gmt grdimage /work/ETOPO1_Ice_g_gmt4.grd -J -R -B -P -O -K -Ctopo.cpt.tmp >> $outps

# River network (manually cloned https://github.com/parallelworks/global-river-databases here)
tile_files1=/work/global-river-databases/RiverAtlas/tiles_compressed/RiverATLAS_v10_na.xyz.7411
tile_files2=/work/global-river-databases/RiverAtlas/tiles_compressed/RiverATLAS_v10_na.xyz.7412
gunzip -c ${tile_files1}.gz > $tile_files1
gunzip -c ${tile_files2}.gz > $tile_files2
gmt psxy $tile_files1 -J -R -B -Wthick -Cso.cpt.tmp -P -O -K >> $outps
gmt psxy $tile_files2 -J -R -B -Wthick -Cso.cpt.tmp -P -O -K >> $outps

# Plot predictions at WHONDRS sites
input_file=/work/WHONDRS_S19S-SSS-log10-r02_predictions.csv
sed 's/,/ /g' ${input_file} | awk 'NR > 1 {print $2,$3,log(-1.0*$4)/log(10.0)}' > tmp.xyr
gmt psxy -J -R -B tmp.xyr -Gblack -Wblack -P -O -K -Sp0.2 >> $outps
gmt psxy -J -R -B tmp.xyr -Crr.cpt.tmp -P -O -K -Sp0.15 >> $outps

# Plot predictions at GLORICH sites
input_file=/work/RiverAtlas_GLORICH_predictions.csv
sed 's/,/ /g' ${input_file} | awk 'NR > 1 {print $3,$4,log(-1.0*$15)/log(10.0)}' > tmp.xyr
gmt psxy -J -R -B tmp.xyr -Gblack -Wblack -P -O -K -Sp0.2 >> $outps
gmt psxy -J -R -B tmp.xyr -Crr.cpt.tmp -P -O -K -Sp0.15 >> $outps

# Colorbar
gmt psscale -Dx0i/-0.75i+w5i/0.25i+e+h -Crr.cpt.tmp -Ba5g1 -B+l"Log10\ of\ Predicted\ respiration\ rate,\ mg\ O2\/L\/h" -P -O -K >> $outps

#===============================================
echo Plot predictions on whole river network...
# Background is topography
#===============================================

# Background
gmt psbasemap -JM5i -R${ropt} -Ba2/a2Wesn -P -O -K -Y4i >> $outps
gmt grdimage /work/ETOPO1_Ice_g_gmt4.grd -J -R -B -P -O -K -Ctopo.cpt.tmp >> $outps

# River network plotted by predicted value
input_file=/work/grdb_predictions.csv
gunzip -c $input_file.gz > $input_file
awk -F, 'NR > 1 {print ">",$2,"-Z"(log(-1.0*$17)/log(10)),"\n"$3,$4,"\n"$5,$6}' $input_file | gmt psxy -J -R -B -Wthick -Crr.cpt.tmp -P -O -K >> $outps

# Mini clean up
rm -f /work/grdb_predictions.csv

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

