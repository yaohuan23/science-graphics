#!/usr/bin/env Rscript
# This script plots the precision-recall curve of a ranking result. 
# The format is a single column sorted in ranking order with a binary 
# indication for relevance (non-relevant = 0, relevant = 1).
# Aleix Lafita - 01.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Ranking.R")

# Default input parameters
input = NA
output = NA
var = NA
pmin = NA
pmax = NA
rmin = NA
rmax = NA

printSGheader("Precision-Recall Curve")

# Options for specific parameters of this plot
option_list = c(
  make_option(c("-i", "--input"), type="character", default=input,
              help="Input CSV or TSV data file. Each column contains
                    a variable with its name as header (required)",
              metavar="file"),
  make_option(c("-o", "--output"), type="character", default=output,
              help="Output figure file. Supported pdf, svg and png
                    extensions (required)",
              metavar="file"),
  make_option(c("-v", "--var"), type="character", default=var,
              help="Column to use as relevance (header) [default first]",
              metavar="variable"),
  make_option("--pmin", type="numeric", default=pmin,
              help="The minimum value of the precision [default 0]",
              metavar="minimum"),
  make_option("--pmax", type="numeric", default=pmax,
              help="The maximum value of the precision [default 1]",
              metavar="maximum"),
  make_option("--rmin", type="numeric", default=rmin,
              help="The minimum value of the recall [default 0]",
              metavar="minimum"),
  make_option("--rmax", type="numeric", default=rmax,
              help="The maximum value of the recall [default 1]",
              metavar="maximum")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs
if (is.na(opt$input) || is.na(opt$output)){
  cat("   ERROR: Missing required option (input or output)\n")
  stop()
}

data = parseFile(opt$input)

# Select the subset of the data that the user specified
if (is.na(opt$var))
  opt$var = names(data)[1]
data = data[opt$var]

p = precisionRecallCurve(data)

# Adjust the precision and recall axis limits
if (!is.na(opt$pmin) || !is.na(opt$pmax)) {
  # Calculate limits if one not given
  if (is.na(opt$pmax))
    opt$pmax = 1
  if (is.na(opt$pmin))
    opt$pmin = 0
  p = p + coord_cartesian(ylim = c(opt$pmin, opt$pmax))
}
if (!is.na(opt$rmin) || !is.na(opt$rmax)) {
  # Calculate limits if one not given
  if (is.na(opt$rmax))
    opt$rmax = 1
  if (is.na(opt$rmin))
    opt$rmin = 0
  p = p + coord_cartesian(ylim = c(opt$rmin, opt$rmax))
}

# Save the plot as a figure
if (grepl(".pdf",opt$output)) {
  pdf(opt$output)
} else if (grepl(".svg",opt$output)) {
  svg(opt$output)
} else if (grepl(".png", opt$output)) {
  png(opt$output, height = 4096, width = 4096, res = 600)
} else {
  cat("   ERROR: Unsupported figure format requested\n")
  stop()
}
print(p)
log = dev.off() # Supress printing 'null device'
cat(paste("   Saved figure to", opt$output, "\n"))
