#!/usr/bin/env Rscript
# This script plots the correlation of two variables as a point cloud.
# The format of the input is two column of value pairs (points).
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 03.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Correlation.R")

# Default input parameters
project = "example9"
pointShape = "x"
pointSize = 5

printSGheader("Correlation 2D Plot")

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat(paste("No arguments given.\n"))
} else if (length(args)==1) {
  project = args[1]
} else if (length(args)==2) {
  project = args[1]
  pointShape = as.character(args[2])
} else if (length(args)==3) {
  project = args[1]
  pointShape = as.character(args[2])
  pointSize = as.integer(args[3])
} 
cat(paste("Using arguments:", project, pointShape, pointShape, "\n"))

data = parseFile(project)
if (ncol(data) > 3){
  data = data[c(2,3,4)]
}

p = plotCorrelation2D(data, pointShape, pointSize)
saveFigure(project, p)
