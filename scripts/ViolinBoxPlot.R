#!/usr/bin/env Rscript
# This script plots the data distribution of multiple variables as 
# a violin plot with an underlying box plot and a point in the median.
# The format of the input is in two columns, variable name and value.
# An additional name can be optionally given in the first column, but 
# it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

# Default input parameters
file = "example_continuous-distribution"
format = "pdf"
xlab = NA
ylab = NA
ymin = NA
ymax = NA
stats = TRUE

printSGheader("Violin Box Plot")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option("--min", type="numeric", default=ymin,
              help="The minimum value of the variable",
              metavar="minimum"),
  make_option("--max", type="numeric", default=ymax,
              help="The maximum value of the variable",
              metavar="maximum"),
  make_option("--xlab", type="character", default=xlab,
              help="The x-axis label [default Column header]",
              metavar="label"),
  make_option("--ylab", type="character", default=ylab,
              help="The y-axis label [default Column header]",
              metavar="label"),
  make_option("--stats", action="store_true", default=stats,
              help="Calculate and store distribution statistics [default]"),
  make_option("--nostats", action="store_false", dest="stats",
              help="Do not calculate distribution statistics")
)
opt = parse_args(OptionParser(option_list=option_list))

data = parseFile(opt$input)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

if (opt$stats) {
  # Calculate and store statistics
  stats = calculateDistributionStats(data)
  writeResult(paste(opt$input, "stats", sep="_"), stats)
}

# Create the plot
p = violinBoxPlot(data)

# Adjust the y axis limits to min and max
if (!is.na(opt$min) || !is.na(opt$max)) {
  # Calculate limits if one not given
  if (is.na(opt$max))
    opt$max = max(data[2])
  if (is.na(opt$min))
    opt$min = min(data[2])
  p = p + coord_cartesian(ylim = c(opt$min, opt$max))
}

# Set the axis labels if given
if (!is.na(opt$xlab))
  p = p + xlab(opt$xlab)
if (!is.na(opt$ylab))
  p = p + ylab(opt$ylab)

saveFigure(paste(opt$input, "violinplot", sep="_"), p, opt$output)
