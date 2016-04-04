#Science-Graphics
Collection of R scripts to generate common science figures directly from the Linux command line.

## Goal
The purpose of this repository is to provide **nicely formatted figures** in R directly from **raw data files** obtained from algorithms or programs by simply running a single **command line** in the Linux shell. 
The main purpose is to automate the pipeline from data mining calculations to **publication** visualizations.

Note that each script (which generates a single figure and an optional text output) is very specific for a single type of analysis, so the scope of the repository is limited. 
However, the framework allows the easy extension of support for new applications.

## Usage
1. Save the raw data file in the specified CSV format (`projectname.csv`) in the **data** folder.
2. If your data file is not in the correct format, you can use some of the scripts in the **helper** folder to convert it.
3. Run the desired script from the command line by typing:

```bash
/path/to/science-graphics/scripts/Script.R projectname [-args=values] # projectname without extension
~/science-graphics/scripts/ConfusionMatrixPlot.R example_confusion-matrix -format=pdf -fontsize=5
```

The generated figures will be stored in the **figures** folder, in the desired format, as `projectname_scriptname`.
Any generated text results (statistics, summary, etc) will be stored in the **results** folder, in CSV format only, as `projectname_extension`.

To clear all the generated files for one project (or a subset) you can use the [ClearProject.sh](scripts/ClearProject.sh) script in the **helper** folder.
It will delete all files in the **figures** and **results** folder matching the project name.
The script does not delete any of the files in the **data** folder, so the raw data will be conserved.

```bash
/path/to/science-graphics/helper/ClearProject.sh projectname
/path/to/science-graphics/helper/ClearProject.sh example1  # This deletes figures and results of example1
/path/to/science-graphics/helper/ClearProject.sh example*  # This deletes all example projects at once
```

## Figures
The supported graphical visualisations are described here and example figures and input formats are shown alongside.
The scripts are divided into six statistical topics: 

1. [Distribution](#1-distribution)
2. [Correlation](#2-correlation)
3. [Classification](#3-classification)
4. [Ranking](#4-ranking)
5. [Evolution](#5-evolution)
6. [Networks](#6-networks)

### 1. Distribution
The [Distribution.R](source/Distribution.R) source file contains functions to visualize multivariate continuos and discrete **data distributions**.

#### 1.1. Continuous Distributions
Continuous variable distributions can be represented by histograms, density curves, box plots or violin plots. The input format is shared for all of them, consisting of an optional **Name** column, a **Group** variable column and a **Value** column (see the [example file](data/example7.csv)).

Name | Group | Value |
---|---|---|---
Character | Factor | Numeric |

The shell script [AllContinousDistributions.sh](scripts/AllContinuousDistributions.sh) generates all the available plots for continuous data distributions at once.

##### 1.1.1. Histogram Density Plot
For a set of continuous variables in the same units, the [HistogramDensityPlot.R](scripts/HistogramDensityPlot.R) script plots their density lines together with the underlying histograms slightly transparent in the same plot. The histogram is scaled to the densisty line.

![figure](figures/example1_density.png)

##### 1.1.2. Box Plot
As the number of variables increases and their superposed densities become difficult to visualize, the alternative is to generate a box plot or violin plot. Box plots represent the mean, median and percentiles of each variable distribution, so that they can be visually compared. The [BoxPlot.R](scripts/BoxPlot.R) script generates such a figure.

![figure](figures/example7_boxplot.png)

##### 1.1.3. Violin Box Plot
However, multimodal properties of the distribution cannot be observed in a simple box plot. A violin plot is needed for that purpose. The [ViolinBoxPlot.R](scripts/ViolinBoxPlot.R) script allows the independent visualization of each variable distribution with its underlying boxplot.

![figure](figures/example7_violinplot.png)

#### 1.2. Discrete Distributions
Discrete data distributions can be represented by pie charts or bar plots, where the percentage and/or frequency of each class (or label, or type) can be visualized.

##### 1.2.1. Pie Chart
The pie chart is the simplest of the visualization and allows only the representation of a single variable distribution in each figure. The [PieChart.R](scripts/PieChart.R) script takes as input an optional **Name** column and a **Class** column (see the [example file](data/example6.csv)).

Name | Class |
---|---|---
Character | Factor |

![figure](figures/example6.png)

##### 1.2.2. Bar Plot
The bar plot allows the representation of multiple variables in the same figure. The [BarPlot.R](scripts/BarPlot.R) script takes as input an optional **Name** column, a **Group** variable column and a **Class** column (see the [example file](data/example5.csv)).

Name | Group | Class |
---|---|---|---
Character | Factor | Factor |

![figure](figures/example5.png)

### 2. Correlation

The [Correlation.R](source/Correlation.R) source file contains functions to evaluate and visualize the correlation of discrete variable pair counts (contingency table) and continuous variables.

#### 2.1. Contingency Table Plot
For discrete variables, the [ContingencyTableBarplot](scripts/ContingencyTableBarplot.R) plots the percentage or frequency of each class combination from two variables as a barplot.
An example figure can be found [here](figures/example5.pdf).

#### 2.2. Correlation 2D Plot

Coming soon...
  - Contingency Table Plot
  - Correlation Distribution Plot

### 3. Classification
The [Classification.R](source/Classification.R) source file contains functions to visualize and evaluate the performance of a **classifier**, which assigns a class (label) to query data points.

#### 3.1. Confusion Matrix Plot
The most detailed representation of a classifier result is the [confusion matrix](https://en.wikipedia.org/wiki/Confusion_matrix). 
The script [ConfusionMatrix](scripts/ConfusionMatrix.R) plots each entry of the matrix as a tile colored by the fraction of the predicted class for its actual class and prints the total number of predictions (the matrix entry) only if it is different than 0.

![figure](figures/example2.png)

#### 3.2. ROC Curve
The [Receiver Operating Characteristic (ROC)](https://en.wikipedia.org/wiki/Receiver_operating_characteristic) curve is a graphical plot that illustrates the performance of a binary classifier system as its discrimination threshold is varied. The curve is created by plotting the true positive rate (TPR) against the false positive rate (FPR) at various threshold settings.

![figure](figures/example10.png)

### 4. Ranking
The [Ranking.R](source/Ranking.R) source file contains functions to visualize and evaluate the performance of a **ranking algorithm**.
The results must have a **relevance score**, which can be binary (0 is non-relevant, 1 is relevant), discrete (e.g, scale of relevance from 1 to 5, 5 being the most relevant) or continuous (e.g, relevance score between 0 and 1).
The ranking algorithm returns an input set sorted by relevance, where most relevant relevant inputs are at the top (beginning).
Given the position of each input in the resulting sorted set and its relevance score, the performance of the algorithm is determined. 

#### 4.1. Precision-Recall Curve
For binary relevance scores, the [PrecisionRecallCurve](scripts/PrecisionRecallCurve.R) script plots the precision in function of the recall, what is called PR curve.

[figure](figures/example3.png)
  
### 5. Evolution
The [Evolution.R](source/Evolution.R) source file contains functions to visualize variable fluctuations and evolution in function of time (ODEs), step (MC simulations) or other independent variables.

#### 5.1. Evolution Plot
The [EvolutionPlot.R](scripts/EvolutionPlot.R) script accepts as an input multiple variables (in different units) and multiple runs (or instances) and arranges them in a multiplot.

![figure](figures/example4.png)
  
### 6. Networks
The [Networks.R](source/Networks.R) source file contains functions to visualize graphs.

#### 6.1. Network Graph
For a simple graph with optional weighted or labeled edges the [NetworkGraph.R](scripts/NetworkGraph.R) script can be used.

![figure](figures/example8.png)

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
