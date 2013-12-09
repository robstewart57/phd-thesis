#!/bin/sh

echo -e "Threshold \t Variant \t Runtime" > results-queens-monadpar-fork-spark.Rdata

for threshold in {1..6}
do
    for variant in supervisedSpawn,v3 # spawn,v0 supervisedSpawn,v3 fork,v8
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp2 queens -numProcs=1 -scheds=7 $2 16 $threshold +RTS -N7 -K48m -RTS
            secs=`cat tmp2`
            echo -e "$threshold \t $1 \t $secs" >> results-queens-monadpar-fork-spark.Rdata
            sleep 1
        done
    done
    
    # special case: monad-par
    # for i in {1..5}
    # do
    #     /usr/bin/time -f "%e" --output=tmp2 queens -numProcs=1 v9 16 $threshold +RTS -N7 -K48m -RTS
    #     secs=`cat tmp2`
    #     echo -e "$threshold \t monad-par \t $secs" >> results-queens-monadpar-fork-spark.Rdata
    #     sleep 1
    # done
    
done
