#!/usr/bin/env Rscript
# Calculate and plot a confusion matrix of a multiple class classifier
# result. 
# The format of the input has to be in two columns: Actual and 
# Prediction, respectively.
# An additional Name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/InputOutput.R")
source("../source/Classification.R")

# Default inputs
project = "example2"
labelSize = 4

cat("##### CONFUSION MATRIX PLOT #####")

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  cat("No arguments given.\n")
} else if (length(args)==1) {
  project = args[1]
} else {
  project = args[1]
  labelSize = strtoi(args[2])
}
cat(paste("Using arguments:", project, labelSize, "\n"))

# data = [Name] Actual Prediction
data = parseFile(project)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

# Calculate and wrtie confusion matrix
matrix = toConfusionMatrix(data)
writeResult(paste(project, "_confusionMatrix", sep=""), matrix)

p = plotConfusionMatrix(matrix, labelSize)
saveFigure(project, p)
