#!/bin/bash
#===============================
# Plot all the WHONDRS (S19S,
# SSS) sites and all the sites
# where we can make predictions.
#===============================

# Set output files
outps=/work/fig09-predict-errors-map.ps
outpdf=/work/fig09-predict-errors-map.pdf

# Set domain for inset
echo -124.0, 45.0 > inset.xy.tmp
echo -116.0, 45.0 >> inset.xy.tmp
echo -116.0, 49.0 >> inset.xy.tmp
echo -124.0, 49.0 >> inset.xy.tmp
echo -124.0, 45.0 >> inset.xy.tmp

# Respiration rate colorbar
gmt makecpt -T0/4/0.5 -Cno_green > rr.cpt.tmp

#====================================
# Make the large-scale plot
gmt psbasemap -JM6i -R-125/-65/22/50 -Ba15/a5 -P -K -Y4i -X1.7i> $outps
gmt pscoast -J -R -B -P -O -K -Ggray >> $outps

# Special marker for S19S sites
grep S19S /work/fig09_predict_errors.csv | awk -F, '{print $3,$4}' | gmt psxy -J -R -B -P -O -K -Sp0.3 -Wblack >> $outps

# Color coded by error
awk -F, 'NR > 1 {print $3,$4,$5}' /work/fig09_predict_errors.csv | gmt psxy -J -R -B -P -O -K -Sp0.15 -Crr.cpt.tmp >> $outps

# Inset outline
gmt psxy -J -R -B inset.xy.tmp -P -O -K -Wthin,black -A >> $outps

# Colorbar
gmt psscale -Dx2i/-0.75i+w4i/0.25i+e+h -Crr.cpt.tmp -Ba1g1 -B+l"Log10\(prediction\ error\),\ \(log10\(mg\ DO\/L\/h\)\)" -P -O -K >> $outps

#=====================================
# Make the small-scale plot
gmt psbasemap -JM2.75i -R-124/-116/45/49 -Ba2/a2WeSn -P -O -K -Y-1.4i -X-1.2i >> $outps
gmt pscoast -J -R -B -P -O -K -Ggray >> $outps

# Special marker for S19S sites
grep S19S /work/fig09_predict_errors.csv | awk -F, '{print $3,$4}' | gmt psxy -J -R -B -P -O -K -Sp0.3 -Wblack >> $outps

# Color coded by error
awk -F, 'NR > 1 {print $3,$4,$5}' /work/fig09_predict_errors.csv | gmt psxy -J -R -B -P -O -K -Sp0.15 -Crr.cpt.tmp >> $outps

#====================================
# Convert to pdf, output pdf automatically named
ps2pdf $outps $outpdf

# Clean up
rm $outps
rm rr.cpt.tmp

# Done!

