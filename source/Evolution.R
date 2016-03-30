# Plot variable evolution
# Aleix Lafita - 02.2016

library(ggplot2)
library(gridExtra)

#' Plot the evolution of multiple variables during a step-based simulation.
#' The first and second columns of the input data frame must contain the 
#' name/type and the step/time count, respectively. Any subsequent column 
#' contains the value of a new variable.
#' Each variable will be ploted separately and combined into a multiplot,
#' because they are assumed to be in different units.
#' 
#' @param data frame with multiple variables in evolution
#' @param points show points if TRUE
#' @param rangeXY1Y2 specify the ranges of X and Y axis
#' @return a grob object
multipleEvolutionPlot = function(data, points, rangesXY1Y2 = c()) {
  
  plots = vector("list", ncol(data)-2)
  
  # Extract the x ranges
  x0 = xm = NA
  if (length(ranges) > 0)
    x0 = ranges[1]
  if (length(ranges) > 1)
    xm = ranges[2]
  
  for (i in 3:ncol(data)) {
    
    # Extract y ranges if provided
    y0 = ym = NA
    if (length(ranges) > ((i-2)*2))
      y0 = ranges[(i-2)*2+1]
    if (length(ranges) > ((i-2)*2)+1)
      ym = ranges[((i-1)*2)]
    
    p = singleEvolutionPlot(data[c(1,2,i)], points, x0, xm, y0, ym)
    
    # Remove xlabel and numbers except last
    if (i != ncol(data)) {
      p = p + theme(axis.title.x=element_blank(),
                    axis.text.x=element_blank())
    }
    
    # Remove legend except first
    if (i == 3) {
      p = p + theme(legend.position = "top")
    } else {
      p = p + theme(legend.position = "none")
    }
    
    plots[[i-2]] = p
  }
  
  # Join all the variable plots in a single grob
  g = grid.arrange(grobs = plots, ncol = 1)
  
}

#' Plot the evolution of a single variable during a step-based simulation. 
#' The input data frame must contain 3 columns. The first one specifies the
#' name or type, the second one the step count and the third one the value 
#' of the variable. The lines will be colored by the first column.
#' 
#' @param data frame with {Name,Step,Value}
#' @param showpoints logical
#' @param xmin minimum x values in the plot
#' @param xmax maximum x value in the plot
#' @param ymin minimum y value in the plot
#' @param ymax maximum y value in the plot
#' @return a ggplot object
singleEvolutionPlot = function(data, showpoints = FALSE, 
                               xmin=NA, xmax=NA, ymin=NA, ymax=NA) {
  
  # Ensure names as factors
  data[[1]] = as.factor(data[[1]])
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]), y=as.name(names(data)[3]), 
                         color=as.name(names(data)[1]))) + geom_line() + 
    #scale_x_discrete() + 
    #ylab("Percentage of Entries Released per Year") + xlab("Year") +
    theme_bw()
  
  if (showpoints)
    p = p + geom_point()
  
  # Set the limits according to the inputs
  xlim = ylim = NA
  if (!is.na(xmin) && !is.na(xmax)){
    if (!is.na(ymin) && !is.na(ymax)){
      p = p + coord_cartesian(xlim=c(xmin, xmax), ylim=c(ymin, ymax))
    } else {
      p = p + coord_cartesian(xlim=c(xmin, xmax))
    }
  } else if (!is.na(ymin) && !is.na(ymax)) {
    p = p + coord_cartesian(ylim=c(ymin, ymax))
  }
  
  return(p)
  
}