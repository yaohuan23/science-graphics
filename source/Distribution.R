# Plot variable distributions
# Aleix Lafita - 02.2016

library(ggplot2)

#' Plot the data distribution of the variables as a density with 
#' underlying histogram.
#' The histogram is scaled to the density scale.
#' 
#' @param data two columns, variable name (factor) and value
#' @param bin size to use, default to min(range/(points/(variables)),30)
#' @param min minimum value of the range
#' @param max maximum value of the range
#' @return ggplot2 object
plotHistogramDensity = function(data, bin=0, min=NA, max=NA) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  # Calculate limits if not given
  if (is.na(max))
    max = max(data[2])
  if (is.na(min))
    min = min(data[2])
  
  # Default bin size calculation
  if (bin == 0){
    type = data
    names(type) = c("Type", "Value")
    levels = nlevels(type$Type)
    bins = as.integer(nrow(data)/(levels))
    range = max - min
    range = range + 0.01 * range
    bin = range / min(bins, 30)
  }
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]),
                         y=quote(..density..),
                         fill=as.name(names(data)[1]),
                         color = as.name(names(data)[1]))) +
    geom_histogram(position="identity", alpha = 0.3, colour=NA, 
                   binwidth = bin) + 
    geom_line(stat="density") +
    coord_cartesian(xlim = c(min, max)) +
    theme_bw()

}

#' Plot each class frequency as a Pie Chart.
#' 
#' @param data one column with class instances
#' @return ggplot2 object
pieChart = function(data) {
  
  data = toFrequencyTable(data)
  
  pie = ggplot(data, aes(x = "", y = Percentage)) + 
    geom_bar(stat = "identity", width = 1, aes_q(fill=as.name(names(data)[1]))) +
    coord_polar(theta = "y") +
    theme_bw() + 
    theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  
}

#' Calculate the table of counts and percentages of each class 
#' from a list of observations.
#' 
#' @param data one column with class instances
#' @return table of counts (frequency table)
toFrequencyTable = function(data) {
  
  original = names(data)
  data = data.frame(table(data))
  names(data) = c(original, "Frequency")
  data$Percentage = data$Frequency * 100 / sum(data$Frequency)
  return(data)
  
}

#' Plot the data distribution of the variables as a violin plot with
#' an underlying box plot and a point in the median.
#' 
#' @param data two columns, variable name (factor) and value
#' @param max maximum value of the range
#' @param min minimum value of the range
#' @param scale normalization of the violin shape [width,area,count]
#' @return ggplot2 object
violinBoxPlot = function(data, max=NA, min=NA, scale="width") {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  # Calculate limits if not given
  if (is.na(max))
    max = max(data[2])
  if (is.na(min))
    min = min(data[2])
  
  p = ggplot(data, aes_q(x=as.name(names(data)[1]),
                         y=as.name(names(data)[2]))) +
    geom_violin(scale=scale, trim=FALSE) + 
    geom_boxplot(width=.1, fill="black", outlier.colour=NA) +
    stat_summary(fun.y=median, geom="point", fill="white", shape=21, size=2.5) +
    coord_cartesian(ylim = c(min, max)) +
    theme_bw()
    
}

#' Plot the data distribution of the variables as a box plot with
#' a point in the median.
#' 
#' @param data two columns, variable name (factor) and value
#' @param max maximum value of the range
#' @param min minimum value of the range
#' @return ggplot2 object
simpleBoxPlot = function(data, max=NA, min=NA) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  # Calculate limits if not given
  if (is.na(max))
    max = max(data[2])
  if (is.na(min))
    min = min(data[2])
  
  p = ggplot(data, aes_q(x=as.name(names(data)[1]),
                         y=as.name(names(data)[2]))) +
    geom_boxplot() +
    stat_summary(fun.y=median, geom="point", fill="white", shape=23, size=3) +
    coord_cartesian(ylim = c(min, max)) +
    theme_bw()
  
}
