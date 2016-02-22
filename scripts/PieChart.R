#!/usr/bin/env Rscript
# This script plots the frequency of each level of a factor variable
# from a collection of observables as a pie chart.
# The format of the input is one column of factor observations.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

printSGheader("Pie Chart")

# Default input parameters
project = "example6"

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat("No arguments given\n")
} else if (length(args)==1) {
  project = args[1]
}
cat(paste("Using arguments:", project, "\n"))

data = parseFile(project)
if (ncol(data) > 1){
  data = data[2]
}

# Calulate frequency table and store to results
table = toFrequencyTable(data)
print(table)
writeResult(paste(project, "frequencyTable", sep="_"), table)

p = pieChart(data)
saveFigure(project, p)
