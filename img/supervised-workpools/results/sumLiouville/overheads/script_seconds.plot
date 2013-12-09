
set terminal postscript
set output "| ps2pdf - sumLiouville-overheads-nofailures.pdf"
set key font ",18"
set xrange [90:1010]
set yrange [-1:15]
set y2range [0:8]
set xtics font "Times-Roman, 20" 
set ytics font "Times-Roman, 25"
set y2tics font "Times-Roman, 25" 
set title "Supervision Overheads in Summatory Liouville" font "Helvetica, 25"
set xlabel "Number of closures supervised" font "Helvetica, 25"
set ylabel "Overhead (seconds)" font "Helvetica, 25"
set y2label "Overhead (percentage)" font "Helvetica, 25"

plot 'SL_overheads_seconds.dat' using 1:2:3:4 notitle with yerrorbars, 'SL_overheads_seconds.dat' title "Using supervision" with lines linetype -1, 0 with lines lt 3 title "No supervsion", 'SL_overheads_percentage.dat' title "Percentage overhead" with lines linetype 5
