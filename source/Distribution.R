# Plot variable distributions
# Aleix Lafita - 02.2016

library(ggplot2)

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

#' Plot each class frequency as a Pie Chart.
#' 
#' @param data one column with class instances
#' @return ggplot2 object
pieChart = function(data) {
  
}
