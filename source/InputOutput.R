# Helper functions to parse files and save figures and results
# Aleix Lafita - 01.2016

#' Parse a CSV file with headers into a data table
#' @param project name
#' @return data table from the file
parseFile <- function(project, args) {  
  data <- read.csv(paste("../data/", project, ".csv", sep=""), 
                   header=TRUE, sep=",", stringsAsFactors=TRUE)
}

#' Write the data table to a CSV file in the results folder
#' @param project name
#' @param table data table
writeResult <- function(project, table) {
  write.csv(table, paste("../results/", project, ".csv", sep=""),
            row.names=FALSE, quote=FALSE)
}

#' Save a plot as a PDF in the figures folder
#' @param project name
#' @param plot the figure object
saveFigure <- function(project, plot) {
  pdf(paste("../figures/", project, ".pdf", sep=""))
  print(plot)
  dev.off()
}
