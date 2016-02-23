#!/usr/bin/env Rscript
# Select a subset of the columns of a CSV file in the specified order
# Aleix Lafita - 02.2016

source("../source/ScienceGraphicsIO.R")

printSGheader("Select Columns")

project = "example1"
names = list()

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat(paste("No arguments given\n"))
} else {
  project = args[1]
  names = args[-1]
}
cat(paste("Using arguments:", project, paste(names, collapse=" "), "\n"))

data = parseFile(project)

if (length(names) <= ncol(data)) {
  data = data[names]
  writeData(paste(project, paste(names, collapse="_"), sep="_"), data)
} else {
  cat("ERROR: More input names than data columns\n")
}