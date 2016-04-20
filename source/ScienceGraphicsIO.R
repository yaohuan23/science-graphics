# Helper functions to parse files and save figures and results
# Aleix Lafita - 01.2016

# Import library for CL argument parsing
suppressPackageStartupMessages(library("optparse"))

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

#' Detect the format and parse a file with headers into a data frame
#' 
#' @param file name with format extension (.csv or .tsv)
#' @return data frame of the file
parseFile = function(file) {
  if (grepl(".csv",file)) {
    data = read.csv(file, stringsAsFactors=TRUE)
  } else if (grepl(".tsv",file)) {
    data = read.delim(file, stringsAsFactors=TRUE)
  } else {
    cat("   ERROR: Unsupported input file format\n")
    stop()
  }
  return(data)
}

#' Detect the format and write a data frame to a file
#' 
#' @param data frame to write
#' @param file name with format extension (.csv or .tsv)
#' @return data frame of the file
writeFile = function(data, file) {
  if (grepl(".csv",file)) {
    write.csv(data, file, row.names=FALSE, quote=FALSE)
  } else if (grepl(".tsv",file)) {
    write.table(data, file, sep="\t", row.names=FALSE, quote=FALSE)
  } else {
    cat("   ERROR: Unsupported output file format\n")
    stop()
  }
  cat(paste("   Written file to", file, "\n"))
}
