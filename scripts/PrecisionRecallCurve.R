#!/usr/bin/env Rscript
# This script plots the precision-recall curve of a ranking result. The 
# format of the file has to be in one columnwith a binary indication for
# non-relevant result (0) or relevant result (1). An extra column with
# result ID or Name can be given, but will be ignored.
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Ranking.R")

# Default input parameters
file = "example_pr-curve"
format = "pdf"

printSGheader("Precision-Recall Curve")

# Options for specific parameters of this plot
option_list = createOptionsIO(file, format)
opt = parse_args(OptionParser(option_list=option_list))

data = parseFile(opt$input)

if (ncol(data) > 1)
  data = data[2]

p = precisionRecallCurve(data)
saveFigure(paste(opt$input, "pr-curve", sep="_"), p, opt$output)
