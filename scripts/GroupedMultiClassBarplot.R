#!/usr/bin/env Rscript
# This script plots frequency of each class for each group.
# The format of the input is in two columns, group name and class.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/InputOutput.R")
source("../source/Distribution.R")

# Default input parameters
project = "example5"

cat("##### GROUPED MULTICLASS BARPLOT #####\n")

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

p = stackedBarplot(data)
saveFigure(project, p)
