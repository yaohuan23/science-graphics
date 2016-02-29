# Draw a Network Graph
# Aleix Lafita - 03.2016

library(igraph)

#' Draw a simple network graph with node labels and optionally
#' weighted edges.
#' 
#' @param data two columns for edge description and optional weight
#' @param directed undirected if FALSE, directed otherwise
drawNetworkGraph <- function(data, directed=TRUE) {
  
  g = graph.data.frame(data[c(1,2)], directed=directed)
  
  # Weighted or unweighted
  if (ncol(data)==3) {
    plot(g, edge.width=data[,3])
  } else {
    plot(g)
  }
  
}