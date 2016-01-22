# Plots for benchmarking applications
# Aleix Lafita - 01.2016

library(ggplot2)
library(reshape2)
library(plyr)

#' Represents the accuracy of the classifier for each label, coloring
#' the 100% bar with the percentage of each predicted label for each 
#' true label.
#' @param data classification table
#' @return a ggplot object
multiLabelPlot <- function(data) {
  
  # Scale the data to 100% and plot bars
  mtable = melt(table, variable.name = "Prediction", value.name = "Count")
  scaled = ddply(mtable, "Truth", transform,
                 Percentage = Count / sum(Count) * 100)
  
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
  
  # Add a precision line for each category
  tableTP = subset(mtable, as.character(Truth)==as.character(Prediction))
  tableTP$Precision = (100 * tableTP$Count / data$Total)
  p + geom_point(data=tableTP, aes(x=Truth, y=Precision), 
                 colour="black", size=10, shape="-")
}

#' Create a classification table from a set of predictions.
#' @param data list of predictions in two columns (truth, prediction)
#' @return classification table
toClassificationTable <- function(data) {
  
  # Ensure propper names of the data and all factors
  names(data) = c("Truth", "Prediction")
  data$Truth = factor(data$Truth)
  data$Prediction = factor(data$Prediction)
  
  # Transform the raw data into a classification table
  data$Count = rep(1,nrow(data)) # add new column of ones
  table = dcast(data, Truth ~ Prediction, sum, value.var="Count")
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