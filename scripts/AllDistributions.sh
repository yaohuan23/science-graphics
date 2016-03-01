#!/bin/bash
./HistogramDensityPlot.R $1 0 $2 $3
./BoxPlot.R $1 $2 $3
./ViolinBoxPlot.R $1 $2 $3
