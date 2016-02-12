# Plots for benchmarking classifiers
# Aleix Lafita - 01.2016

library(ggplot2)
library(reshape2)
library(plyr)
library(mlearning)

#' Plot the confusion matrix of a classifier with the true (actual) class in the
#' x axis and a stacked bar proportional to the predicted class frequency in the
#' y axis. The stacked bars are colored by class name.
#' The total numbers of each true class are displayed at the top.
#' 
#' @param confusion matrix
#' @return a ggplot object
plotConfusionMatrixBar <- function(matrix) {
  
  # Scale the data to 100%
  mtable = data.frame(matrix)
  scaled = ddply(mtable, "Truth", transform,
                 Percentage = Count / sum(Freq) * 100)
  
  p = ggplot(scaled) + 
    geom_bar(stat="identity", 
             aes(x=Truth, y=Percentage, fill=Prediction, 
                 alpha=as.character(Truth)==as.character(Prediction))) +
    scale_alpha_discrete(range=c(0.3,1)) +
    #scale_fill_brewer(palette="Set2") +
    guides(alpha=FALSE) +
    theme_bw()
  
  # Add the total number of observables at the top of the bars
  data$Total = rowSums(data[,-1])
  data$Position = rep(105,nrow(data))
  p = p + geom_text(data=data, aes(x=Truth, y=Position, label=Total), size=4)
  
}

#' Plot the confusion matrix of a classifier with the true (actual) class in the
#' x axis and the predicted class in the y axis. The entries are are colored by 
#' class prediction frequency and percentage values are also shown in the tiles.
#' 
#' @param confusion matrix
#' @return a ggplot object
plotConfusionMatrix <- function(matrix) {
  
  confusion = data.frame(matrix)
  scaled = ddply(confusion, "Truth", transform,
                 Percentage = Freq / sum(Freq))
  
  p <- ggplot(scaled) + geom_tile(aes(x=Truth, y=Prediction, fill=Percentage)) +
    geom_text(aes(x=Truth,y=Prediction, label=sprintf("%.0f", Freq)))
  
}

#' Create a confusion matrix from a set of predictions of a classifier.
#' @param data list of predictions in two columns (truth, prediction)
#' @return cofusion matrix in data frame
toConfusionMatrixOld <- function(data) {
  
  # Ensure propper names of the data and all factors
  names(data) = c("Truth", "Prediction")
  data$Truth = factor(data$Truth)
  data$Prediction = factor(data$Prediction)
  
  # Transform the raw data into a classification table
  data$Count = rep(1,nrow(data)) # add new column of ones
  table = dcast(data, Truth ~ Prediction, sum, value.var="Count")
  
}


#' Create a confusion matrix from a set of predictions of a classifier.
#' @param data list of predictions in two columns (truth, prediction)
#' @return cofusion matrix
toConfusionMatrix <- function(data) {
  
  # Ensure propper names of the data
  names(data) = c("Truth", "Prediction")
  
  # Convert to factors the labels and ensure same levels
  data$Truth = factor(data$Truth)
  data$Prediction = factor(data$Prediction)
  classes <- unique(c(levels(data$Truth), levels(data$Prediction)))
  data$Truth <- factor(data$Truth, levels = classes)
  data$Prediction <- factor(data$Prediction, levels = classes)
  
  confusion(data, vars = names(data))
  
}

#' Represent the precision of a ranking result in function of the number
#' of retrieved results (recall)
#' @param data a column with a 1 if the result is relevant, 0 otherwise
#' @return a ggplot object
precisionRecallCurve <- function(data) {
  
  # Ensure propper names of the data
  names(data) = c("Relevance")
  
  # Transform the data into accumulative precision values
  data$Count = rep(1,nrow(data)) # add new column of ones
  data$RelSum = cumsum(data$Relevance) # calculate the relevance sum
  data$Recall = cumsum(data$Count)
  data$P1 = data$RelSum / data$Recall
  data$P2 = rev(cummax(rev(data$P1)))
  
  # Join precision and nice precision for plotting
  table = melt(data[,c("Recall","P1","P2")], id.vars = "Recall", value.name = "Precision")
  
  # Create the curve
  p = ggplot(table, aes(x=Recall, y=Precision, colour=variable)) + 
    geom_line() +
    guides(colour=FALSE) +
    theme_bw()
}