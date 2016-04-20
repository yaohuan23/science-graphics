#!/usr/bin/env Rscript
# This script plots continuous distributions.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

# Default input parameters (change them if run from source)
input = NA
output = NA
vars = NA
names = NA
type = NA
min = NA
max = NA
bin = NA
xlab = NA
ylab = NA
stats = NA

printSGheader("Continuous Distribution")

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
  make_option(c("-t", "--type"), type="character", default=type,
              help="Figure type (required) 
                      hist      - histogram
                      dens      - density
                      histdens  - density with underlying histogram
                      box       - box plot
                      violin    - violin plot",
              metavar="type"),
  make_option(c("-v", "--vars"), type="character", default=vars,
              help="Columns to use as variables. Comma separated
                    column names (as in the file) [default all]",
              metavar="variables"),
  make_option(c("-n", "--names"), type="character", default=names,
              help="Custom variable names, comma separated and in the
                    same order as vars [default column names]",
              metavar="names"),
  make_option("--min", type="numeric", default=min,
              help="The minimum value of the variable",
              metavar="minimum"),
  make_option("--max", type="numeric", default=max,
              help="The maximum value of the variable",
              metavar="maximum"),
  make_option("--bin", type="numeric", default=bin,
              help="Custom bin interval size for histograms",
              metavar="numeric"),
  make_option("--xlab", type="character", default=xlab,
              help="The x-axis label",
              metavar="label"),
  make_option("--ylab", type="character", default=ylab,
              help="The y-axis label",
              metavar="label"),
  make_option(c("-s", "--stats"), type="character", default=stats,
              help="Calculate and store distribution statistics",
              metavar="file")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs
if (is.na(opt$input) || is.na(opt$output) || is.na(opt$type)){
  cat("   ERROR: Missing required option (input, output or type)\n")
  stop()
}

# Parse the input file
data = parseFile(opt$input)

# Convert the comma separated inputs to vectors
if (!is.na(opt$vars)) {
  opt$vars = strsplit(opt$vars, ",", fixed=TRUE)[[1]]
} else {
  opt$vars = names(data)
}
if (!is.na(opt$names)) {
  opt$names = strsplit(opt$names, ",", fixed=TRUE)[[1]]
} else {
  opt$names = opt$vars
}
if (length(opt$vars) != length(opt$names)) {
  cat("   ERROR: Requested variables and names lengths differ\n")
  stop()
}

# Select the subset of the data that the user specified
if (length(opt$vars) <= ncol(data)) {
  data = data[opt$vars]
} else {
  cat("   ERROR: More requested variables than data columns\n")
  stop()
}

# Combine the columns into melted data frame [Value,Variable]
for (i in 1:ncol(data)) {
  variable = data.frame(data[[i]])
  variable$Variable = rep(opt$names[i], nrow(variable))
  names(variable)[1] = "Value"
  if (i == 1){
    melted = variable
  } else {
    melted = rbind(melted, variable)
  }
}
melted = melted[c(2,1)] # Switch order
melted[,1] = as.factor(melted[,1]) # Change to factor

if (!is.na(opt$stats)) {
  # Calculate and store statistics
  stats = calculateDistributionStats(melted)
  writeFile(stats, opt$stats)
}

# Create the plot depending on the type
p = switch(opt$type,
           hist = histogram(melted, opt$bin, opt$min, opt$max),
           dens = density(melted, opt$min, opt$max),
           histdens = histogramDensity(melted, opt$bin, opt$min, opt$max),
           box = boxPlot(melted, opt$min, opt$max),
           violin = violinBoxPlot(melted, opt$min, opt$max))

# Set the axis labels if given
if (!is.na(opt$xlab))
  p = p + xlab(opt$xlab)
if (!is.na(opt$ylab))
  p = p + ylab(opt$ylab)

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
