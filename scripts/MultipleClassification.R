#!/usr/bin/env Rscript
# The format of the data has to be in three columns, corresponding
# to Name, Truth, Prediction.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/InputOutput.R")
source("../source/Benchmarking.R")

# Project name
project = "example2"

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat("No argument given, using default project name...\n")
} else {
  project = args[1]
}

data = parseFile(project)

matrix = toConfusionMatrix(data[c(2,3)])
print(matrix)
writeResult(paste(project, "_confusionMatrix", sep=""), matrix)

p = plotConfusionMatrix(matrix)
saveFigure(project, p)