#!/bin/sh

###### SMP comparison
cd results/queens/monadpar-fork-spawn
Rscript ../../scripts/plot-scaleup-threshold.R results-queens-monadpar-fork-spark-GOLD.Rdata queens-1node "Queens 16x16 on Beowulf, inreasing threshold from 1 to 6"
cd ../../..


###### Runtimes
### Beowulf
# Sum Euler
cd results/sumeuler
Rscript ../scripts/plot-scaleup.R results-sumeuler-nodes-scaleup-GOLD.Rdata sumeuler-bwlf "Sum Euler 0 to 250k on Beowulf, threshold=1k"
cd ../..

# Summatory Liouville
cd results/summatory-liouville/
Rscript ../scripts/plot-scaleup.R results-sum-liouville-nodes-scaleup-GOLD.Rdata summatory-liouville-bwlf "Summatory Liouville of 200m on Beowulf, threshold=500k"
cd ../..

# Fibonacci
cd results/fib
Rscript ../scripts/plot-scaleup.R results-fib-nodes-scaleup-GOLD.Rdata fib-bwlf "Fibonacci 53 on Beowulf, threshold=27"
cd ../..

# Mandelbrot
cd results/mandel
Rscript ../scripts/plot-scaleup.R results-mandel-nodes-scaleup-GOLD.Rdata mandel-bwlf "Mandebrot 4096x4096 on Beowulf, threshold=4, depth=4000"
cd ../..

### HECToR

# Summatory Liouville
cd results/summatory-liouville/
Rscript ../scripts/plot-scaleup.R results-sum-liouville-nodes-scaleup-GOLD-HECTOR.Rdata summatory-liouville-hector "Summatory Liouville of 500m on HECToR, threshold=250k"
cd ../..

# Mandelbrot
cd results/mandel
Rscript ../scripts/plot-scaleup.R results-mandel-nodes-scaleup-GOLD-HECTOR.Rdata mandel-hector "Mandebrot 4096x4096 on HECToR, threshold=4, depth=8000"
cd ../..


###### Simultaneous failure
# Summatory Liouville

cd results/summatory-liouville
Rscript ../scripts/plot-timeoffailures-right.R results-summatoryliouville-time-of-failure-GOLD.Rdata summatory-liouville-simultaneous-failure "Summatory Liouville of 140m on Beowulf, threshold=2m" 66.8 parMapSliced 42.8 pushMapSliced
cd ../..

# Mandelbrot

cd results/mandel
Rscript ../scripts/plot-timeoffailures-left.R results-mandel-time-of-failure-GOLD.Rdata mandel-simultaneous-failure "Mandel 4096x4096 on Beowulf, Depth=4000" 66.07 parMapReduceRangeThresh 92.3 pushMapReduceRangeThresh
