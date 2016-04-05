#!/usr/bin/env Rscript
# Calculate and plot a confusion matrix of a multiple class classifier
# result. 
# The format of the input is in two columns, actual and predicted class.
# An additional name column can be optionally given in the first column,
# but it will be ignored.
# Aleix Lafita - 02.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Classification.R")

# Default input parameters
file = "example_confusion-matrix"
format = "pdf"
labelSize = 4
stats = TRUE

printSGheader("Confusion Matrix Plot")

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option("--labSize", type="integer", default=labelSize,
              help="The size of the count labels [default %default]",
              metavar="NUMBER"),
  make_option("--stats", action="store_true", default=stats,
              help="Calculate and store evaluation statistics [default]"),
  make_option("--nostats", action="store_false", dest="stats",
              help="Do not calculate evaluation statistics")
)
opt = parse_args(OptionParser(option_list=option_list))

# data = [Name] Actual Prediction
data = parseFile(opt$input)
if (ncol(data) > 2){
  data = data[c(2,3)]
}

# Calculate and write confusion matrix
matrix = toConfusionMatrix(data)
writeResult(paste(opt$input, "_matrix", sep=""), matrix)

if (opt$stats) {
  # Calculate the precision and Cramer V coefficient
  cv = cv.test(data[[1]],data[[2]])
  pr = precision(data)
  stats = data.frame(c("Precision", "Cramér Phi"), c(pr, cv))
  names(stats) = c("Score", "Value")
  writeResult(paste(opt$input, "stats", sep="_"), stats)
}

p = plotConfusionMatrix(matrix, opt$labSize)
saveFigure(paste(opt$input, "conf-matrix", sep="_"), p, opt$output)
