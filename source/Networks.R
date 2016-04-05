# Draw a Network Graph
# Aleix Lafita - 03.2016

suppressPackageStartupMessages(library(igraph))

#' Draw a simple network graph with node labels and optionally
#' weighted edges.
#' 
#' @param data two columns for edge description and optional weight
#' @param directed undirected if FALSE, directed otherwise
#' @param plot an igraph plot object, use plot() function
drawNetworkGraph <- function(data, directed=TRUE) {
  
  g = graph.data.frame(data[c(1,2)], directed=directed)
  
  V(g)$color = "lemonchiffon"
  V(g)$label.color = "black"
  
  # Weighted graph only
  if (ncol(data)==3) {
    E(g)$width = data[,3]
    E(g)$label = data[,3]
    E(g)$label.color = "black"
  }
  
  return(g)
  
}