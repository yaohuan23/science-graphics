#!/usr/bin/env Rscript
# This script plots a DAG. The input file contains 2 mandatory columns,
# for specifying the edges
# Aleix Lafita - 03.2016

# Import all the source files needed
source("../source/ScienceGraphicsIO.R")
source("../source/Networks.R")

printSGheader("Network Graph")

# Project name
file = "example_network"
format = "pdf"
dir = TRUE

# Options for specific parameters of this plot
option_list = c(createOptionsIO(file, format),
  make_option(c("-d", "--directed"), action="store_true", default=dir,
              help="Directed graph [default]"),
  make_option(c("-u", "--undirected"), action="store_false", dest="directed",
              help="Undirected graph")
)
opt = parse_args(OptionParser(option_list=option_list))

data = parseFile(opt$input)
g = drawNetworkGraph(data, opt$directed)

saveRPlot(paste(opt$input, "network-graph", sep="_"), g, opt$output)
