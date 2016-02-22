# Helper functions to parse files and save figures and results
# Aleix Lafita - 01.2016

#' Common line printing format for all scripts in the project.
#' @param mess message to print to the cmd line
printSGline = function(message) {
  spacesR = paste(rep(" ",(60 - nchar(message) - 4) / 2), collapse="")
  spacesL = paste(rep(" ",(61 - nchar(message) - 4) / 2), collapse="")
  cat(paste("##", spacesL, message, spacesR, "##", "\n", sep=""))
}

#' Common script header for all scripts in the project.
#' @param script name of the script
printSGheader = function(script) {
  cat("############################################################\n")
  printSGline("")
  printSGline("Science-Graphics")
  printSGline(script)
  printSGline("")
  cat("############################################################\n")
}

#' Parse a CSV file with headers into a data table
#' @param project name
#' @return data table from the file
parseFile = function(project, args) {  
  data <- read.csv(paste("../data/", project, ".csv", sep=""), 
                   header=TRUE, sep=",", stringsAsFactors=TRUE)
}

#' Write the data table to a CSV file in the results folder
#' @param project name
#' @param table data table
writeResult = function(project, table) {
  filename = paste("../results/", project, ".csv", sep="")
  write.csv(table, filename, row.names=FALSE, quote=FALSE)
  cat(paste("Writing", project, "to results folder\n"))
}

#' Save a plot as a PDF and SVG in the figures folder.
#' 
#' @param project name
#' @param plot the figure object
saveFigure = function(project, plot) {
  cat(paste("Saving", project, "to figures folder\n"))
  # PDF figure
  pdf(paste("../figures/", project, ".pdf", sep=""))
  print(plot)
  dev.off()
  # SVG figure
  svg(paste("../figures/", project, ".svg", sep=""))
  print(plot)
  dev.off()
}
