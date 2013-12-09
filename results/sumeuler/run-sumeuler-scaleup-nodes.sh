#!/bin/sh

echo -e "Nodes \t Variant \t Runtime" > results-sumeuler-nodes-scaleup.Rdata

for nodes in 1 2 4 8 12 16 20 24 28 32
do
    for variant in parMapSliced,v7 parMapSlicedFT,v10 pushMapSliced,v12 pushMapSlicedFT,v13 # spawn,v6 parMap,v7 supervisedSpawn,v9 parMapFT,v10 pushMap,v12 pushMapFT,v13 
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec -N $nodes -machinefile=$MPIHOSTSFILE sumeuler -numProcs=$nodes -scheds=7 -keepAliveFreq=5 $2 0 200000 1000 +RTS -N7 -RTS
            secs=`cat tmp`
            echo -e "$nodes \t $1 \t $secs" >> results-sumeuler-nodes-scaleup.Rdata
            sleep 1
        done
    done
done
