#!/usr/bin/env Rscript
# This script plots the precision-recall curve of a ranking result. The 
# format of the file has to be in one columnwith a binary indication for
# non-relevant result (0) or relevant result (1). An extra column with
# result ID or Name can be given, but will be ignored.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Ranking.R")

printSGheader("Precision-Recall Curve")

# Project name
project = "example3"

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat(paste("No argument given\n"))
} else {
  project = args[1]
}
cat(paste("Using arguments:", project, "\n"))

data = parseFile(project)

if (ncol(data) > 1)
  data = data[2]

p = precisionRecallCurve(data)
saveFigure(project, p)