#!/bin/sh

echo -e "Cores \t Variant \t Runtime" > results-mandel-nodes-scaleup.Rdata

for scale in 1,1 1,7 2,14 4,28 8,56 12,84 16,112 20,140 24,168 28,196 32,224
do
    IFS=","
    set $scale
    NODES=$1
    CORES=$2
    SCHEDS=$(($CORES/$NODES))
    for variant in parMapReduceRangeThresh,v0 pushMapReduceRangeThresh,v1 parMapReduceRangeThreshFT,v2 pushMapReduceRangeThreshFT,v3
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec -N $NODES -machinefile=$MPIHOSTSFILE mandel -numProcs=$NODES -scheds=$SCHEDS -keepAliveFreq=5 $2 4096 4096 4000 4 +RTS -N$SCHEDS -RTS
            secs=`cat tmp`
            echo -e "$CORES \t $1 \t $secs" >> results-mandel-nodes-scaleup.Rdata
            sleep 1
        done
    done
done
