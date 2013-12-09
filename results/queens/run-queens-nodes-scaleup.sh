#!/bin/sh

echo -e "Nodes \t Variant \t Runtime" > results-queens-nodes-scaleup.Rdata

for nodes in 1 2 4 8 12 16 20 24 28 32
do
    for variant in parDnC,v1 pushDnC,v2  parDnCFT,v4 pushDnCFT,v5 # spawn,v0 supervsedSpawn,v3 FT-push-75pcDnC,v7 # fork,v8
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec -N $nodes -machinefile=$MPIHOSTSFILE queens -numProcs=$nodes -scheds=7 -keepAliveFreq=5 -minSched=3 -maxFish=2 $2 16 2 +RTS -N7 -RTS
            secs=`cat tmp`
            echo -e "$nodes \t $1 \t $secs" >> results-queens-nodes-scaleup.Rdata
            sleep 1
        done
    done
done
