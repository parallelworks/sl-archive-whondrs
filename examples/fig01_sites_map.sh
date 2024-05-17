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
echo -116.0, 49.0 >> inset.xy.tmp
echo -124.0, 49.0 >> inset.xy.tmp
echo -124.0, 45.0 >> inset.xy.tmp

#====================================
# Make the large-scale plot
gmt psbasemap -JM6i -R-125/-65/22/50 -Ba15/a5 -P -K -Y4i -X1.7i> $outps
gmt pscoast -J -R -B -P -O -K -Ggray >> $outps
grep S19S /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -S+0.2 -Wred >> $outps
grep SSS /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -Sp0.05 -Gpink >> $outps

# Using all possible GLORICH sites
#awk -F, 'NR > 1 {print $2,$3}' /work/RiverAtlas_GLORICH_colocated_for_prediction.csv | gmt psxy -J -R -B -P -O -K -Sp0.05 -Gblack -Wblack >> $outps

# Using only GLORICH sites where we have all insitu data (T, pH, DO, %DO)
awk -F, 'NR > 1 {print $3,$4}' /work/RiverAtlas_GLORICH_S19S-SSS-log10-extrap-r01_ele_corrected_O2_predictions.csv | gmt psxy -J -R -B -P -O -K -Sp0.05 -Gblack -Wblack >> $outps

gmt psxy -J -R -B inset.xy.tmp -P -O -K -Wthin,black -A >> $outps

#=====================================
# Make the small-scale plot
gmt psbasemap -JM2.75i -R-124/-116/45/49 -Ba2/a2WeSn -P -O -K -Y-1.5i -X-1.2i >> $outps
gmt pscoast -J -R -B -P -O -K -Ggray >> $outps
grep S19S /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -S+0.3 -Wred >> $outps
grep SSS /work/WHONDRS_S19S_SSS_merged.csv | awk -F, '{print $2,$3}' | gmt psxy -J -R -B -P -O -K -Sp0.1 -Gpink >> $outps

# Using only GLORICH sites where we have all insitu data (T, pH, DO, %DO)
awk -F, 'NR > 1 {print $3,$4}' /work/RiverAtlas_GLORICH_S19S-SSS-log10-extrap-r01_ele_corrected_O2_predictions.csv | gmt psxy -J -R -B -P -O -K -Sp0.1 -Gblack -Wblack >> $outps

#====================================
# Convert to pdf, output pdf automatically named
ps2pdf $outps $outpdf

# Clean up
rm $outps

# Done!

