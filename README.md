# Science-Graphics
Collection of R scripts to generate common science figures.

### Goal
The purpose of this repository is to provide nicely formatted figures by DEFAULT directly from raw data files obtained from algorithms or programs, so that the pipeline from calculations to publication visualizations is automatized. 

Note that each script (which generates a single figure and an optional text output) is very specific for a single type of analysis, so the scope of the repository is limited. However, the framework allows the easy extension of support for new applications.

### Applications
Some of the supported applications are:
- [Classification](source/Classification.R)
  - ![Confusion Matrix](figures/example2.pdf)
- [Ranking](source/Ranking.R)
  - ![Precision-Recall Curve](figures/example3.pdf)
- [Evolution](source/Evolution.R)
  - [Multiple Variables](figures/example4.pdf)
- [Distribution](source/Distribution.R)
  - [Multivariate Histogram and Density](figures/example1.pdf)
  - Pie Chart
- Network
  - Cyclic Graph
  - Directed Acyclic Graph (DAG)

### Usage
Save the raw data file in the correct CSV format (`projectname.csv`) in the **data** folder. 
Run the appropiate script from the command line by typing:

```bash
./Path/To/Script.R projectname  # the name of the project is without any extension
./ConfusionMatrixPlot.R example2
```

The created figures will be stored in the **figures** folder, in PDF format, as `projectname.pdf`.
Any created text result output will be stored in the **results** folder, in CSV format, as `projectname.csv`.

To clear all the generated files for one project (or a subset) you can use the [ClearProject](scripts/ClearProject.sh) script. 
It will delete any file in the **figures** and **results** folder matching the input name.
The script does not delete any of the files in the **data** folder, so the raw data will be conserved.

```bash
./ClearProject.sh projectname
./ClearProject.sh example1  # This delete figures and results of example1
./ClearProject.sh example*  # This will delete all example projects at once
```

### Dependencies
- **R** version `3.0.2` or higher.
- Packages: 
  - `ggplot2`
  - `gridExtra`
  - `reshape2`
  - `plyr`
  - `mlearning`
  - `igraph`
