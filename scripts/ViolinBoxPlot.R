#!/usr/bin/env Rscript
# This script plots the data distribution of multiple variables as 
# a violin plot with an underlying box plot and a point in the median.
# The format of the input is in two columns, variable name and value.
# An additional name can be optionally given in the first column, but 
# it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

# Default input parameters
project = "example7"
ymin = NA
ymax = NA
scaling = "width"

printSGheader("Violin Box Plot")

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat(paste("No argument given.\n"))
} else if (length(args)==1) {
  project = args[1]
} else if (length(args)==2) {
  project = args[1]
  ymin = as.double(args[2])
} else if (length(args)==3) {
  project = args[1]
  ymin = as.double(args[2])
  ymax = as.double(args[3])
} else {
  project = args[1]
  ymin = as.double(args[2])
  ymax = as.double(args[3])
  scaling = args[4]
}
cat(paste("Using arguments:", project, ymin, ymax, scaling, "\n"))

data = parseFile(project)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

# Calculate and store statistics
stats = toDistributionStats(data)
writeResult(paste(project, "stats", sep="_"), stats)

p = violinBoxPlot(data, ymin, ymax, scaling)
saveFigure(paste(project, "violinplot", sep="_"), p)
