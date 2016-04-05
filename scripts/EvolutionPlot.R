#!/usr/bin/env Rscript
# This script plots the evolution of variables during a simulation.
# The input format should contain a first column with the Name/ID,
# a second column with the step/time value and one column for each 
# of the variables being recorded.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Evolution.R")

# Default input parameters
file = "example_evolution"
format = "pdf"
points = TRUE
ranges = NA

printSGheader("Evolution Plot")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option("--ranges", type="character", default=ranges,
              help="Individual value ranges for each variable, alternating comma separated min,max",
              metavar="VALUES"),
  make_option("--points", action="store_true", default=points,
              help="Show the data points [default]"),
  make_option("--nopoints", action="store_false", dest="points",
              help="Do not show the data points")
)
opt = parse_args(OptionParser(option_list=option_list))

# Split ranges into a list
if (!is.na(opt$ranges)){
  opt$ranges = strsplit(opt$ranges, ",", fixed=TRUE)
  opt$ranges = as.numeric(opt$ranges[[1]])
} else {
  opt$ranges = c()
}

data = parseFile(opt$input)

# Saving procedure is different since it is a grob object
# Consider using recordPlot in the future...
cat(paste("> Saving", opt$input, "to figures folder\n"))
if (grepl("pdf",opt$output)) {
  # PDF figure
  pdf(paste("../figures/", opt$input, "_evolution.pdf", sep=""))
  multipleEvolutionPlot(data, opt$points, opt$ranges)
  log = dev.off() # This supresses printing 'null device'
}
if (grepl("svg",opt$output)) {
  # SVG figure
  svg(paste("../figures/", opt$input, "_evolution.svg", sep=""))
  multipleEvolutionPlot(data, opt$points, opt$ranges)
  log = dev.off() # This supresses printing 'null device'
}
if (grepl("png", opt$output)) {
  # PNG figure
  png(paste("../figures/", opt$input, "_evolution.png", sep=""), 
      height = 4096, width = 4096, res = 600)
  multipleEvolutionPlot(data, opt$points, opt$ranges)
  log = dev.off() # This supresses printing 'null device'
}
