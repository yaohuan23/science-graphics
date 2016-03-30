#!/usr/bin/env Rscript
# Calculate and plot a confusion matrix of a multiple class classifier
# result. 
# The format of the input is in two columns, actual and predicted class.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Classification.R")

# Default input parameters
project = "example2"
labelSize = 4

printSGheader("Confusion Matrix Plot")

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

# Calculate the Cramer V coefficient and precison
cv = cv.test(data[[1]],data[[2]])
pr = precision(data)
cat(paste("##   Cramér V/Phi: ", cv, "\n"))
cat(paste("##   Precision:    ", pr, "\n"))

p = plotConfusionMatrix(matrix, labelSize)
saveFigure(project, p)
