library(plyr)
library(ggplot2)
library(sqldf)
require(grid)

args <- commandArgs(trailingOnly = TRUE)
inputFile=args[1]
outputFile=args[2]
title=args[3]
failureFreeLazy=args[4]
failureFreeLazySkel=args[5]
failureFreeEager=args[6]
failureFreeEagerSkel=args[7]

#if ( length(args) != 4) {
#  stop("four arguments needed")
#} else {

DF <- read.table(inputFile,header=TRUE)

cdata <- ddply(DF, .(Variant,TimeOfFail), summarise, N = length(Runtime), mean=round(mean(Runtime),2), sd=round(sd(Runtime),2), se=round(sd(Runtime)/sqrt(length(Runtime)),2))



pdf(paste(outputFile,"-runtime.pdf",sep=""))

# show runtime
bp <- ggplot(cdata, aes(x=TimeOfFail, y=mean, group=Variant)) + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1) + geom_line(aes(linetype=Variant)) + geom_point(aes(shape=Variant)) + ylab("Runtime (Seconds)") + xlab("Time of Simultanous 5 Node Failure (Seconds)") + labs(title = paste("Runtime for",title,sep=" ")) + geom_hline(yintercept = as.numeric(failureFreeLazy), linetype="dashed") + annotate("text", min(15), as.numeric(failureFreeLazy)+3, label = failureFreeLazySkel,size=3) + geom_hline(yintercept = as.numeric(failureFreeEager), linetype="dashed") + annotate("text", min(15), as.numeric(failureFreeEager)+3, label = failureFreeEagerSkel,size=3)

print(bp + theme_bw()  + theme(legend.justification=c(1,1), legend.position=c(1,1), legend.key.width=unit(3,"line")))

write.table(cdata,file=paste(outputFile,"-timeoffailure.csv",sep=""),sep=",",row.names=F)

# }

dev.off()
