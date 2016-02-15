#!/usr/bin/env Rscript
# Calculate and plot a confusion matrix from a multiple class classifier
# result. The format of the input has to be in three columns:
# c(Name, Actual, Prediction)
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/InputOutput.R")
source("../source/Classification.R")

# Project name
project = "example2"

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat(paste("No argument given, using", project, "\n"))
} else {
  project = args[1]
}

data = parseFile(project)

matrix = toConfusionMatrix(data[c(2,3)])
writeResult(paste(project, "_confusionMatrix", sep=""), matrix)

p = plotConfusionMatrix(matrix)
saveFigure(project, p)