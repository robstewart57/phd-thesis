#!/bin/sh

echo -e "" > results-summatoryliouville-chaosmonkey.data

#for nodes in 1 2 4 8 12 16 20 24 28 32
#do
    for variant in parMapFT,v5 pushMapFT,v6
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 10 summatory-liouville -numProcs=10 -keepAliveFreq=5 -chaosMonkey $2 50000000 100000 -7608 >> results-summatoryliouville-chaosmonkey.data 2>&1
            secs=`cat tmp`
            echo -e "$1: $secs" >> results-summatoryliouville-chaosmonkey.data
            sleep 1
        done
    done
#done

# mpiexec -N 10 --disable-auto-cleanup summatory-liouville -numProcs=10 -chaosMonkey v5 50000000 1000000 -7608
