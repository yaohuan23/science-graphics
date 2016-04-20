#!/usr/bin/env Rscript
# This script represents a collection discrete variable pair observables
# as a barplot.
# It is used to visually represent contingency tables.
# The format of the input is in two columns, one for each variable.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Correlation.R")

# Default input parameters
input = NA
output = NA
vars = NA
names = NA
value = "Percentage"
position = "dodge"
min = NA
max = NA
stats = NA

printSGheader("Contingency Table BarPlot")

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
  make_option("--value", type="character", default=value,
              help="The value on the y axis, either Percentage (relative)
                    or Frequency (absolute) [default %default]",
              metavar="type"),
  make_option(c("-p", "--position"), type="character", default=position,
              help="The position of the bars, either stack or dodge 
                    [default %default]",
              metavar="type"),
  make_option(c("-v", "--vars"), type="character", default=vars,
              help="Columns to use as variables. Comma separated
                    column names (as in the file) [default all]",
              metavar="variables"),
  make_option(c("-n", "--names"), type="character", default=names,
              help="Custom variable names to show in the figure, 
                    comma separated [default column names]",
              metavar="names"),
  make_option("--min", type="numeric", default=min,
              help="The minimum value of the variable",
              metavar="minimum"),
  make_option("--max", type="numeric", default=max,
              help="The maximum value of the variable",
              metavar="maximum"),
  make_option(c("-t", "--table"), type="character", default=stats,
              help="Store the contingency table in text format",
              metavar="file")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs
if (is.na(opt$input) || is.na(opt$output)){
  cat("   ERROR: Missing required option (input or output)\n")
  stop()
}

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

# Only two columns needed (variable pairs)
if (length(opt$vars) > 2) {
  cat("   ERROR: More than two variables (columns) selected.
          A contingency table is a variable pair collection\n")
  stop()
}

if (!is.na(opt$table)) {
  # Calculate and store contingency table
}

p = plotContingencyTableBar(data, opt$value, opt$position)

# Adjust the y axis limits to min and max
if (!is.na(opt$min) || !is.na(opt$max)) {
  # Calculate limits if one not given
  if (is.na(opt$max))
    opt$max = max(data[2])
  if (is.na(opt$min))
    opt$min = min(data[2])
  p = p + coord_cartesian(ylim = c(opt$min, opt$max))
}

# Set the labels of the plot to the custom names
p = p + xlab(opt$names[1]) + 
        guides(fill=guide_legend(title=opt$names[2]))

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
