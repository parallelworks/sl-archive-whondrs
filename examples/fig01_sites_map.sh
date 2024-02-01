#!/bin/bash
#===============================
# Plot all the WHONDRS (S19S,
# SSS) sites and all the sites
# where we can make predictions.
#===============================

# Set output files
outps=/work/fig01_sites_map.ps
outpdf=/work/fig01_sites_map.pdf

# Set domain for inset
echo -124.0, 45.0 > inset.xy.tmp
echo -116.0, 45.0 >> inset.xy.tmp
echo -116.0, 48.0 >> inset.xy.tmp
echo -124.0, 48.0 >> inset.xy.tmp
echo -124.0, 45.0 >> inset.xy.tmp

# Make the plot
gmt psbasemap -JM6i -R-125/-65/22/50 -Ba15/a5 -P -K -Y2i > $outps
gmt pscoast -J -R -B -P -O -K -Ggray >> $outps
grep S19S /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -S+0.2 -Wred >> $outps
grep SSS /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -Sp0.05 -Gpink >> $outps
awk -F, 'NR > 1 {print $2,$3}' /work/RiverAtlas_GLORICH_colocated_for_prediction.csv | gmt psxy -J -R -B -P -O -K -Sp0.05 -Gblack -Wblack >> $outps
gmt psxy -J -R -B inset.xy.tmp -P -O -K -Wthin,black >> $outps

# Convert to pdf, output pdf automatically named
ps2pdf $outps $outpdf

# Clean up
rm $outps

# Done!

