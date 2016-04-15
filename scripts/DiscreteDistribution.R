#!/usr/bin/env Rscript
# This script plots the frequency of each level/class of a factor 
# variable from a collection of observables.
# The format of the input is one column of factor observations.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Distribution.R")

# Default input parameters
input = NA
output = NA
var = NA
name = NA
type = NA
min = NA
max = NA
table = NA

printSGheader("Discrete Distribution")

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
                      pie   - pie chart (percentage, relative)
                      bar   - bar plot (frequency, absolute)",
              metavar="type"),
  make_option(c("-v", "--var"), type="character", default=var,
              help="Column to use as variable (header) [default first]",
              metavar="variable"),
  make_option(c("-n", "--name"), type="character", default=name,
              help="Custom variable name [default column name]",
              metavar="name"),
  make_option("--min", type="numeric", default=min,
              help="The minimum value of the variable",
              metavar="minimum"),
  make_option("--max", type="numeric", default=max,
              help="The maximum value of the variable",
              metavar="maximum"),
  make_option("--table", type="character", default=table,
              help="Calculate and store distribution statistics",
              metavar="file")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs
if (is.na(opt$input) || is.na(opt$output) || is.na(opt$type)){
  cat("   ERROR: Missing required option (input, output or type)\n")
  stop()
}

data = parseFile(opt$input)

# Select the subset of the data that the user specified
if (is.na(opt$var))
  opt$var = names(data)[1]
if (is.na(opt$name))
  opt$name = opt$var

data = data[opt$var]

if (!is.na(opt$table)) {
  # Calulate frequency table and store to results
  table = toFrequencyTable(data)
  writeResult(opt$table, table)
}

p = switch(opt$type,
           pie = pieChart(data, opt$name),
           bar = barPlot(data, opt$name, opt$min, opt$max))

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
