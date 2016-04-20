#Science-Graphics
Collection of R scripts to generate common science figures directly from the Linux command line.

## Goal
The purpose of this repository is to provide **nicely formatted figures** in R directly from **raw data files** obtained from algorithms or programs by simply running a single **command line** in the Linux shell. 
The main purpose is to automate the pipeline from data mining calculations to **publication** visualizations.

Note that each script (which generates a single figure and an optional text output) is very specific for a single type of analysis, so the scope of the repository is limited. 
However, the framework allows the easy extension of support for new applications.

## Installation & Usage
1. Make sure you have the [R](https://cran.r-project.org) programming language (version `3.0.2` or higher) installed in your system and that `Rscript` is in your path.
2. Clone locally this github repository wherever you want (`git clone https://github.com/lafita/science-graphics.git`).
3. Open a new terminal window and move to the **science-graphics** directory.
4. Allow execution access to all the scripts (`chmod 744 *.R`)
5. Run the [InstallDependencies.R](InstallDependencies.R) script to install all the required R packages.
6. From the **science-graphics** directory ([why do I need to stay in the science-graphics directory?](https://github.com/lafita/science-graphics/issues/12)), now you can run any of the other scripts.

```bash
cd /path/to/science-graphics
./Script.R [options]
./Script.R -h # print help options
./Script.R -i input.tsv -o ouput.png # an example
```

## Figures
The supported graphical visualisations are described here and example figures and input formats are shown alongside.
The scripts are divided into six categories: 

1. [Distribution](#1-distribution)
2. [Correlation](#2-correlation)
3. [Classification](#3-classification)
4. [Ranking](#4-ranking)
5. [Evolution](#5-evolution)
6. [Networks](#6-networks)

### 1. Distribution
The shared code for all scripts is in [Distribution.R](source/Distribution.R).

#### 1.1. Continuous Distributions
Continuous variable distributions can be represented by histograms, density curves, box plots or violin plots. The input can be given with a single file, where each column contains a collection of observations: [example](examples/distributions.csv)).

Use the `ContinuousDistribution.R` script to generate any type.

##### 1.1.1. Histogram
For a set of continuous variables in the same units, the **hist** type option plots their histograms slightly transparent in the same plot.

```bash
./ContinuousDistribution.R -i examples/distributions.csv 
                           -o examples/distributions_hist.png
                           -t hist --bin 1 --ylab Count
```

<img src="examples/distributions_hist.png" width="500">

##### 1.1.2. Density

##### 1.1.3. Histogram & Density

##### 1.1.3. Box Plot
As the number of variables increases and their superposed densities become difficult to visualize, the alternative is to generate a box plot or violin plot. Box plots represent the mean, median and percentiles of each variable distribution, so that they can be visually compared. Use the **box** type option to generate a box plot.

```bash
./ContinuousDistribution.R -i examples/distributions.csv 
                           -o examples/distributions_box.png
                           -v Binomial,Poisson
                           -t box --ylab Number --xlab Distribution
                           --min 0 --max 80
```

<img src="examples/distributions_box.png" width="500">

##### 1.1.4. Violin Plot
However, multimodal properties of the distribution cannot be observed in a simple box plot. A violin plot is needed for that purpose. The **violin** type option allows the independent visualization of each variable distribution with its underlying boxplot.

#### 1.2. Discrete Distributions
Discrete data distributions can be represented by pie charts or bar plots, where the percentage and/or frequency of each class (or label, or type) can be visualized.

##### 1.2.1. Pie Chart
The pie chart is the simplest of the visualization and allows only the representation of a single variable distribution in each figure. The [PieChart.R](scripts/PieChart.R) script takes as input an optional **Name** column and a **Class** column (see the [example file](data/example_discrete-distribution-single.csv)).

Name | Class |
---|---|---
Character | Factor |

![figure](figures/example_discrete-distribution-single_pie-chart.png)

##### 1.2.2. Bar Plot
The bar plot allows the representation of multiple variables in the same figure. The [BarPlot.R](scripts/BarPlot.R) script takes as input an optional **Name** column, a **Group** variable column and a **Class** column (see the [example file](data/example_discrete-distribution-multiple.csv)).

Name | Group | Class |
---|---|---|---
Character | Factor | Factor |

![figure](figures/example_discrete-distribution-multiple_barplot.png)

### 2. Correlation

The [Correlation.R](source/Correlation.R) source file contains functions to evaluate and visualize the correlation of discrete variable pair counts (contingency table) and continuous variables.

#### 2.1. Contingency Table Plot
For discrete variables, the [BarPlot.R](scripts/BarPlot.R) plots the percentage or frequency of each class combination from two variables as a barplot. The example figure can be found in section *1.1.2. Bar Plot*.

#### 2.2. Correlation 2D Plot
For two continuous variables, their correlation is described by fitting a line to a set of value pairs. 
The [Correlation2DPlot.R](scripts/Correlation2DPlot.R) represents the value pairs as points and draws the line that minimizes the squared error (LSE). 
The input consists of an optional **Name** column, an optional **Group** variable and two columns, one for each of the variables **Value** (see the [example file](data/example_correlation-2d.csv)).

Name | Group | Value 1 | Value 2 |
---|---|---|---|---
Character | Factor | Numeric | Numeric |

![figure](figures/example_correlation-2d_correlation.png)

### 3. Classification
The [Classification.R](source/Classification.R) source file contains functions to visualize the output and evaluate the performance of **classifiers**, which assigns a class (label) to query data points.

#### 3.1. Confusion Matrix Plot
The most detailed representation of a classifier result is the [confusion matrix](https://en.wikipedia.org/wiki/Confusion_matrix). 
The script [ConfusionMatrix](scripts/ConfusionMatrix.R) plots each entry of the matrix as a tile colored by the fraction of the predicted class for its actual class and prints the total number of predictions (the matrix entry) only if it is different than 0.
The input data consists of a set of predictions, organized in an optional **Name** column, an **Actual** (truth) column and a **Prediction** column (see the [example file](data/example_confusion-matrix.csv).

Name | Actual | Prediction |
---|---|---|---
Character | Factor | Factor |

![figure](figures/example_confusion-matrix_conf-matrix.png)

#### 3.2. ROC Curve
The [Receiver Operating Characteristic (ROC)](https://en.wikipedia.org/wiki/Receiver_operating_characteristic) curve is a graphical plot that illustrates the performance of a binary classifier system as its discrimination threshold is varied. 
The curve is created by plotting the true positive rate (TPR) against the false positive rate (FPR) at various threshold settings.
The input data consists of an optional **Name** column, an **Algorithm** column (if multiple algorithms are compared), a score **Value** column and a **Relevance** column, where 1 means positive/relevant and 0 negative/irrelevant (see the [example file](data/example_roc-curve.csv)).

Name | Algorithm | Value | Relevance |
---|---|---|---
Character | Factor | Numeric | Factor |

![figure](figures/example_roc-curve_roc-curve.png)

### 4. Ranking
The [Ranking.R](source/Ranking.R) source file contains functions to visualize and evaluate the performance of a **ranking algorithm**.
The results must have a **relevance score**, which can be binary (0 is non-relevant, 1 is relevant), discrete (e.g, scale of relevance from 1 to 5, 5 being the most relevant) or continuous (e.g, relevance score between 0 and 1).
The ranking algorithm returns an input set sorted by relevance, where most relevant relevant inputs are at the top (beginning).
Given the position of each input in the resulting sorted set and its relevance score, the performance of the algorithm is determined by a score that trades-off precision and recall in the ranking list.

#### 4.1. Precision-Recall Curve
For binary relevance scores, the [PrecisionRecallCurve](scripts/PrecisionRecallCurve.R) script plots the precision in function of the recall, what is called PR curve.
The input consists of an optional **Name** column and a **Relevance** score column, which is sorted in the ranking order returned by the algorithm (see the [example file](data/example_pr-curve.csv)).

Name | Relevance |
---|---|
Character | Numeric |

![figure](figures/example_pr-curve_pr-curve.png)
  
### 5. Evolution
The [Evolution.R](source/Evolution.R) source file contains functions to visualize variable fluctuations and evolution in function of time (ODEs), step (MC simulations), or other independent variables (like wavelength, distance, etc).

#### 5.1. Evolution Plot
The [EvolutionPlot.R](scripts/EvolutionPlot.R) script accepts as an input multiple variables (in different units) and multiple runs (or instances) and arranges them in a multiplot.
The input consists of an optional **Name** column, a **Group** column (for each run or instance), a **Independent** variable column (time, step) and multiple **Dependent** variable columns (see the [example file](data/example_evolution.csv)).

Name | Group | Independent | Dependent 1 | Dependent 2 | ... | Dependent N |
---|---|---|---|---|---|---|
Character | Factor | Numeric | Numeric | Numeric | Numeric | Numeric |

![figure](figures/example_evolution_evolution.png)
  
### 6. Networks
The [Networks.R](source/Networks.R) source file contains functions to visualize graphs.

#### 6.1. Network Graph
For a simple graph with optional weighted or labeled edges the [NetworkGraph.R](scripts/NetworkGraph.R) script can be used.
The input consists of a set of edges, specified by the columns **From** and **To**, followed by an optional **Weight** column for the edge (see the [example file](data/example_network.csv)).

From | To | Weight
---|---|---
Factor | Factor | Numeric

![figure](figures/example_network_network-graph.png)

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
  - `ROCR`

## References

Some of the plots have been taken from the book *R Graphics Cookbook*, written by Winston Chang and published by O'REILLY.
