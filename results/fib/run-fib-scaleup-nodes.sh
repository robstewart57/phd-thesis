#!/bin/sh

echo -e "Cores \t Variant \t Runtime" > results-fib-nodes-scaleup.Rdata

for scale in 1,1 1,7 2,14 4,28 8,56 12,84 16,112 20,140 24,168 28,196 32,224
do
    IFS=","
    set $scale
    NODES=$1
    CORES=$2
    SCHEDS=$(($CORES/$NODES))
    for variant in parDnC,v3 parDnCFT,v5 # pushDnC,v4 parDnCFT,v5 pushDnCFT,v6
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec -N $NODES -machinefile=$MPIHOSTSFILE fib -numProcs=$NODES -scheds=$SCHEDS -keepAliveFreq=5 $2 53 27 +RTS -N$SCHEDS -RTS
            secs=`cat tmp`
            echo -e "$CORES \t $1 \t $secs" >> results-fib-nodes-scaleup.Rdata
            sleep 1
        done
    done
done
