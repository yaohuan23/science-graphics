#!/usr/bin/env Rscript
# Script to combine different datasets into a single file
# with a different factor for each dataset
# Aleix Lafita - 02.2016

source("../source/ScienceGraphicsIO.R")

printSGheader("Combine Data")

projects = list()
factors = list()

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat(paste("No arguments given\n"))
} else {
  n = length(args)
  if (n %% 2 == 0) {
    projects = args[1:(n/2)] # first half file names
    factors = args[-(1:(n/2))] # second half factor names
  }
}
cat(paste("Using arguments:", paste(projects, collapse=" "), 
          paste(factors, collapse=" "), "\n"))

# Parse all the files
files = list()
for (i in 1:length(projects)) {
  data = parseFile(projects[i])
  data$Factor = rep(factors[i], nrow(data))
  if (i == 1){
    result = data
  } else {
    result = rbind(result, data)
  }
}

writeData(paste(projects[1], paste(factors, collapse="_"), sep="_"), result)
