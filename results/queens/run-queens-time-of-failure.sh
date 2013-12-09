#!/bin/sh

echo -e "TimeOfFail \t Variant \t Runtime" > results-queens-time-of-failure.Rdata
# tuples: necessary-chunksize,desired-sparks
for timeoffail in 10 20 30 40 50 60 # can this be increased?
do
    # generate failureStr
    X="$timeoffail"
    S=$X
    i=1
    while [ $i -lt 10 ] ; do S="$S"",""$X" ; i=$((i+1)) ; done # 10 node failures
    for variant in parDnCFT,v4 pushDnCFT,v5
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            /usr/bin/time -f "%e" --output=tmp mpiexec --disable-auto-cleanup -N 20 -machinefile=$MPIHOSTSFILE queens -numProcs=20 -scheds=7 -killAt="$S" -keepAliveFreq=5 $2 14 6 +RTS -N7 -RTS
            secs=`cat tmp`
            echo -e "$timeoffail \t $1 \t $secs" >> results-queens-time-of-failure.Rdata
            sleep 1
        done
    done
done
