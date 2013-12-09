library(plyr)
library(ggplot2)

args <- commandArgs(trailingOnly = TRUE)
inputFile=args[1]
outputFile=args[2]

if ( length(args) != 2) {
  stop("TWO arguments needed")
} else {

#write(inputFile,stdout())
#write(outputFile,stdout())

DF <- read.table(inputFile,header=TRUE)

cdata <- ddply(DF, .(Variant,Nodes), summarise, N = length(Runtime), mean=mean(Runtime), sd=sd(Runtime), se=sd(Runtime)/sqrt(length(Runtime)))

pdf(outputFile)
bp <- ggplot(cdata, aes(x=Nodes, y=mean, colour=Variant, linetype=Variant, ymin=(min(cdata["mean"])-10),ymax=(max(cdata["mean"])+10))) + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1) + geom_line() + geom_point() + ylab("Runtime (Seconds)")

bp + theme(legend.justification=c(1,1), legend.position=c(1,1))

}

dev.off()
