library(plyr)
library(ggplot2)
library(sqldf)
library(gtable)
library(grid)

args <- commandArgs(trailingOnly = TRUE)
inputFile=args[1]
outputFile=args[2]

if ( length(args) != 2) {
  stop("two arguments needed")
} else {

DF <- read.table(inputFile,header=TRUE)

cdata <- ddply(DF, .(Variant,Threshold), summarise, N = length(Runtime), mean=mean(Runtime), sd=sd(Runtime), se=sd(Runtime)/sqrt(length(Runtime)))

pdf(paste(outputFile,"-threshold.pdf",sep=""))

# show runtime
bp <- ggplot(cdata, aes(x=Threshold, y=mean, colour=Variant)) + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1) + geom_line() + geom_point() + ylab("Runtime (Seconds)")
print(bp + theme(legend.justification=c(1,1), legend.position=c(1,1)))

}

dev.off()
