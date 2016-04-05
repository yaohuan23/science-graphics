#!/usr/bin/env Rscript
# This script plots the frequency of each level of a factor variable
# from a collection of observables as a pie chart.
# The format of the input is one column of factor observations.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

# Default input parameters
file = "example_discrete-distribution-single"
format = "pdf"
stats = TRUE

printSGheader("Pie Chart")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option("--stats", action="store_true", default=stats,
              help="Calculate and store distribution statistics [default]"),
  make_option("--nostats", action="store_false", dest="stats",
              help="Do not calculate distribution statistics")
)
opt = parse_args(OptionParser(option_list=option_list))

data = parseFile(opt$input)
if (ncol(data) > 1)
  data = data[2]

if (opt$stats) {
  # Calulate frequency table and store to results
  table = toFrequencyTable(data)
  writeResult(paste(opt$input, "freq-table", sep="_"), table)
}

p = pieChart(data)
saveFigure(paste(opt$input, "pie-chart", sep="_"), p, opt$output)
