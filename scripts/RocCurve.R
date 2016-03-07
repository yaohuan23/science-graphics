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

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat(paste("No argument given\n"))
} else {
  project = args[1]
}
cat(paste("Using arguments:", project, "\n"))

data = parseFile(project)

if (ncol(data) > 3)
  data = data[c(2,3,4)]

# Saving procedure is different since it is not a ggplot object
pdf(paste("../figures/", project, ".pdf", sep=""))
p = plotROCurve(data)
dev.off()

svg(paste("../figures/", project, ".svg", sep=""))
p = plotROCurve(data)
dev.off()
