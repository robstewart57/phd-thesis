set terminal postscript
set output "| ps2pdf - sumLiouville-reallocation-overlay.pdf"

set style line 2 lt 2 lc 7

set ytics 5 nomirror
set y2tics 3 nomirror
set y2range [-1:35]
set yrange [90:120]
set xrange [0:105]

set ylabel "Runtime (Seconds)"
set y2label "Number of reallocated closures"
set xlabel "Time of Node Failure w.r.t. Estimated Runtime"
set title "Summatory Liouville Runtimes with 1 Node Failure" font "Times,20"

set format x "%g %%"

plot "mean_reallocations.dat" with lines ls 4 axes x1y2 title "Mean closure reallocation", \
     111.61 with lines lt 2 title "Mean of failure free runtimes", \
     "recovered_closures.dat" using 2:3 with points title "Runtimes with failure", \
     "9nodes.dat" using 1:2 with points pt 6 pointsize 1 title "Using 9 nodes no failures", \
     "10nodes.dat" using 1:2 with points pt 5 pointsiz 0.8 title "Using 10 nodes no failures", \
     102.1 with lines lt 2 notitle
     
