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
  data = read.csv(paste("../data/", project, ".csv", sep=""), 
                   header=TRUE, sep=",", stringsAsFactors=TRUE)
}

#' Write the data to a CSV file in the results folder
#' @param project name
#' @param data matrix, frame or other format to write
writeResult = function(project, data) {
  filename = paste("../results/", project, ".csv", sep="")
  write.csv(data, filename, row.names=FALSE, quote=FALSE)
  cat(paste("Writing", project, "to results folder\n"))
}

#' Write the data to a CSV file in the data folder
#' @param project name
#' @param data matrix, frame or other format to write
writeData = function(project, data) {
  filename = paste("../data/", project, ".csv", sep="")
  write.csv(data, filename, row.names=FALSE, quote=FALSE)
  cat(paste("Writing", project, "to data folder\n"))
}

#' Save a plot in the figures folder in the desired format.
#' 
#' @param project name
#' @param plot the figure object
#' @param format the format of the output svgpdfpng
saveFigure = function(project, plot, format="pdf") {
  cat(paste("Saving", project, "to figures folder\n"))
  
  if (grepl("pdf",format)) {
    # PDF figure
    pdf(paste("../figures/", project, ".pdf", sep=""))
    print(plot)
    dev.off()
  }
  if (grepl("svg",format)) {
    # SVG figure
    svg(paste("../figures/", project, ".svg", sep=""))
    print(plot)
    dev.off()
  }
  if (grepl("png", format)) {
    # PNG figure
    png(paste("../figures/", project, ".png", sep=""))
    print(plot)
    dev.off()
  }
}
