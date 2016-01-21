# Plots for benchmarking applications
# Aleix Lafita - 01.2016

library(ggplot2)
library(reshape)
library(plyr)

#' Represents the accuracy of the classifier for each label, coloring
#' the 100% bar with the percentage of each predicted label for each 
#' true label.
#' @param data classification table
#' @return a ggplot object
multiLabelPlot <- function(data) {
  
  # Scale the data to 100%
  mtable = melt(table)
  scaled <- ddply(mtable, "Truth", transform,
                 Percentage = value / sum(value) * 100)
  
  # Plot the scaled data
  p <- ggplot(scaled, aes(x=Truth, y=Percentage, fill=Prediction,
                          alpha=as.character(Truth)==as.character(Prediction))) + 
    geom_bar(stat="identity") + 
    scale_alpha_discrete(range=c(0.5,1)) +
    guides(alpha=FALSE) +
    theme_bw()
}

#' Create a classification table from a set of predictions.
#' @param data list of predictions in two columns (truth, prediction)
#' @return classification table
toClassificationTable <- function(data) {
  
  # Ensure propper names of the data and all factors
  names(data) <- c("Truth", "Prediction")
  data$Truth <- factor(data$Truth)
  data$Prediction <- factor(data$Prediction)
  
  # Transform the raw data into a classification table
  data$Count <- rep(1,nrow(data)) # add new column of ones
  table <- cast(data, Truth ~ Prediction, sum, value="Count")
}

#' Represent the precision of a ranking result in function of the number
#' of retrieved results (recall)
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

#' Represent the precision of a ranking result in function of the number
#' of retrieved results (recall) in a nicer way: starting from the back,
#' use only the cumulative maximum of the precision.
#' @param data a column with a 1 if the result is relevant, 0 otherwise
#' @return a ggplot object
nicePrecisionRecallCurve <- function(data) {
  
  # Ensure propper names of the data
  names(data) <- c("Relevance")
  
  # Transform the data into accumulative precision values
  data$Count <- rep(1,nrow(data)) # add new column of ones
  data$RelSum = cumsum(data$Relevance) # calculate the relevance sum
  data$Recall <- cumsum(data$Count)
  data$Precision <- data$RelSum / data$Recall
  data$NicePrecision <- rev(cummax(rev(data$Precision)))
  
  # Create the curve
  p <- ggplot(data, aes(x=Recall, y=NicePrecision)) + geom_line()
}