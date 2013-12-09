mtype = { FISH , DEADNODE , SCHEDULE , REQ , AUTH ,  DENIED , ACK , NOWORK , OBSOLETE  , RESULT} ;
mtype = { ONNODE , INTRANSITION };

typedef Location
{
  int from;
  int to;
  int at=3;
}

typedef Sparkpool {
  int spark_count=0;
  int spark=0; /* sequence number */
}

typedef Spark {
  int highestReplica=0;
  Location location;
  mtype context=ONNODE; 
  int age=0;
}

typedef WorkerNode {
  Sparkpool sparkpool;
  int waitingFishReplyFrom;
  bool waitingSchedAuth=false;
  bool resultSent=false;
  bool dead=false;
  int lastTried;
};

typedef SupervisorNode {
  Sparkpool sparkpool;
  bool waitingSchedAuth=false;
  bool resultSent=false;
  bit ivar=0;
};

#define null -1
#define maxLife 100

WorkerNode worker[3];
SupervisorNode supervisor;
Spark spark;
chan chans[4] = [10] of {mtype, int , int , int } ;

inline report_death(me){
  chans[0] ! DEADNODE(me, null, null) ; 
  chans[1] ! DEADNODE(me, null, null) ;
  chans[2] ! DEADNODE(me, null, null) ;
  chans[3] ! DEADNODE(me, null, null) ; /* supervisor */
}

active proctype Supervisor() {
  int thiefID, victimID, deadNodeID, seq, authorizedSeq, deniedSeq;
  
  supervisor.sparkpool.spark_count = 1;
  run Worker(0); run Worker(1); run Worker(2); 

SUPERVISOR_RECEIVE:
  
  if  :: (supervisor.sparkpool.spark_count > 0 && spark.age > maxLife) ->
         atomic {
           supervisor.resultSent = 1;
           supervisor.ivar = 1;  /* write to IVar locally */
           goto EVALUATION_COMPLETE;
         }
      :: else ->
         if
           :: (supervisor.sparkpool.spark_count > 0) ->
              atomic {
                supervisor.resultSent = 1;
                supervisor.ivar = 1;  /* write to IVar locally */
                goto EVALUATION_COMPLETE;
              }
           :: chans[3] ? DENIED(thiefID, deniedSeq,null) ->
              supervisor.waitingSchedAuth = false;
              chans[thiefID] ! NOWORK(3, null, null) ;
           :: chans[3] ? FISH(thiefID, null,null) -> /* React to FISH request */
              if
                :: (supervisor.sparkpool.spark_count > 0 && !supervisor.waitingSchedAuth) -> /* We have the spark */
                   supervisor.waitingSchedAuth = true;
                   chans[3] ! REQ(3, thiefID, supervisor.sparkpool.spark);
                ::  else -> chans[thiefID] ! NOWORK(3, null,null) ; /*We don't have the spark */
              fi; 
           :: chans[3] ? AUTH(thiefID, authorizedSeq, null) -> /* React to FISH request */
              d_step {
                supervisor.waitingSchedAuth = false;
                supervisor.sparkpool.spark_count--;
              }
              chans[thiefID] ! SCHEDULE(3, supervisor.sparkpool.spark ,null);
           :: chans[3] ? REQ(victimID, thiefID, seq) ->
              if
                :: seq == spark.highestReplica ->
                   if
                     :: spark.context == ONNODE && ! worker[thiefID].dead->
                        d_step {
                          spark.context  = INTRANSITION;
                          spark.location.from = victimID ;
                          spark.location.to = thiefID ;
                        }
                        chans[victimID] ! AUTH(thiefID, seq, null);
                     :: else ->
                        chans[victimID] ! DENIED(thiefID, seq, null);
                   fi
                :: else ->
                   chans[victimID] ! OBSOLETE(thiefID, null, null); /* obsolete sequence number */
              fi
           :: chans[3] ? ACK(thiefID, seq, null) ->
              if
                :: seq == spark.highestReplica ->
                   d_step {
                     spark.context = ONNODE;
                     spark.location.at = thiefID ;
                   }
                :: else -> skip ;
              fi             
           :: atomic { chans[3] ? RESULT(null, null, null); supervisor.ivar = 1; goto EVALUATION_COMPLETE; }	              
           :: chans[3] ? DEADNODE(deadNodeID, null, null) ->
              bool should_replicate;
              d_step {
                should_replicate = false;
                if
                  :: spark.context == ONNODE \
                     && spark.location.at == deadNodeID -> should_replicate = true;
                  :: spark.context  == INTRANSITION \
                     && (spark.location.from == deadNodeID \
                         || spark.location.to == deadNodeID) -> should_replicate = true;
                  :: else -> skip;
                fi;
                
                if
                  :: should_replicate ->
                     spark.age++;
                     supervisor.sparkpool.spark_count++;
                     spark.highestReplica++;
                     supervisor.sparkpool.spark = spark.highestReplica ;
                     spark.context = ONNODE;
                     spark.location.at = 3 ;
                  :: else -> skip;
                fi;
              }
         fi;
  fi;
  
  if
    :: (supervisor.ivar == 0) -> goto SUPERVISOR_RECEIVE;
    :: else -> skip;
  fi;    
  
EVALUATION_COMPLETE:
  
}  /* END OF SUPERVISOR */

proctype Worker(int me) {
  int thiefID, victimID, deadNodeID, seq, authorisedSeq, deniedSeq;
  
WORKER_RECEIVE:

  if
    :: (worker[me].sparkpool.spark_count > 0 && spark.age > maxLife) -> 
       atomic {
         worker[me].resultSent = true;
         chans[3]  ! RESULT(null,null,null);
         goto END;
       }
            
    :: else ->
       if
         ::  skip ->  /* die */
            worker[me].dead = true;
            report_death(me);
            goto END;

         :: (worker[me].sparkpool.spark_count > 0) ->
              chans[3] ! RESULT(null,null,null);
            
         :: (worker[me].sparkpool.spark_count == 0 && (worker[me].waitingFishReplyFrom == -1) && spark.age < (maxLife+1)) -> 
            /* Lets go fishing */
            int chosenVictimID;
            d_step {
              if
                :: (0 != me) && !worker[0].dead  && (worker[me].lastTried -  0) -> chosenVictimID = 0;
                :: (1 != me) && !worker[1].dead  && (worker[me].lastTried -  1)  -> chosenVictimID =1;
                :: (2 != me) && !worker[2].dead  && (worker[me].lastTried -  2)  -> chosenVictimID = 2;
                :: skip -> chosenVictimID = 3; /* supervisor */
              fi;
              worker[me].lastTried=chosenVictimID;
              worker[me].waitingFishReplyFrom = chosenVictimID;
            };
            chans[chosenVictimID] ! FISH(me, null, null) ;
            
         :: chans[me] ? NOWORK(victimID, null, null) ->
              worker[me].waitingFishReplyFrom = -1;  /* can fish again */

         :: chans[me] ? FISH(thiefID, null, null) -> /* React to FISH request */
            if
              :: (worker[me].sparkpool.spark_count > 0 && ! worker[me].waitingSchedAuth) -> /* We have the spark */
                 worker[me].waitingSchedAuth = true;
                 chans[3] ! REQ(me, thiefID, worker[me].sparkpool.spark);
              ::  else -> chans[thiefID] ! NOWORK(me, null, null) ; /*We don't have the spark */
            fi
            
         :: chans[me] ? AUTH(thiefID, authorisedSeq, null) ->  /* React to schedule authorisation */
            d_step {
              worker[me].waitingSchedAuth = false;
              worker[me].sparkpool.spark_count--;
              worker[me].waitingFishReplyFrom = -1;
            }
            chans[thiefID] ! SCHEDULE(me, worker[me].sparkpool.spark, null);
            
         :: chans[me] ? DENIED(thiefID, deniedSeq, null) ->
            worker[me].waitingSchedAuth = false;
            chans[thiefID] ! NOWORK(me, null, null) ;
            
         :: chans[me] ? OBSOLETE(thiefID, null, null) ->
            d_step {
              worker[me].waitingSchedAuth = false;
              worker[me].sparkpool.spark_count--;
              worker[me].waitingFishReplyFrom = -1;
            }
            chans[thiefID] ! NOWORK(me, null, null) ;
            
         :: chans[me] ? SCHEDULE(victimID, seq, null) -> /* We're being sent the spark */
            d_step {
              worker[me].sparkpool.spark_count++;
              worker[me].sparkpool.spark = seq ;
              spark.age++;
            }
            chans[3] ! ACK(me, seq, null) ; /* Send ACK To supervisor */
            
         :: chans[me] ? DEADNODE(deadNodeID, null, null) ->
            d_step {
              if
                :: worker[me].waitingFishReplyFrom > deadNodeID ->
                   worker[me].waitingFishReplyFrom = -1 ;
                :: else -> skip ;
              fi ;
            };
       fi ;
  fi;
  
  if
    :: (supervisor.ivar == 1) -> goto END;
    :: else -> goto WORKER_RECEIVE;
  fi;    
  
END:
  
} /* END OF WORKER */

/* propositional symbols */

#define ivar_full ( supervisor.ivar == 1 )
#define ivar_empty ( supervisor.ivar == 0 )
#define all_workers_alive ( !worker[0].dead && !worker[1].dead && !worker[2].dead )
#define all_workers_dead ( worker[0].dead && worker[1].dead && worker[2].dead )
#define any_result_sent ( supervisor.resultSent || worker[0].resultSent || worker[1].resultSent || worker[2].resultSent )

/* SPIN generated never claims corresponding to LTL formulae */

never  {    /* ! [] all_workers_alive */
T0_init:
  do
    :: d_step { (! ((all_workers_alive))) -> assert(!(! ((all_workers_alive)))) }
    :: (1) -> goto T0_init
  od;
accept_all:
  skip
}

never  {    /* ! [] (ivar_empty U any_result_sent) */
  skip;
T0_init:
  do
    :: (! ((any_result_sent))) -> goto accept_S4
    :: d_step { (! ((any_result_sent)) && ! ((ivar_empty))) -> assert(!(! ((any_result_sent)) && ! ((ivar_empty)))) }
    :: (1) -> goto T0_init
  od;
accept_S4:
  do
    :: (! ((any_result_sent))) -> goto accept_S4
    :: d_step { (! ((any_result_sent)) && ! ((ivar_empty))) -> assert(!(! ((any_result_sent)) && ! ((ivar_empty)))) }
  od;
accept_all:
  skip
}

never  {    /* ! <> [] ivar_full */
T0_init:
  do
    :: (! ((ivar_full))) -> goto accept_S9
    :: (1) -> goto T0_init
  od;
accept_S9:
  do
    :: (1) -> goto T0_init
  od;
}
