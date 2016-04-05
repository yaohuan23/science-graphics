#!/usr/bin/env Rscript
# This script calculates and plots the contingency table as a barplot
# from a collection of variable combinations.
# The format of the input is in two columns, one for each variable.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Correlation.R")

# Default input parameters
file = "example_discrete-distribution-multiple"
format = "pdf"
value = "Percentage"
position = "dodge"

printSGheader("Contingency Table Barplot")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option(c("-v", "--value"), type="character", default=value,
              help="The value plotted on the y axis, either Percentage or Frequency [default %default]",
              metavar="type"),
  make_option(c("-p", "--position"), type="character", default=position,
              help="The position of the bars, either stack or dodge [default %default]",
              metavar="type")
)
opt = parse_args(OptionParser(option_list=option_list))

data = parseFile(opt$input)
if (ncol(data) > 2)
  data = data[c(2,3)]

p = plotContingencyTableBar(data, opt$value, opt$position)
saveFigure(paste(opt$input, "boxplot", sep="_"), p, opt$output)
