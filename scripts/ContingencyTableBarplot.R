#!/usr/bin/env Rscript
# This script calculates and plots the contingency table as a barplot
# from a collection of variable combinations.
# The format of the input is in two columns, one for each variable.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Correlation.R")

printSGheader("Contingency Table Barplot")

# Default input parameters
project = "example5"
valueType = "Percentage"
position = "stack"

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat("No arguments given\n")
} else if (length(args)==1) {
  project = args[1]
} else if (length(args)==2) {
  project = args[1]
  valueType = args[2]
} else {
  project = args[1]
  valueType = args[2]
  position = args[3]
}
cat(paste("Using arguments:", project, valueType, position, "\n"))

data = parseFile(project)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

p = plotContingencyTableBar(data, valueType, position)
saveFigure(project, p)
