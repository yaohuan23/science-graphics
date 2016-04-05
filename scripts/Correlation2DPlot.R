#!/usr/bin/env Rscript
# This script plots the correlation of two variables as a point cloud.
# The format of the input is two column of value pairs (points).
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 03.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Correlation.R")

# Default input parameters
file = "example_correlation-2d"
format = "pdf"
shape = "x"
size = 5
xlab = NA
ylab = NA
ymin = NA
ymax = NA
xmin = NA
xmax = NA

printSGheader("Correlation 2D Plot")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option(c("-s", "--shape"), type="character", default=shape,
              help="The shape of the points (a character) [default %default]",
              metavar="character"),
  make_option("--size", type="numeric", default=size,
              help="The size of the points [default %default]",
              metavar="number"),
  make_option("--ymin", type="numeric", default=ymin,
              help="The minimum value of the y-axis variable",
              metavar="minimum"),
  make_option("--ymax", type="numeric", default=ymax,
              help="The maximum value of the y-axis variable",
              metavar="maximum"),
  make_option("--xmin", type="numeric", default=xmin,
              help="The minimum value of the x-axis variable",
              metavar="minimum"),
  make_option("--xmax", type="numeric", default=xmax,
              help="The maximum value of the x-axis variable",
              metavar="maximum"),
  make_option("--xlab", type="character", default=xlab,
              help="The x-axis label [default Column header]",
              metavar="label"),
  make_option("--ylab", type="character", default=ylab,
              help="The y-axis label [default Column header]",
              metavar="label")
)
opt = parse_args(OptionParser(option_list=option_list))

data = parseFile(opt$input)
if (ncol(data) > 3)
  data = data[c(2,3,4)]

p = plotCorrelation2D(data, opt$shape, opt$size)

# Adjust the y axis limits to min and max
if (!is.na(opt$ymin) || !is.na(opt$ymax)) {
  # Calculate limits if one not given
  if (is.na(opt$ymax))
    opt$ymax = max(data[2])
  if (is.na(opt$min))
    opt$ymin = min(data[2])
  p = p + coord_cartesian(ylim = c(opt$ymin, opt$ymax))
}

# Adjust the x axis limits to min and max
if (!is.na(opt$xmin) || !is.na(opt$xmax)) {
  # Calculate limits if one not given
  if (is.na(opt$xmax))
    opt$xmax = max(data[2])
  if (is.na(opt$xmin))
    opt$xmin = min(data[2])
  p = p + coord_cartesian(xlim = c(opt$xmin, opt$xmax))
}

# Set the axis labels if given
if (!is.na(opt$xlab))
  p = p + xlab(opt$xlab)
if (!is.na(opt$ylab))
  p = p + ylab(opt$ylab)

saveFigure(paste(opt$input, "correlation", sep="_"), p, opt$output)
