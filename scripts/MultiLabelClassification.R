#!/usr/bin/env Rscript
# This script plots the accuracy of the classifier for each label.
# The format of the data has to be in three columns, corresponding
# to Name, Truth, Prediction.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/DataParser.R")
source("../source/Benchmarking.R")

# USER OPTIONS
file = "example2"

# Parse the cmd line arguments
data = parseFile(file, commandArgs(trailingOnly=TRUE))

# Create the figure
p <- multiLabelPlot(data[c(2, 3)])

# Save the figure to the figures folder
savePDF(file, p)