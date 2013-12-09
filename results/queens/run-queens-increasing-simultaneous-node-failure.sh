#!/bin/sh

echo -e "FailedNodes \t Variant \t Runtime" > results-queens-nodes-increasing-failure.Rdata
# tuples: necessary-chunksize,desired-sparks
for nodesfail in 1 2 4 6 8 10 12 14 16 18 19
do
    # generate failureStr
    S="15" # failures occur at 15 seconds
    i=1
    while [ $i -lt $nodesfail ] ; do S="$S"",15" ; i=$((i+1)) ; done
    for variant in supervsedSpawn,v3 parDnCFT,v4 pushDnCFT,v5
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 20 -machinefile=$MPIHOSTSFILE queens -numProcs=20 -scheds=7 -maxFish=10 -minSched=11 -killAt="$S" -keepAliveFreq=5 $2 14 6 +RTS -N7 -RTS
            secs=`cat tmp`
            echo -e "$nodesfail \t $1 \t $secs" >> results-queens-nodes-increasing-failure.Rdata
            sleep 1
        done
    done
done
