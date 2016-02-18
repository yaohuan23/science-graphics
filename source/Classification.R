# Plots for evaluating classifier performance
# Aleix Lafita - 01.2016

library(ggplot2)
library(reshape2)
library(plyr)
library(mlearning)

#' Plot the confusion matrix of a classifier with the actual class in the
#' x axis and a stacked bar proportional to the predicted class fraction
#' in the y axis. The stacked bars are colored by class. The total numbers
#' of each actual class are displayed at the top.
#' 
#' @param confusion matrix
#' @return a ggplot object
plotConfusionMatrixBar <- function(matrix) {
  
  # Scale the data to 100%
  mtable = data.frame(matrix)
  scaled = ddply(mtable, "Actual", transform,
                 Percentage = Freq / sum(Freq) * 100)
  
  p = ggplot(scaled) + 
    geom_bar(stat="identity", 
             aes(x=Actual, y=Percentage, fill=Prediction, 
                 alpha=as.character(Actual)==as.character(Prediction))) +
    scale_alpha_discrete(range=c(0.3,1)) +
    #scale_fill_brewer(palette="Set2") +
    guides(alpha=FALSE) +
    theme_bw()
  
  # Add the total number of observables at the top of the bars
  data$Total = rowSums(data[,-1])
  data$Position = rep(105,nrow(data))
  p = p + geom_text(data=data, aes(x=Actual, y=Position, label=Total), size=4)
  
}

#' Plot the confusion matrix of a classifier with the true (actual) class in the
#' x axis and the predicted class in the y axis. 
#' The entries are are colored by the fraction of predicted class and the total 
#' values are printed in the tiles.
#' 
#' @param confusion matrix
#' @param labelSize size of the text labels for total values
#' @return a ggplot object
plotConfusionMatrix <- function(matrix, labelSize = 4) {
  
  confusion = data.frame(matrix)
  scaled = ddply(confusion, "Actual", transform,
                 Fraction = Freq / sum(Freq))
  
  # Create tiles colored by fraction of prediction class
  p = ggplot(scaled) + geom_tile(aes(x=Actual, y=Prediction, fill=Fraction))
  
  # Add the total observed values, except for zeros, to the tiles
  nonzero = scaled[scaled$Freq>0,]
  p = p + geom_text(data=nonzero, aes(x=Actual,y=Prediction, 
                                      label=sprintf('%0.f', Freq)),
                    size = labelSize) +
    scale_fill_gradient(low="white", high="tomato3", na.value="white") +
    theme_bw()
  
}

#' Create a confusion matrix from a set of predictions of a classifier.
#' 
#' @param data list of predictions in two columns (truth, prediction)
#' @return cofusion matrix
toConfusionMatrix <- function(data) {
  
  # Ensure propper names of the data
  names(data) = c("Actual", "Prediction")
  
  # Convert to factors the labels and ensure same levels
  data$Actual = factor(data$Actual)
  data$Prediction = factor(data$Prediction)
  classes = unique(c(levels(data$Actual), levels(data$Prediction)))
  #classes = factor(sort(as.numeric(classes)))
  data$Actual <- factor(data$Actual, levels = classes)
  data$Prediction <- factor(data$Prediction, levels = classes)
  
  confusion(data, vars = names(data))
  
}

#' Create a confusion matrix from a set of predictions of a classifier.
#' 
#' @param data list of predictions in two columns (truth, prediction)
#' @return cofusion matrix in data frame
toConfusionMatrixDeprecated <- function(data) {
  
  # Ensure propper names of the data and all factors
  names(data) = c("Actual", "Prediction")
  data$Actual = factor(data$Actual)
  data$Prediction = factor(data$Prediction)
  
  # Transform the raw data into a classification table
  data$Count = rep(1,nrow(data)) # add new column of ones
  table = dcast(data, Actual ~ Prediction, sum, value.var="Count")
  
}
