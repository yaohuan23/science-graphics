#!/usr/bin/env Rscript
# This script plots the density distribution of multiple variables.
# The density and underlying histogram of each variable are shown.
# The format of the input is in two columns, variable name and value.
# An additional name can be optionally given in the first column, but 
# it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

# Default input parameters
project = "example1"
binSize = 0
minX = NA
maxX = NA

printSGheader("Histogram Density Plot")

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat(paste("No argument given.\n"))
} else if (length(args)==1) {
  project = args[1]
} else if (length(args)==2) {
  project = args[1]
  binSize = as.double(args[2])
} else if (length(args)==3) {
  project = args[1]
  binSize = as.double(args[2])
  minX = as.double(args[3])
} else {
  project = args[1]
  binSize = as.double(args[2])
  minX = as.double(args[3])
  maxX = as.double(args[4])
}
cat(paste("Using arguments:", project, binSize, minX, maxX, "\n"))

data = parseFile(project)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

p = plotHistogramDensity(data, binSize, minX, maxX)
saveFigure(project, p)
