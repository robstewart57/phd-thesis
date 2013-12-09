
#!/u1/pg/rs46/bin/ksh

echo -e "Cores \t Variant \t Runtime" > results-sum-liouville-nodes-scaleup.Rdata

for scale in 1,1 1,7 2,14 4,28 8,56 12,84 16,112 20,140 24,168 28,196 32,224
do
    IFS=","
    set $scale
    NODES=$1
    CORES=$2
    SCHEDS=$(($CORES/$NODES))
    for variant in parMapSliced,v8 pushMapSliced,v9 parMapSlicedFT,v5 pushMapSlicedFT,v6 # spawn,v1 supervisedSpawn,v4
    do
        IFS=","
        set $variant
        for i in {1..5}
        do
            orig=$SECONDS
            /usr/bin/time -f "%e" --output=tmp mpiexec -N $NODES -machinefile=$MPIHOSTSFILE summatory-liouville -numProcs=$NODES -scheds=$SCHEDS -keepAliveFreq=5 $2 200000000 2000000 +RTS -N$SCHEDS -RTS
            secs=`cat tmp`
            echo -e "$CORES \t $1 \t $secs" >> results-sum-liouville-nodes-scaleup.Rdata
            sleep 1
        done
    done
done
