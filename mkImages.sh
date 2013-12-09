#!/bin/sh

# Chapter 2
cd img/chp2/failure_detectors/
dia -e passive-heartbeat.eps -t eps passive-heartbeat.dia
convert passive-heartbeat.eps passive-heartbeat.pdf
rm passive-heartbeat.eps

dia -e active-heartbeat.eps -t eps active-heartbeat.dia
convert active-heartbeat.eps active-heartbeat.pdf
rm active-heartbeat.eps

dia -e pingpong.eps -t eps pingpong.dia
convert pingpong.eps pingpong.pdf
rm pingpong.eps

cd ../availability_tactics
fig2mpdf availability_tactics.fig

cd ../erlang
dia -e erlang-supervision-tree.eps -t eps erlang-supervision-tree.dia
convert erlang-supervision-tree.eps erlang-supervision-tree.pdf
rm erlang-supervision-tree.eps

cd ../hdph_architecture
fig2mpdf hdph_architecture.fig

cd ../cci
fig2mpdf transport-layers-mpi.fig

cd ../intro
dia -e fault_classes.eps -t eps fault_classes.dia
convert fault_classes.eps fault_classes.pdf
rm fault_classes.eps

dia -e dependability_tree.eps -t eps dependability_tree.dia
convert dependability_tree.eps dependability_tree.pdf
rm dependability_tree.eps

dia -e fundamental-chain.eps -t eps fundamental-chain.dia
convert fundamental-chain.eps fundamental-chain.pdf
rm fundamental-chain.eps

cd ../distributed-haskell
fig2mpdf layers.fig

cd ../../

# Chapter 3

cd chp3/hdphrs-dataflow/
inkscape hdphrs-dataflow.svg -z -D --export-pdf=hdphrs-dataflow.pdf

cd ../design-abstraction
fig2mpdf design-abstraction.fig

cd ../scheduling-behaviours
fig2mpdf base-case.fig
fig2mpdf sched-spawn1.fig
fig2mpdf sched-spawn2.fig
fig2mpdf sched-spawn3.fig
fig2mpdf sched-spawn4.fig
fig2mpdf sched-spawnAt1.fig
fig2mpdf sched-spawnAt2.fig

cd ../simultaneous-failure
fig2mpdf task-expansion-example.fig
fig2mpdf task-expansion-example2.fig
fig2mpdf no-faults2.fig
fig2mpdf two-faults3.fig
fig2mpdf two-faults3-recovered.fig

cd ../msc
xelatex hdph-fishing.tex
pdfcrop hdph-fishing.pdf hdph-fishing.pdf

xelatex hdph-fishing-simple.tex
pdfcrop hdph-fishing-simple.pdf hdph-fishing-simple.pdf

xelatex fish-rejected.tex
pdfcrop fish-rejected.pdf
mv fish-rejected-crop.pdf fish-rejected.pdf

xelatex req-denied.tex
pdfcrop req-denied.pdf
mv req-denied-crop.pdf req-denied.pdf

xelatex hdphrs-fishing-protocol.tex
pdfcrop hdphrs-fishing-protocol.pdf
mv hdphrs-fishing-protocol-crop.pdf hdphrs-fishing-protocol.pdf

xelatex hdphrs-fishing-protocol-no-tracking.tex
pdfcrop hdphrs-fishing-protocol-no-tracking.pdf
mv hdphrs-fishing-protocol-no-tracking-crop.pdf hdphrs-fishing-protocol-no-tracking.pdf

xelatex hops-deadlock.tex
pdfcrop hops-deadlock.pdf
mv hops-deadlock-crop.pdf hops-deadlock.pdf

xelatex spark-duplication.tex
pdfcrop spark-duplication.pdf
mv spark-duplication-crop.pdf spark-duplication.pdf

xelatex ack-with-replica.tex
pdfcrop ack-with-replica.pdf
mv ack-with-replica-crop.pdf ack-with-replica.pdf

xelatex req-with-replica.tex
pdfcrop req-with-replica.pdf
mv req-with-replica-crop.pdf req-with-replica.pdf

cd ../msc-states
fig2mpdf msc-states.fig

cd ../../

# Chapter 4
cd chp4/msc
xelatex hdphrs-fishing-protocol-promela.tex
pdfcrop hdphrs-fishing-protocol-promela.pdf
mv hdphrs-fishing-protocol-promela-crop.pdf hdphrs-fishing-protocol-promela.pdf

xelatex hdphrs-fishing-protocol-promela-recovery.tex
pdfcrop hdphrs-fishing-protocol-promela-recovery.pdf
mv hdphrs-fishing-protocol-promela-recovery-crop.pdf hdphrs-fishing-protocol-promela-recovery.pdf

xelatex msc-promela.tex
pdfcrop msc-promela.pdf
mv msc-promela-crop.pdf msc-promela.pdf

xelatex identified-bug-with-promela.tex
pdfcrop identified-bug-with-promela.pdf
mv identified-bug-with-promela-crop.pdf identified-bug-with-promela.pdf


cd ../..

# Chapter 5
cd chp5/transport-layers/
fig2mpdf transport-layers-hdphrs.fig

cd ../module-view/
fig2mpdf hdphrs-module-view.fig

cd ../hdphrs-architecture
fig2mpdf hdphrs-architecture.fig

cd ../tcp-handshake
fig2mpdf tcp-handshake.fig

cd ../deques
inkscape sparkpool-deque.svg -z -D --export-pdf=sparkpool-deque.pdf
cd ../../

# Chapter 6
cd chp6/lazy-eager-recovery
fig2mpdf eager-recovery.fig
fig2mpdf lazy-recovery.fig

cd ../../../spin_model
spin -o3 -a hdph_scheduler.pml
gcc -o pan pan.c
./pan -D | dot > hdphrs.dot
gvpr -f splitgraphs.gvpr hdphrs.dot
sed -i 's/fname/ranksep="0.8",margin="0",fname/g' p_Supervisor.dot
sed -i 's/(spark.age>100)))",/(spark.age>100)))",constraint=false,/g' p_Supervisor.dot
sed -i 's/Worker(0))",/Worker(0))",constraint=false,/g' p_Supervisor.dot
sed -i 's/Worker(1))",/Worker(1))",constraint=false,/g' p_Supervisor.dot
dot -Tpdf -o supervisor.pdf p_Supervisor.dot

gvpr -f splitgraphs.gvpr hdphrs.dot
sed -i 's/fname/ranksep="4.2",nodesep="1.1",margin="0",fname/g' p_Worker.dot
sed -i 's/label/fontsize="40",label/g' p_Worker.dot
sed -i 's/(spark.age>100)))",/(spark.age>100)))",constraint=false,/g' p_Worker.dot
sed -i 's/SchedAuth)))",/SchedAuth)))",labelfloat=true,/g' p_Worker.dot
sed -i 's/100+1))))",/100+1))))",constraint=false,/g' p_Worker.dot
dot -Tpdf -o worker.pdf p_Worker.dot

cd ../

# Supervised workpool appendix
cd img/supervised-workpools/results/fib
gnuplot plot.script

cd ../sumLiouville
gnuplot plot.script

cd overheads
gnuplot script_seconds.plot

cd ../sumLiouvilleFaults
gnuplot script.plot
gnuplot script_overlay.plot

cd ../../../use_cases
fig2mpdf use-case1.fig
fig2mpdf use-case2.fig

cd ../../../
