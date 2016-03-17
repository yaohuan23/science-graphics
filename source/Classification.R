# Plots for evaluating classifier performance
# Aleix Lafita - 01.2016

library(ggplot2)
library(reshape2)
library(plyr)
library(mlearning)
library(ROCR)
library(RColorBrewer)

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

#' Plot the ROC curve of a binary classifier based on a continuous score
#' threshold.
#' 
#' @param data [Algorithm, Score, Relevance]
#' @param xmin in percentage [0,100] %
#' @param xmax in percentage [0,100] %
#' @param ymin in percentage [0,100] %
#' @param ymax in percentage [0,100] %
#' @param thresholds
plotROCurve = function(data, xmin=0, xmax=100, ymin=0, ymax=100, thresholds=list()) {
  
  scores = c(split(data[[2]], data[[1]]))
  labels = c(split(data[[3]], data[[1]]))
  
  algorithms = as.character(levels(as.factor(data[[1]])))
  colors = brewer.pal(max(length(algorithms),3), "Set1")
  
  pred <- prediction(scores, labels)
  perf <- performance(pred, measure = "tpr", x.measure = "fpr")
  
  plot(perf,
       col=as.list(colors),
       xaxs="i", yaxs="i",
       xlim=c(xmin/100, xmax/100),
       ylim=c(ymin/100, ymax/100),
       xaxis.at=seq(xmin/100,xmax/100, (xmax-xmin)/1000),
       xaxis.labels=paste(seq(xmin,xmax,(xmax-xmin)/10),"%",sep=""),
       yaxis.at=seq(ymin/100,ymax/100, (ymax-ymin)/1000),
       yaxis.labels=paste(seq(ymin,ymax,(ymax-ymin)/10),"%",sep=""),
       yaxis.las=1,
       points.col=as.list(colors),
       points.pch=20,
       points.cex=2.0,
       print.cutoffs.at=thresholds[1:length(thresholds)],
       cutoff.label.function=function(x) { "" },
       lwd=2)
  legend("bottomright",
         algorithms,
         col=colors,
         lwd=2,
         cex=.9,
         inset=c(.1,.05))
  
}