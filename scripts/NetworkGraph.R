#!/usr/bin/env Rscript
# This script plots a Graph in a 2D plane.
# The input file a row for each edge.
# Additionally, a layout file can be given with the x and y 
# positions of each vertex.
# Aleix Lafita - 03.2016

source("../source/ScienceGraphicsIO.R")
suppressPackageStartupMessages(library(igraph))

printSGheader("Network Graph")

# Project name
edges = NA
vertices = NA
output = NA
from = NA
to = NA
eLabels = NA
eSize = NA
eColor = NA
vLabels = NA
x = NA
y = NA
vSize = NA
vColor = NA
dir = TRUE
set.seed(0)

# Options for specific parameters of this plot
option_list = c(
  make_option(c("-e", "--edges"), type="character", default=edges,
              help="Input CSV or TSV data file. Each row contains an
                    edge, i.e. vertex pair (required)",
              metavar="file"),
  make_option(c("-v", "--vertices"), type="character", default=vertices,
              help="Input CSV or TSV data file. Each row contains vertex
                    properties (position[x,y], size, label)",
              metavar="file"),
  make_option(c("-o", "--output"), type="character", default=output,
              help="Output figure file. Supported pdf, svg and png
                    extensions (required)",
              metavar="file"),
  make_option(c("-f", "--from"), type="character", default=from,
              help="Column name of the edges file containing the origin
                    vertices [default first column]",
              metavar="column"),
  make_option(c("-t", "--to"), type="character", default=to,
              help="Column name of the edges file containing the destination
                    vertices [default second column]",
              metavar="column"),
  make_option("--eLabels", type="character", default=eLabels,
              help="Column name of the edges file containing the labels",
              metavar="column"),
  make_option("--eSize", type="character", default=eSize,
              help="Column name of the edges file containing the size.
                    Use [all:number] to specify the size of all edges",
              metavar="column"),
  make_option("--eColor", type="character", default=eColor,
              help="Column name of the vertices file containing the color 
                    factor (variable to split vertices into color groups).
                    Use [all:Rcolor] to specify the color of all vertices",
              metavar="column"),
  make_option("--vLabels", type="character", default=vLabels,
              help="Column name of the vertices file containing the labels.
                    Use [default] to show vertex labels from edges file",
              metavar="column"),
  make_option(c("-x", "--x"), type="character", default=x,
              help="Column name of the vertices file containing the x
                    coordinate for the layout [deafult second column]",
              metavar="column"),
  make_option(c("-y", "--y"), type="character", default=y,
              help="Column name of the vertices file containing the y
                    coordinate for the layout [deafult third column]",
              metavar="column"),
  make_option("--vSize", type="character", default=vSize,
              help="Column name of the vertices file containing the size.
                    Use [all:number] to specify the size of all vertices",
              metavar="column"),
  make_option("--vColor", type="character", default=vColor,
              help="Column name of the edges file containing the color 
                    factor (variable to split edges into color groups).
                    Use [all:Rcolor] to specify the color of all edges",
              metavar="column"),
  make_option(c("-d", "--directed"), action="store_true", default=dir,
              help="Directed graph [default]"),
  make_option(c("-u", "--undirected"), action="store_false", dest="directed",
              help="Undirected graph")
)
opt = parse_args(OptionParser(option_list=option_list))

# Check presence of the required inputs
if (is.na(opt$edges)){
  cat("   ERROR: Missing required edges file\n")
  stop()
}

# Parse and sort the edges
edges = parseFile(opt$edges)
if (is.na(opt$from))
  opt$from = names(edges)[1]
if (is.na(opt$to))
  opt$to = names(edges)[2]
edges = edges[order(edges[[opt$from]]),]

# Parse and sort the vertices if given
if (!is.na(opt$vertices)){
  vertices = parseFile(opt$vertices)
  if (is.na(opt$vLabels) && !identical(opt$vLabels,"default")){
    vertices = vertices[order(vertices[[1]]),]
  } else {
    vertices = vertices[order(vertices[[opt$vLabels]]),]
  }
}

# Create the graph from the edges
g = graph.data.frame(edges[c(opt$from,opt$to)], directed=opt$directed)

# Styling options for the vertices
V(g)$label.color = "black"
if (!is.na(opt$vLabels) && !is.na(vertices) 
                        && !identical(opt$vLabels,"default")){
  V(g)$label = as.character(vertices[[opt$vLabels]])
} else if (!identical(opt$vLabels,"default")){
  V(g)$label = NA
}
if (!is.na(opt$vSize)){
  if (grepl("all:",opt$vSize)){
    V(g)$size = as.numeric(gsub('all:','',opt$vSize))
  } else if (!is.na(vertices)){
    V(g)$size = as.numeric(vertices[[opt$vSize]])
  }
}
if (!is.na(opt$vColor)){
  if (grepl("all:",opt$vSize)){
    V(g)$color = as.character(gsub('all:','',opt$vColor))
  } else if (!is.na(vertices)){
    V(g)$color = as.factor(vertices[[opt$vColor]])
  }
}

# Styling options for the edges
if (!is.na(opt$eLabels)){
  E(g)$label = as.character(edges[[opt$eLabels]])
  E(g)$label.color = "black"
}
if (!is.na(opt$eSize)){
  if (grepl("all:",opt$eSize)){
    size = as.numeric(gsub('all:','',opt$eSize))
    E(g)$width = size
    E(g)$arrow.size = 0.25 + 0.5 * min(size, 5) # arrow grows too fast
  } else {
    E(g)$width = as.numeric(edges[[opt$eSize]])
    E(g)$arrow.size = 0.25 + 0.5 * min(max(E(g)$width), 5)
  }
}
if (!is.na(opt$eColor)){
  if (grepl("all:",opt$eColor)){
    E(g)$color = as.character(gsub('all:','',opt$eColor))
  } else {
    E(g)$color = as.factor(edges[[opt$eColor]])
  }
}

# Figure output format setting
if (grepl(".pdf",opt$output)) {
  pdf(opt$output)
} else if (grepl(".svg",opt$output)) {
  svg(opt$output)
} else if (grepl(".png", opt$output)) {
  png(opt$output, height = 4096, width = 4096, res = 600)
} else {
  cat("   ERROR: Unsupported figure format requested\n")
  stop()
}

# Set the layout if x and y specified
if (!is.na(opt$x) && !is.na(opt$y) && !is.na(vertices)){
  coords = data.frame(as.numeric(vertices[[opt$x]]))
  coords$y = as.numeric(vertices[[opt$y]])
  coords = as.matrix(coords)
  plot(g, layout=coords)
} else {
  plot(g)
}
log = dev.off() # Supress printing 'null device'
cat(paste("   Saved figure to", opt$output, "\n"))
