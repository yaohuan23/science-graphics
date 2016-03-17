#!/usr/bin/env Rscript
# This script plots the Receiver Operating Characteristic (ROC) curve
# of a classifier.
# The input needs 3 columns: algorithm (or metric), score and relevance.
# Relevance is either 1, relevant, or 0, irrelevant.
# A first column with the name can be given optionally.
# Aleix Lafita - 03.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Classification.R")

printSGheader("ROC Curve")

# Project name
project = "example10"
xn = 0
xx = 100
yn = 0
yx = 100
thres = c()

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat(paste("No argument given\n"))
} else if (length(args)==1) {
  project = args[1]
} else if (length(args)==2) {
  project = args[1]
  xn = as.numeric(args[2])
} else if (length(args)==3) {
  project = args[1]
  xn = as.numeric(args[2])
  xx = as.numeric(args[3])
} else if (length(args)==4) {
  project = args[1]
  xn = as.numeric(args[2])
  xx = as.numeric(args[3])
  yn = as.numeric(args[4])
} else if (length(args)==5) {
  project = args[1]
  xn = as.numeric(args[2])
  xx = as.numeric(args[3])
  yn = as.numeric(args[4])
  yx = as.numeric(args[5])
} else {
  project = args[1]
  xn = as.numeric(args[2])
  xx = as.numeric(args[3])
  yn = as.numeric(args[4])
  yx = as.numeric(args[5])
  thres = as.numeric(args[-(1:5)])
}
cat(paste("Using arguments:", project, xn, xx, yn, yx,
          paste(thres, collapse=" "), "\n"))

data = parseFile(project)

if (ncol(data) > 3)
  data = data[c(2,3,4)]

# Saving procedure is different since it is not a ggplot object
pdf(paste("../figures/", project, ".pdf", sep=""))
p = plotROCurve(data, xn, xx, yn, yx, as.list(thres))
dev.off()

svg(paste("../figures/", project, ".svg", sep=""))
p = plotROCurve(data, xn, xx, yn, yx, as.list(thres))
dev.off()
