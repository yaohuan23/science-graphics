# Visualize discrete and continuous variable correlations
# Aleix Lafita - 02.2016

library(ggplot2)
library(reshape2)

#' Plot the contingency table as a barplot.
#' The total number of observables are printed at the top.
#' 
#' @param data two columns, one for each compared discrete variable
#' @param type either Frequency for totals or Percentage for relative
#' @param position type of barplot: stack or dodge
#' @return ggplot2 object
plotContingencyTableBar = function(data, type="Percentage", position="stack") {
  
  # Store the original names in the data
  original = names(data)
  
  # Create the contingency table and calculate percentages
  freq = table(data[,1], data[,2])
  percent = prop.table(freq, 1)
  
  # Melt the table and merge frequency and percentages
  data = melt(freq)
  data$Percentage = melt(percent)$value * 100
  names(data) = c(original, "Frequency", "Percentage")
  
  # Add the total number of observables at the top of the bars
  total = margin.table(freq, 1)
  ypos = 105
  if (type == "Frequency") {
    if (position == "dodge") {
      ypos = 1.05 * max(data$Frequency)
    } else {
      ypos = 1.05 * max(total)
    }
  }
  pos = rep(ypos,nrow(freq))
  labels = data.frame(total, pos)
  names(labels) = c(original[1], "Total", "Position")
  
  p = ggplot(data, aes_q(x=as.name(names(data)[1]), y=as.name(type))) + 
    geom_bar(stat="identity", position=position,
             aes_q(fill=as.name(names(data)[2]))) +
    geom_text(data=labels, aes(x=Group, y=Position, label=Total), size=4) +
    theme_bw()
  
}