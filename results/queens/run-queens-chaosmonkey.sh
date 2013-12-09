#!/bin/sh

echo -e "" > results-queens-chaosmonkey.data

#for nodes in 1 2 4 8 12 16 20 24 28 32
#do
    for variant in parDnCFT,v4 pushDnCFT,v5
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 10 queens -numProcs=10 -keepAliveFreq=5 -chaosMonkey $2 14 5 365596 >> results-queens-chaosmonkey.data 2>&1
            secs=`cat tmp`
            echo -e "$1: $secs" >> results-queens-chaosmonkey.data
            sleep 1
        done
    done
#done
