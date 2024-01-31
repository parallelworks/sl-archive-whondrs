#!/bin/bash
#===============================
# Plot all the WHONDRS (S19S,
# SSS) sites and all the sites
# where we can make predictions.
#===============================

# Set output files
outps=/work/fig01_sites_map.ps
outpdf=/work/fig01_sites_map.pdf

# Make the plot
gmt psbasemap -JM6i -R-125/-65/22/50 -Ba15/a5 -P -K -Y2i > $outps
gmt pscoast -J -R -B -P -O -K -Gdarkgray >> $outps
grep S19S /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -Sp0.1 -Gred -Wred >> $outps
grep SSS /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -Sp0.1 -Gpink -Wpink >> $outps
awk -F, 'NR > 1 {print $2,$3}' /work/RiverAtlas_GLORICH_colocated_for_prediction.csv | gmt psxy -J -R -B -P -O -K -Sp0.1 -Gdarkgray -Wdarkgray >> $outps

# Convert to pdf, output pdf automatically named
ps2pdf $outps -o

# Clean up
rm $outps

# Done!
