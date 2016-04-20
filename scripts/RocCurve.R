#!/usr/bin/env Rscript
# This script plots the Receiver Operating Characteristic (ROC) curve
# of a binary classifier with positive and negative classes.
# If a single file is provided, an additional column with status has
# to be provided to indicate positive (1) or negative (0) cases.
# Cases can also be split into positive and negative files.
# Aleix Lafita - 03.2016

# Import all the source files and libraries needed
source("../source/ScienceGraphicsIO.R")
suppressPackageStartupMessages(library(ROCR))
suppressPackageStartupMessages(library(RColorBrewer))

# Project name
pos = NA
neg = NA
input = NA
output = NA
methods = NA
names = NA
status = NA
tpMin = 0
tpMax = 100
fpMin = 0
fpMax = 100
thrs = NA

printSGheader("ROC Curve")

# Options for specific parameters of this plot
option_list = c(
  make_option(c("-i", "--input"), type="character", default=input,
              help="Input CSV or TSV data file (easyROC). Each column has the
                    scores of a method and an extra column indicates the 
                    status, either positive[1] or negative[0] (required)",
              metavar="file"),
  make_option(c("-p", "--pos"), type="character", default=pos,
              help="Input CSV or TSV data file with positive set (StAR). 
                    Each column has the score for each method (required)",
              metavar="file"),
  make_option(c("-n", "--neg"), type="character", default=neg,
              help="Input CSV or TSV data file with negative set (StAR). 
                    Each column has the score for each method (required)",
              metavar="file"),
  make_option(c("-o", "--output"), type="character", default=output,
              help="Output figure file. Supported pdf, svg and png
                    extensions (required)",
              metavar="file"),
  make_option(c("-m", "--methods"), type="character", default=methods,
              help="Columns to use as methods. Comma separated
                    column headers (as in the file) [default all]",
              metavar="methods"),
  make_option("--names", type="character", default=names,
              help="Custom method names. Comma separated and in the
                    same order as methods [default methods]",
              metavar="names"),
  make_option(c("-s","--status"), type="character", default=status,
              help="The header of the status column (easyROC) (required)",
              metavar="column"),
  make_option("--tpMin", type="numeric", default=tpMin,
              help="The minimum value of the TP rate [default %default]",
              metavar="percentage"),
  make_option("--tpMax", type="numeric", default=tpMax,
              help="The maximum value of the TP rate [default %default]",
              metavar="percentage"),
  make_option("--fpMin", type="numeric", default=fpMin,
              help="The minimum value of the FP rate [default %default]",
              metavar="percentage"),
  make_option("--fpMax", type="numeric", default=fpMax,
              help="The maximum value of the FP rate [default %default]",
              metavar="percentage"),
  make_option(c("-t", "--thrs"), type="character", default=thrs,
              help="Individual score thresholds for each curve, comma 
                    separated (minimum one for each method)",
              metavar="scores")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs and which type of plot
if (is.na(opt$output)){
  cat("   ERROR: Missing required option: output\n")
  stop()
}
if ((!is.na(opt$pos) && !is.na(opt$neg)) && !is.na(opt$input)){
  cat("   ERROR: Extra option: either input (easyROC) or pos and neg (StAR)\n")
  stop()
}
if (is.na(opt$pos) || is.na(opt$neg)){
  if (is.na(opt$input)){
    cat("   ERROR: Missing required option: either input or pos and neg\n")
    stop()
  } else if (is.na(opt$status)){
    cat("   ERROR: Missing required option: status\n")
    stop()
  }
}

# Handle the parsing depending if the format is StAR or easyROC
if (!is.na(opt$input)){
  data = parseFile(opt$input)
  data[[opt$status]] = as.numeric(data[[opt$status]])
  positive = data[which(data[[opt$status]] == 1),]
  negative = data[which(data[[opt$status]] == 0),]
  positive = positive[, !(names(positive) %in% c(opt$status))]
  negative = negative[, !(names(negative) %in% c(opt$status))]
} else {
  positive = parseFile(opt$pos)
  negative = parseFile(opt$neg)
}

# Convert the comma separated inputs to vectors
if (!is.na(opt$methods)) {
  opt$methods = strsplit(opt$methods, ",", fixed=TRUE)[[1]]
} else {
  opt$methods = names(positive)
}
if (!is.na(opt$names)) {
  opt$names = strsplit(opt$names, ",", fixed=TRUE)[[1]]
} else {
  opt$names = opt$methods
}
if (length(opt$methods) != length(opt$names)) {
  cat("   ERROR: Requested methods and names lengths differ\n")
  stop()
}

# Select the subset of the data that the user specified
if (length(opt$methods) <= ncol(positive)) {
  positive = positive[opt$methods]
} else {
  cat("   ERROR: More requested methods than data columns\n")
  stop()
}
if (length(opt$methods) <= ncol(negative)) {
  negative = negative[opt$methods]
} else {
  cat("   ERROR: More requested methods than data columns\n")
  stop()
}

# Split thresholds into a list, empty vector if NA
if (!is.na(opt$thrs)){
  opt$thrs = strsplit(opt$thrs, ",", fixed=TRUE)
  opt$thrs = as.list(as.numeric(opt$thrs[[1]]))
  if (length(opt$thrs) < ncol(positive)) {
    cat("   ERROR: Not enough thresholds (one per method)\n")
    stop()
  }
} else {
  opt$thrs = c()
}

# Format data into ROCR input
scores = rbind(positive, negative)
labels = replicate(ncol(positive),c(rep(1,nrow(positive)), 
                                    rep(0,nrow(negative))))

# Use ROCR to calculate the plot points
pred = prediction(scores, labels)
perf = performance(pred, measure = "tpr", x.measure = "fpr")

# Saving figure format and file setting
if (grepl(".pdf",opt$output)) {
  pdf(opt$output)
} else if (grepl(".svg",opt$output)) {
  svg(opt$output)
} else if (grepl(".png", opt$output)) {
  png(opt$output, height = 4096, width = 4096, res = 600)
} else {
  cat("   ERROR: Unsupported figure format requested\n")
  stop()
}

# Some variables as helper to simplify syntax
colors = brewer.pal(max(length(opt$names),3), "Set1")
xmin = opt$fpMin
xmax = opt$fpMax
ymin = opt$tpMin
ymax = opt$tpMax

# Generate the plot with all parameters
plot(perf,
     col=as.list(colors),
     xaxs="i", yaxs="i",
     xlim=c(xmin/100, xmax/100),
     ylim=c(ymin/100, ymax/100),
     xaxis.at=seq(xmin/100,xmax/100, (xmax-xmin)/1000),
     xaxis.labels=paste(seq(xmin,xmax,(xmax-xmin)/10),"%",sep=""),
     yaxis.at=seq(ymin/100,ymax/100, (ymax-ymin)/1000),
     yaxis.labels=paste(seq(ymin,ymax,(ymax-ymin)/10),"%",sep=""),
     yaxis.las=1,
     points.col=as.list(colors),
     points.pch=20,
     points.cex=2.0,
     print.cutoffs.at=opt$thrs,
     cutoff.label.function=function(x) { "" },
     lwd=2)
legend("bottomright",
       opt$names,
       col=colors,
       lwd=2,
       cex=.9,
       inset=c(.1,.05))

log = dev.off() # Supress printing 'null device'
cat(paste("   Saved figure to", opt$output, "\n"))
