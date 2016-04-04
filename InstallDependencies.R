#!/usr/bin/env Rscript
# This script installs all the required dependencies for science-graphics
# R version 3.0.2 (2013-09-25) or higher

source("source/ScienceGraphicsIO.R")
printSGheader("Install Dependencies")

rep='http://cran.us.r-project.org'
#lib=path/to/lib/ if any preference

install.packages("ggplot2", repos=rep)
install.packages("gridExtra", repos=rep)
install.packages("grid", repos=rep)
install.packages("reshape2", repos=rep)
install.packages("plyr", repos=rep)
install.packages("mlearning", repos=rep)
install.packages("igraph", repos=rep)