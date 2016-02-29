#!/usr/bin/env Rscript
# This script plots a DAG. The input file contains 2 mandatory columns,
# for specifying the edges
# Aleix Lafita - 03.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Networks.R")

printSGheader("Network Graph")

# Project name
project = "example8"
dir = TRUE

# Parse args if executed from the cmd line
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  cat("No arguments given.\n")
} else if (length(args)==1){
  project = args[1]
} else {
  project = args[1]
  dir = args[2]
}
cat(paste("Using arguments:", project, dir, "\n"))

data = parseFile(project)

# Saving procedure is different since it is not a ggplot
pdf(paste("../figures/", project, ".pdf", sep=""))
p = drawNetworkGraph(data, dir)
dev.off()

svg(paste("../figures/", project, ".svg", sep=""))
p = drawNetworkGraph(data, dir)
dev.off()
