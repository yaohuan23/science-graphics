#Science-Graphics
Collection of R scripts to generate common science figures directly from the Linux command line.

## Goal
The purpose of this repository is to provide **nicely formatted figures** in R directly from **raw data files** obtained from algorithms or programs by simply running a single **command line** in the Linux shell. 
The main purpose is to automate the pipeline from data mining calculations to **publication** visualizations.

Note that each script (which generates a single figure and an optional text output) is very specific for a single type of analysis, so the scope of the repository is limited. 
However, the framework allows the easy extension of support for new applications.

## Supported Graphs
The supported graphical visualisations are described here and example figures and input formats are shown alongside.
The scripts are divided into six statistical topics: **distribution**, **correlation**, **classification**, **ranking**, **evolution** and **networks**.

### 1 Distribution

The [Distribution.R](source/Distribution.R) source file contains functions to visualize continuos and discrete **data distributions**.

#### 1.1 Continuous Variable Distributions

Continuous variable distributions can be represented by histograms, density curves, box plots or violin plots. The input format is shared for all of them, consisting of an optional **Name** column, a **Factor** variable column and a **Value** column (see the [example file](data/example7)).

Name | Factor | Value |
---|---|---|---
point 1 | group 1 | 0.5 |
point 2 | group 1 | 0.75 |
point 3 | group 2 | 0.23 |
... | ... | ... |

The bash script [AllContinousDistributions.sh](scripts/AllContinuousDistributions.sh) generates all the available plots for continuous data distributions at once.

##### 1.1.1 Histogram Density Plot

For a set of continuous variables in the same units, the [HistogramDensityPlot.R](scripts/HistogramDensityPlot.R) script plots their density line together with the underlying histogram slightly transparent in the same figure. The histogram is scaled to the densisty line, so that all variables can be visualized in the same plot.

An example figure can be found [here](figures/example1_density.pdf).

##### 1.1.2 Box Plot

As the number of variables increases and their superposed densities become difficult to visualize, the alternative is to generate a box plot or violin plot. Box plots represent the mean, median and percentiles of each variable distribution, so that they can be visually compared. The [BoxPlot.R](scripts/BoxPlot.R) script generates such a figure.
An example figure can be found [here](figures/example7_boxplot.pdf).

##### 1.1.3 Violin Box Plot

However, multimodal properties of the distribution cannot be observed in a simple box plot, and a violin plot is needed for that purpose. The [ViolinBoxPlot.R](scripts/ViolinBoxPlot.R) script allows the independent visualization of each variable distribution with its underlying boxplot.
An example figure can be found [here](figures/example7_violinplot.pdf).

For discrete variables, the percentage and frequency of each class can be visualized using the [PieChart.R](scripts/PieChart.R) script.
An example figure can be found [here](figures/example6.pdf).

### 2. Correlation

The [Correlation.R](source/Correlation.R) source file contains functions to calculate and visualize the **contingency table** of two discrete variable counts and the correlation of continuous variables.

For discrete variables, the [ContingencyTableBarplot](scripts/ContingencyTableBarplot.R) plots the percentage or frequency of each class combination from two variables as a barplot.
An example figure can be found [here](figures/example5.pdf).

Coming soon...
  - Contingency Table Plot
  - Correlation Distribution Plot

### 3. Classification

The [Classification.R](source/Classification.R) source file contains functions to visualize and evaluate the performance of a **classifier**, which assigns a class (label) to query data points.

The most detailed representation of a classifier result is the [confusion matrix](https://en.wikipedia.org/wiki/Confusion_matrix). 
The script [ConfusionMatrix](scripts/ConfusionMatrix.R) plots each entry of the matrix as a tile colored by the fraction of the predicted class for its actual class and prints the total number of predictions (the matrix entry) only if it is different than 0.
An example figure can be found [here](figures/example2.pdf).

Coming soon...
  - Confusion Matrix Statistics
  - ROC Curve

### 4. Ranking

The [Ranking.R](source/Ranking.R) source file contains functions to visualize and evaluate the performance of a **ranking algorithm**.
The results must have a **relevance score**, which can be binary (0 is non-relevant, 1 is relevant), discrete (e.g, scale of relevance from 1 to 5, 5 being the most relevant) or continuous (e.g, relevance score between 0 and 1).
The ranking algorithm returns an input set sorted by relevance, where most relevant relevant inputs are at the top (beginning).
Given the position of each input in the resulting sorted set and its relevance score, the performance of the algorithm is determined. 

For binary relevance scores, the [PrecisionRecallCurve](scripts/PrecisionRecallCurve.R) script plots the precision in function of the recall, what is called PR curve.
An example figure can be found [here](figures/example3.pdf).
  
### 5. Evolution

The [Evolution.R](source/Evolution.R) source file contains functions to visualize variable fluctuations and evolution in function of time (ODEs), step (MC simulations) or other independent variables.

The [EvolutionPlot.R](scripts/EvolutionPlot.R) script accepts as an input multiple variables (in different units) and multiple runs (or instances) and arranges them in a multiplot.
An example figure can be found [here](figures/example4.pdf).
  
### 6. Networks

The [Networks.R](source/Networks.R) source file contains functions to visualize graphs.

For a simple graph with optional weighted or labeled edges the [NetworkGraph.R](scripts/NetworkGraph.R) script can be used.
An example figure can be found [here](figures/example8.pdf).

## Usage
Save the raw data file in the specified CSV format (`projectname.csv`) in the **data** folder.
If your data file is not in the correct format, you can use some of the scripts in the **helper** folder to convert them.
Change to the scripts directory and run the desired script from the command line by typing:

```bash
cd /path/to/science-graphics/scripts
./Script projectname [args] # the name of the project without extension, optional arguments
./ConfusionMatrixPlot.R example2 5
```

The generated figures will be stored in the **figures** folder, in PDF and SVG formats, as `projectname.pdf` and `projectname.svg`.
Any generated text results (statistics, summary, etc) will be stored in the **results** folder, in CSV format, as `projectname_*.csv`.

To clear all the generated files for one project (or a subset) you can use the [ClearProject](scripts/ClearProject.sh) script in the **helper** folder.
It will delete all files in the **figures** and **results** folder matching the project name.
The script does not delete any of the files in the **data** folder, so the raw data will be conserved.

```bash
./ClearProject.sh projectname
./ClearProject.sh example1  # This deletes figures and results of example1
./ClearProject.sh example*  # This deletes all example projects at once
```

## Dependencies
- **R** version `3.0.2` or higher.
- Packages: 
  - `ggplot2`
  - `gridExtra`
  - `grid`
  - `reshape2`
  - `plyr`
  - `mlearning`
  - `igraph`

## References

Some of the plots have been taken from the book *R Graphics Cookbook*, written by Winston Chang and published by O'REILLY.
