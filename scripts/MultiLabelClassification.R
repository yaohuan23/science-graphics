#!/usr/bin/env Rscript
# This script plots the accuracy of the classifier for each label.
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

table = toClassificationTable(data[c(2, 3)])
writeResult(paste(project, "_class_table", sep=""), table)

p = multiLabelPlot(table)
saveFigure(project, p)