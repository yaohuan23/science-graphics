#!/usr/bin/env Rscript
# This script plots the precision-recall curve of a ranking result.
# The format of the file has to be in two columns: ID and [0,1], where
# 0 means non-relevant result and 1 means relevant result.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/DataParser.R")
source("../source/Benchmarking.R")

# USER OPTIONS
file = "example3"

# Parse the cmd line arguments
data = parseFile(file, commandArgs(trailingOnly=TRUE))

# Create the figure
p <- precisionRecallCurve(data[2])

# Save the figure to the figures folder
savePDF(file, p)