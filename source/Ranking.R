# Plots for evaluating the performance of a ranking system or algorithm
# Aleix Lafita - 02.2016

#' Represent the precision of a ranking result in function of the number
#' of retrieved results (recall)
#' @param data a single column df with 1 if the result is relevant, 0 otherwise
#' @return a ggplot object
precisionRecallCurve <- function(data) {
  
  # Ensure propper names of the data
  names(data) = c("Relevance")
  
  # Calculate cumulative sum and retrived
  data$Count = rep(1,nrow(data)) # add new column of ones
  data$Retrived = cumsum(data$Count) # calculate cumulative retrieval
  data$RelSum = cumsum(data$Relevance) # calculate the relevance sum
  
  # Transform data into cumulative precision values
  data$P1 = data$RelSum / data$Retrived # actual precision
  data$P2 = rev(cummax(rev(data$P1))) # nice precision
  
  # Transform data into cumulative recall values
  totalRel = sum(data$Relevance)
  data$Recall = data$RelSum / totalRel
  
  # Join precision and nice precision for plotting
  table = melt(data[,c("Recall","P1","P2")], 
               id.vars = "Recall", value.name = "Precision")
  
  # Create the curve
  p = ggplot(table, aes(x=Recall, y=Precision, colour=variable)) + 
    geom_line() + xlim(0.0, 1.0) + ylim(0.0,1.0) +
    guides(colour=FALSE) +
    theme_bw()
  
}