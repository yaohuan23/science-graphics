#!/usr/bin/env Rscript
# Rename the columns of a CSV file
# Aleix Lafita - 02.2016

source("../source/ScienceGraphicsIO.R")

printSGheader("Rename Columns")

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

if (length(names) == ncol(data)) {
  names(data) = names
  writeData(paste(project, "renamed", sep="_"), data)
} else {
  cat("ERROR: Input names do not match data columns\n")
}