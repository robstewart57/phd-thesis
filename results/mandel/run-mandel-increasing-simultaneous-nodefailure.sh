#!/bin/sh

echo -e "FailedNodes \t Variant \t Runtime" > results-mandel-nodes-increasing-failure.Rdata
# tuples: necessary-chunksize,desired-sparks
for nodesfail in 1 2 4 6 8 10 12 14 16 18 19
do
    # generate failureStr
    S="15"
    i=1
    while [ $i -lt $nodesfail ] ; do S="$S"",15" ; i=$((i+1)) ; done
    for variant in parMapReduceRangeThreshFT,v2 pushMapReduceRangeThreshFT,v3
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 20 -machinefile=$MPIHOSTSFILE mandel -numProcs=20 -killAt="$S" -keepAliveFreq=5 $2 4096 4096 4000 4 +RTS -N4 -RTS
            secs=`cat tmp`
            echo -e "$nodesfail \t $1 \t $secs" >> results-mandel-nodes-increasing-failure.Rdata
            sleep 1
        done
    done
done
