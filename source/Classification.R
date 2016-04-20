# Plots for evaluating classifier performance
# Aleix Lafita - 01.2016

suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(mlearning))

#' Plot the confusion matrix of a classifier with the actual class in the
#' x axis and a stacked bar proportional to the predicted class fraction
#' in the y axis. The stacked bars are colored by class. The total numbers
#' of each actual class are displayed at the top.
#' 
#' @param confusion matrix
#' @return a ggplot object
plotConfusionMatrixBar = function(matrix) {
  
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
plotConfusionMatrix = function(matrix, labelSize = 4) {
  
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
#' The factor levels of Actual and Prediction are enforced to be equal.
#' 
#' @param data set of predictions in two columns: actual and prediction.
#' @return cofusion matrix
toConfusionMatrix = function(data) {
  
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

#' Calculate the Cramer's V coefficient of a classifier.
#' Code from: http://www.r-bloggers.com/example-8-39-calculating-cramers-v/
#' 
#' @param actual vector of actual (true) values
#' @param prediction vector of prediction values
#' @return cramer v coefficient as numeric
cv.test = function(actual, prediction) {
  
  cv = sqrt(chisq.test(actual, prediction, correct=FALSE)$statistic / 
         (length(actual) * (min(length(unique(actual)),
                                length(unique(prediction))) - 1)))
  
}

#' Calculate the Precision of a classifier.
#' 
#' @param data data frame with two columns: actual (true) and prediction
#' @return precision as a numeric
precision = function(data) {
  
  pr = length(which(as.character(data[[1]])==as.character(data[[2]]))) / 
    nrow(data)
  
}