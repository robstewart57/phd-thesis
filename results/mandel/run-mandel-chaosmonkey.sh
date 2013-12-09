#!/bin/sh

echo -e "" > results-mandel-chaosmonkey.data

#for nodes in 1 2 4 8 12 16 20 24 28 32
#do
    for variant in parMapReduceFT,v2 pushMapReduceFT,v3
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 20 mandel -numProcs=20 -keepAliveFreq=5 -chaosMonkey $2 4096 4096 4000 4 449545051 >> results-mandel-chaosmonkey.data 2>&1
            secs=`cat tmp`
            echo -e "$1: $secs" >> results-mandel-chaosmonkey.data
            sleep 1
        done
    done
#done
