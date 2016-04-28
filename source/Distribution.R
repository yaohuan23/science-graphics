# Plot variable distributions
# Aleix Lafita - 02.2016

suppressPackageStartupMessages(library(ggplot2))

#' Calculate a default bin for the histogram.
#' 
#' @param data two columns, variable name (factor) and value
#' @param bin as range/min(points/(variables),30)
defaultBin = function(data) {
  levels = nlevels(data[[1]])
  bins = as.integer(nrow(data)/levels)
  range = max(data[,2]) - min(data[,2])
  range = range + 0.01 * range
  bin = range / min(bins, 30)
}

#' Plot the data distribution of the variables as a simple histogram.
#' 
#' @param data two columns, variable name (factor) and value
#' @param bin size to use, default to range/min(points/(variables),30)
#' @return ggplot2 object
histogram = function(data, bin, min, max) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  # Default bin size calculation
  if (is.na(bin))
    bin = defaultBin(data)
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]),
                         fill=as.name(names(data)[1]),
                         color = as.name(names(data)[1]))) +
    geom_histogram(position="identity", alpha = 0.3, binwidth=bin) + 
    theme_bw()
  
  # Remove the legend if only one variable
  if (nlevels(data[[1]]) < 2)
    p = p + theme(legend.position="none")
  
  # Adjust the y axis limits to min and max
  if (!is.na(min) || !is.na(max)) {
    # Calculate limits if one not given
    if (is.na(max))
      max = max(data[2])
    if (is.na(min))
      min = min(data[2])
    p = p + coord_cartesian(xlim = c(min, max))
  }
  return(p)
  
}

#' Plot the data distribution of the variables as a simple density
#' 
#' @param data two columns, variable name (factor) and value
#' @return ggplot2 object
density = function(data, min, max) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]),
                        fill=as.name(names(data)[1]),
                         color = as.name(names(data)[1]))) +
    geom_density() +
    theme_bw()
  
  # Remove the legend if only one variable
  if (nlevels(data[[1]]) < 2)
    p = p + theme(legend.position="none")
  
  # Adjust the y axis limits to min and max
  if (!is.na(min) || !is.na(max)) {
    # Calculate limits if one not given
    if (is.na(max))
      max = max(data[2])
    if (is.na(min))
      min = min(data[2])
    p = p + coord_cartesian(xlim = c(min, max))
  }
  return(p)
  
}

#' Plot the data distribution of the variables as a density with 
#' underlying histogram, scaled to the density.
#' 
#' @param data two columns, variable name (factor) and value
#' @param bin size to use, default to range/min(points/(variables),30)
#' @return ggplot2 object
histogramDensity = function(data, bin, min, max) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  # Default bin size calculation
  if (is.na(bin))
    bin = defaultBin(data)
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]),
                         y=quote(..density..),
                         fill=as.name(names(data)[1]),
                         color = as.name(names(data)[1]))) +
    geom_histogram(position="identity", alpha = 0.3, colour=NA, 
                   binwidth = bin) + 
    geom_line(stat="density") +
    theme_bw()
  
  # Remove the legend if only one variable
  if (nlevels(data[[1]]) < 2)
    p = p + theme(legend.position="none")
  
  # Adjust the y axis limits to min and max
  if (!is.na(min) || !is.na(max)) {
    # Calculate limits if one not given
    if (is.na(max))
      max = max(data[2])
    if (is.na(min))
      min = min(data[2])
    p = p + coord_cartesian(xlim = c(min, max))
  }
  return(p)

}

#' Plot the data distribution of the variables as a violin plot with
#' an underlying box plot and a point in the mean.
#' 
#' @param data two columns, variable name (factor) and value
#' @return ggplot2 object
violinBoxPlot = function(data, min, max) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  p = ggplot(data, aes_q(x=as.name(names(data)[1]),
                         y=as.name(names(data)[2]))) +
    geom_violin(scale="width", trim=FALSE) + 
    geom_boxplot(width=.1, fill="black", outlier.colour=NA) +
    stat_summary(fun.y=median, geom="point", fill="white", shape=21, size=3) +
    stat_summary(fun.y=mean, geom="point", fill="white", shape=23, size=3) +
    theme_bw() + theme(axis.text.x = element_text(angle = 45))
  
  # Adjust the y axis limits to min and max
  if (!is.na(min) || !is.na(max)) {
    # Calculate limits if one not given
    if (is.na(max))
      max = max(data[2])
    if (is.na(min))
      min = min(data[2])
    p = p + coord_cartesian(ylim = c(min, max))
  }
  return(p)
    
}

#' Plot the data distribution of the variables as a box plot with
#' a point in the mean.
#' 
#' @param data two columns, variable name (factor) and value
#' @return ggplot2 object
boxPlot = function(data, min, max) {
  
  # Ensure that first column is a factor
  data[,1] = as.factor(data[,1])
  
  p = ggplot(data, aes_q(x=as.name(names(data)[1]),
                         y=as.name(names(data)[2]))) +
    geom_boxplot() +
    stat_summary(fun.y=mean, geom="point", fill="white", shape=23, size=3) +
    theme_bw() + theme(axis.text.x = element_text(angle = 45))
  
  # Adjust the y axis limits to min and max
  if (!is.na(min) || !is.na(max)) {
    # Calculate limits if one not given
    if (is.na(max))
      max = max(data[2])
    if (is.na(min))
      min = min(data[2])
    p = p + coord_cartesian(ylim = c(min, max))
  }
  return(p)
  
}

#' Calculate the distribution statistics of a dataset clustered
#' by factor.
#' 
#' @param data two columns: group and value
#' @return stats distribution statistics as data frame
calculateDistributionStats = function(data) {
  
  copy = data
  names(copy) = c("Group", "Value")
  stats = aggregate(Value~Group, copy, mean)
  stats$Variance = aggregate(Value~Group, copy, var)$Value
  stats$STD = sqrt(stats$Variance)
  names(stats) = c(names(data)[1], "Mean", "Variance", "STD")
  return(stats)
  
}

#' Plot each class percentage as a Pie Chart.
#' 
#' @param data one column with class instances
#' @param name of the variable
#' @return ggplot2 object
pieChart = function(data, name) {
  
  data = toFrequencyTable(data)
  
  pie = ggplot(data, aes(x = "", y = Percentage)) + 
    geom_bar(stat = "identity", width = 0.5, 
             aes_q(fill=as.name(names(data)[1]))) +
    coord_polar(theta = "y") +
    theme_bw() + 
    theme(axis.title.x=element_blank(), 
          axis.title.y=element_blank()) +
    guides(fill=guide_legend(title=name))
  
}

#' Plot each class frequency as a Bar Plot.
#' 
#' @param data one column with class instances
#' @param name of the variable
#' @param min minimum count value
#' @param max maximum count value
#' @param logarithmic scale y axis
#' @return ggplot2 object
barPlot = function(data, name, min, max, log) {
  
  data = toFrequencyTable(data)
  
  p = ggplot(data, aes(y = Frequency)) + 
    geom_bar(stat = "identity",
             aes_q(x=as.name(names(data)[1]))) +
    theme_bw() + theme(axis.text.x = element_text(angle = 45)) +
    xlab(name)
  
  if (log)
    p = p + scale_y_log10()
  
  # Adjust the y axis limits to min and max
  if (!is.na(min) || !is.na(max)) {
    # Calculate limits if one not given
    if (is.na(max))
      max = max(data$Frequency)
    if (is.na(min))
      min = min(data$Frequency)
    p = p + coord_cartesian(ylim = c(min, max))
  }
  return(p)
  
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
