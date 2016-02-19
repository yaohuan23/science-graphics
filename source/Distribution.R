# Plot variable distributions
# Aleix Lafita - 02.2016

library(ggplot2)
library(reshape2)
library(plyr)

#' Plot the data distribution of the variables as a density with 
#' underlying histogram.
#' The histogram is scaled to the density scale.
#' 
#' @param data two columns, variable name and value
#' @param bin bin size to use, 0 is default to min(range/(points/(5*variables)),30)
#' @param xmin minimum value of the variable range
#' @param xmax maximum value of the variable range
#' @return ggplot2 object
plotHistogramDensity = function(data, bin=0, xmin=0, xmax=0) {
  
  # Default bin size calculation
  if (bin == 0){
    type = data
    names(type) = c("Type", "Value")
    levels = nlevels(type$Type)
    bins = as.integer(nrow(data)/(1*levels))
    range = xmax - xmin
    if (range == 0) {
      maxmin = range(data[2])
      range = maxmin[2]-maxmin[1]
      range = range + 0.01 * range
    }
    bin = range / min(bins, 30)
  }
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]),
                         y=quote(..density..),
                         fill=as.name(names(data)[1]),
                         color = as.name(names(data)[1]))) +
    geom_histogram(position="identity", alpha = 0.3, colour=NA, 
                   binwidth = bin) + 
    geom_line(stat="density") +
    theme_bw()
  
  if (xmin < xmax) {
    p = p + xlim(xmin, xmax)
  }                  
  return(p)

}


#' Plot the frequency of each class in each group.
#' The total number of observables are printed at the top.
#' 
#' @param data two columns, group name and class
#' @return ggplot2 object
stackedBarplot = function(data) {
  
  # Store the original names in the data and rename them
  original = names(data)
  names(data) = c("Group", "Class")
  
  # Cast the group-class pairs together and count frequency
  data$Freq = rep(1,nrow(data))
  table = dcast(data, Group ~ Class, sum, value.var="Freq")
  data = melt(table)
  data = ddply(data, "Group", transform,
                 Percentage = value / sum(value) * 100)
  names(data) = c(original, "Freq", "Percentage")
  
  # Add the total number of observables at the top of the bars
  table$Total = rowSums(table[,-1])
  table$Position = rep(105,nrow(table))
  
  p = ggplot(data, aes_q(x=as.name(names(data)[1]), 
                         y=as.name(names(data)[4]))) + 
    geom_bar(stat="identity", aes_q(fill=as.name(names(data)[2]))) +
    geom_text(data=table, aes(x=Group, y=Position, label=Total), size=4) +
    theme_bw()
  
}

#' Calculate the contingency table of a set of data predictions.
#' 
#' @param data two columns, variable 1 and variable 2 values
#' @return ggplot2 object
toContingencyTable = function(data) {
  
}