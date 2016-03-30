#!/usr/bin/env Rscript
# This script plots the evolution of variables during a simulation.
# The input format should contain a first column with the Name/ID,
# a second column with the step/time value and one column for each 
# of the variables being recorded.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Evolution.R")
library(grid)

printSGheader("Evolution Plot")

# Project name
project = "example4"
points = TRUE
ranges = c()

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat(paste("No argument given\n"))
} else if (length(args)==1) {
  project = args[1]
} else if (length(args)==2) {
  project = args[1]
  points = as.logical(args[2])
} else {
  project = args[1]
  points = as.logical(args[2])
  ranges = as.numeric(args[-(1:2)])
}
cat(paste("Using arguments:", project, points, paste(ranges, collapse=" "), "\n"))

data = parseFile(project)

# Saving procedure is different since it is a grob object
pdf(paste("../figures/", project, ".pdf", sep=""))
p = multipleEvolutionPlot(data, points, ranges)
dev.off()

svg(paste("../figures/", project, ".svg", sep=""))
grid.draw(p)
dev.off()
