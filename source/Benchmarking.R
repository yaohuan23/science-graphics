# Plots for benchmarking applications
# Aleix Lafita - 01.2016

library(ggplot2)
library(reshape)
library(plyr)

#' Represents the accuracy of the classifier for each label, coloring
#' the 100% bar with the percentage of each predicted label for each 
#' true label.
#' @param data two columns, true and predicted labels
#' @return a ggplot object
multiLabelPlot <- function(data) {
  
  # Ensure propper names of the data
  names(data) <- c("Truth", "Prediction")
  
  # Transform the raw data into a classification table
  data$Count <- rep(1,nrow(data)) # add new column of ones
  table <- cast(data, Truth ~ Prediction, sum, value="Count")
  cat("Classification Table:\n")
  print(table)
  
  # Scale the data to 100%
  mtable = melt(table)
  scaled <- ddply(mtable, "Truth", transform,
                 Percentage = value / sum(value) * 100)
  
  # Plot the scaled data
  p <- ggplot(scaled, aes(x=Truth, y=Percentage, fill=Prediction)) + 
    geom_bar(stat="identity")
}

#' Represent the precision-recall in a ranking result.
#' @param data a column with a 1 if the result is relevant, 0 otherwise
#' @return a ggplot object
precisionRecallCurve <- function(data) {
  
  # Ensure propper names of the data
  names(data) <- c("Relevance")
  
  # Transform the data into accumulative precision values
  data$Count <- rep(1,nrow(data)) # add new column of ones
  data$RelSum = cumsum(data$Relevance) # calculate the relevance sum
  data$Recall <- cumsum(data$Count)
  data$Precision <- data$RelSum / data$Recall
  
  # Create the curve
  p <- ggplot(data, aes(x=Recall, y=Precision)) + geom_line()
}