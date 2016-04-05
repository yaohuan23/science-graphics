#!/usr/bin/env Rscript
# This script plots the density distribution of multiple variables.
# The density and underlying histogram of each variable are shown.
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
binSize = 0
xlab = NA
ylab = NA
xmin = NA
xmax = NA
stats = TRUE

printSGheader("Histogram Density Plot")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option("--bin", type="numeric", default=binSize,
              help="The bin size [default range/min(points/variables,30)]",
              metavar="numeric"),
  make_option("--min", type="numeric", default=xmin,
              help="The minimum value of the variable",
              metavar="minimum"),
  make_option("--max", type="numeric", default=xmax,
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
p = plotHistogramDensity(data, opt$bin)

# Adjust the y axis limits to min and max
if (!is.na(opt$min) || !is.na(opt$max)) {
  # Calculate limits if one not given
  if (is.na(opt$max))
    opt$max = max(data[2])
  if (is.na(opt$min))
    opt$min = min(data[2])
  p = p + coord_cartesian(xlim = c(opt$min, opt$max))
}

# Set the axis labels if given
if (!is.na(opt$xlab))
  p = p + xlab(opt$xlab)
if (!is.na(opt$ylab))
  p = p + ylab(opt$ylab)

saveFigure(paste(opt$input, "density", sep="_"), p, opt$output)
