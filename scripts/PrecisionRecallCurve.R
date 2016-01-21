#!/usr/bin/env Rscript
# This script plots the precision-recall curve of a ranking result.
# The format of the file has to be in two columns: ID and [0,1], where
# 0 means non-relevant result and 1 means relevant result.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/InputOutput.R")
source("../source/Benchmarking.R")

# Project name
project = "example3"

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat("No argument given, using default project name...\n")
} else {
  project = args[1]
}

data = parseFile(project)

p = precisionRecallCurve(data[2])
saveFigure(project, p)