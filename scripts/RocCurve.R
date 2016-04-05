#!/usr/bin/env Rscript
# This script plots the Receiver Operating Characteristic (ROC) curve
# of a classifier.
# The input needs 3 columns: algorithm (or metric), score and relevance.
# Relevance is either 1, relevant, or 0, irrelevant.
# A first column with the name can be given optionally.
# Aleix Lafita - 03.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Classification.R")

# Project name
file = "example_roc-curve"
format = "pdf"
xmin = 0
xmax = 100
ymin = 0
ymax = 100
threshold = NA
thresholds = NA

printSGheader("ROC Curve")

# Options for specific parameters of this plot

option_list = c(createOptionsIO(file, format),
  make_option("--xmin", type="numeric", default=xmin,
              help="The minimum value of the FP rate [default %default]",
              metavar="percentage"),
  make_option("--xmax", type="numeric", default=xmax,
              help="The maximum value of the FP rate [default %default]",
              metavar="percentage"),
  make_option("--ymin", type="numeric", default=ymin,
              help="The minimum value of the TP rate [default %default]",
              metavar="percentage"),
  make_option("--ymax", type="numeric", default=ymax,
              help="The maximum value of the TP rate [default %default]",
              metavar="percentage"),
  make_option(c("-t", "--threshold"), type="numeric", default=threshold,
              help="A score threshold for all curves",
              metavar="score"),
  make_option("--thresholds", type="character", default=thresholds,
              help="Individual score thresholds for each curve, comma separated",
              metavar="scores")
)
opt = parse_args(OptionParser(option_list=option_list))

# Split thresholds into a list
if (!is.na(opt$thresholds)){
  opt$thresholds = strsplit(opt$thresholds, ",", fixed=TRUE)
  opt$thresholds = as.list(as.numeric(opt$thresholds[[1]]))
}

data = parseFile(opt$input)

if (ncol(data) > 3)
  data = data[c(2,3,4)]

# Saving procedure is different since the R plot object is complex
# Consider using recordPlot in the future...
cat(paste("> Saving", opt$input, "to figures folder\n"))
if (grepl("pdf",opt$output)) {
  # PDF figure
  pdf(paste("../figures/", opt$input, ".pdf", sep=""))
  plotROCurve(data, opt$xmin, opt$xmax, opt$ymin, opt$ymax, opt$threshold,
              opt$thresholds)
  dev.off()
}
if (grepl("svg",opt$output)) {
  # SVG figure
  svg(paste("../figures/", opt$input, ".svg", sep=""))
  plotROCurve(data, opt$xmin, opt$xmax, opt$ymin, opt$ymax, opt$threshold,
              opt$thresholds)
  dev.off()
}
if (grepl("png", opt$output)) {
  # PNG figure
  png(paste("../figures/", opt$input, ".png", sep=""), 
      height = 4096, width = 4096, res = 600)
  plotROCurve(data, opt$xmin, opt$xmax, opt$ymin, opt$ymax, opt$threshold,
              opt$thresholds)
  dev.off()
}
