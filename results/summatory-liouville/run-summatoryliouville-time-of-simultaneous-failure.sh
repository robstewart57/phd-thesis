#!/bin/sh

echo -e "TimeOfFail \t Variant \t Runtime" > results-summmatoryliouville-time-of-failure.Rdata
# tuples: necessary-chunksize,desired-sparks
for timeoffail in 10 20 30 40 50 60
do
    # generate failureStr
    X="$timeoffail"
    S=$X
    i=1
    while [ $i -lt 5 ] ; do S="$S"",""$X" ; i=$((i+1)) ; done # 5 failures
    for variant in parMapSlicedFT,v5 pushMapSlicedFT,v6
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 20 -machinefile=$MPIHOSTSFILE summatory-liouville -numProcs=20 -scheds=7 -killAt="$S" -keepAliveFreq=5 $2 140000000 2000000 +RTS -N7 -RTS
            secs=`cat tmp`
            echo -e "$timeoffail \t $1 \t $secs" >> results-summatoryliouville-time-of-failure.Rdata
            sleep 1
        done
    done
done
