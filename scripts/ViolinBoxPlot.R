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

printSGheader("Violin Box Plot")

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat(paste("No argument given.\n"))
} else {
  project = args[1]
}
cat(paste("Using arguments:", project, "\n"))

data = parseFile(project)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

p = violinBoxPlot(data)
saveFigure(project, p)
