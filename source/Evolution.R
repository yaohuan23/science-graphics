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
#' @return a grob object
multipleEvolutionPlot <- function(data) {
  
  plots = vector("list", ncol(data)-2)
  for (i in 3:ncol(data)) {
    p = singleEvolutionPlot(data[c(1,2,i)])
    
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
#' @return a ggplot object
singleEvolutionPlot <- function(data) {
  
  p = ggplot(data, aes_q(x=as.name(names(data)[2]), y=as.name(names(data)[3]), 
                         color=as.name(names(data)[1]))) + 
               geom_line() + geom_point() + theme_bw() #+ scale_x_discrete()
    
}