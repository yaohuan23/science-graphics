# Helper functions to parse files and save figures
# Aleix Lafita - 01.2016

#' Parse the file into a data table
#' @param file default file name
#' @param args cmd line arguments
#' @return data table from the file
parseFile <- function(file, args) {
  
  if (length(args)==0) {
    cat("No argument given, using default file...\n")
    args[1] = file
  } else {
    file = args[1]
  }
  
  # Read a file with headers, comma separated and Factors
  data <- read.csv(paste("../data/",file,".csv",sep=""), 
                   header=TRUE, sep=",", stringsAsFactors=TRUE)
  
  # Print the whole data table
  cat("Data loaded...\n")
  return(data)
}

savePDF <- function(file, plot) {
  pdf(paste("../figures/", file, ".pdf", sep=""))
  print(plot)
  dev.off()
}

saveSVG <- function(file, plot) {
  svg(paste("../figures/", file, ".svg", sep=""))
  print(plot)
  dev.off()
}