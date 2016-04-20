#!/usr/bin/env Rscript
# Calculate and plot a confusion matrix of a classifier result. 
# The format of the input is in two columns, actual and predicted class.
# An optional Name column can be given in the first column.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("source/ScienceGraphicsIO.R")
source("source/Classification.R")

# Default input parameters
input = NA
output = NA
stats = NA
matrix = NA
labelSize = 4

printSGheader("Confusion Matrix Plot")

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
  make_option(c("-s", "--stats"), type="character", default=stats,
              help="Calculate and store performance metrics",
              metavar="file"),
  make_option(c("-m", "--matrix"), type="character", default=matrix,
              help="Store the confusion matrix in text format",
              metavar="file"),
  make_option("--labSize", type="integer", default=labelSize,
              help="The size of the count labels [default %default]",
              metavar="NUMBER")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs
if (is.na(opt$input) || is.na(opt$output)){
  cat("   ERROR: Missing required option (input or output)\n")
  stop()
}

# data = [Name] Actual Prediction
data = parseFile(opt$input)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

# Calculate and write confusion matrix
matrix = toConfusionMatrix(data)
if (!is.na(opt$matrix))
  writeResult(opt$matrix, matrix)

if (!is.na(opt$stats)) {
  # Calculate the precision and Cramer V coefficient
  cv = cv.test(data[[1]],data[[2]])
  pr = precision(data)
  stats = data.frame(c("Precision", "Cramér Phi"), c(pr, cv))
  names(stats) = c("Score", "Value")
  writeResult(opt$stats, stats)
}

p = plotConfusionMatrix(matrix, opt$labSize)

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
