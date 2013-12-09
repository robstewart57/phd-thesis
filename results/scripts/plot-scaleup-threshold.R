library(plyr)
library(ggplot2)
library(sqldf)
require(grid)

args <- commandArgs(trailingOnly = TRUE)
inputFile=args[1]
outputFile=args[2]
title=args[3]

if ( length(args) != 3) {
  stop("three arguments needed")
} else {

DF <- read.table(inputFile,header=TRUE)

cdata <- ddply(DF, .(Variant,Threshold), summarise, N = length(Runtime), mean=round(mean(Runtime),2), sd=round(sd(Runtime),2), se=round(sd(Runtime)/sqrt(length(Runtime)),2))

# helper
printf <- function(...)print(sprintf(...))

withOneNode <- function(variant){
  x <- sqldf(paste("select mean from cdata where Threshold == 1 and Variant = '", variant, "'", sep=""))
  return(x)
}

calcSpeedUp <- function(row){
    thisVariant <- row$Variant
    speedOnOneNode <- withOneNode(thisVariant)
    speedup <- round(speedOnOneNode / row$mean,2)
    row$speedup <- as.numeric(speedup)
    return (row)
}

pdf(paste(outputFile,"-runtime.pdf",sep=""))

# show runtime
bp <- ggplot(cdata, aes(x=Threshold, y=mean, group=Variant)) + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1) + geom_line(aes(linetype=Variant)) + geom_point(aes(shape=Variant)) + ylab("Runtime (Seconds)")  + labs(title = paste("Runtime for",title,sep=" "))
print(bp + theme_bw() + theme(legend.justification=c(1,1), legend.position=c(1,1), legend.key.width=unit(3,"line")))

dev.off()

cdata <- adply(cdata, 1, function (y) calcSpeedUp(y))

pdf(paste(outputFile,"-speedup.pdf",sep=""))

# show speedup
bp <- ggplot(cdata, aes(x=Threshold, y=speedup, group=Variant)) + geom_line(aes(linetype=Variant)) + geom_point(aes(shape=Variant)) + ylab("Speed Up") + labs(title = paste("Speedup for",title,sep=" "))
print(bp + theme_bw() + theme(legend.justification=c(1,0), legend.position=c(1,0), legend.key.width=unit(3,"line")))

write.table(cdata,file=paste(outputFile,".csv",sep=""),sep=",",row.names=F)

}

dev.off()
