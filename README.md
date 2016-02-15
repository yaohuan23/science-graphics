# Science-Graphics
Collection of R scripts to generate common science figures.

### Goal
The purpose of this repository is to provide nicely formatted figures by DEFAULT directly from raw data files obtained from algorithms or programs, so that the pipeline from calculations to publication visualizations is automatized. 

Note that each script (which generates a single figure and an optional text output) is very specific for a type of analysis or application, so the scope of the repository is limited (although easy to extend to new applications).

### Examples
Some of the supported applications are:
- Classification
  - ![Confusion Matrix](figures/example2.pdf)
- Ranking
  - ![Precision-Recall Curve](figures/example3.pdf)
- Evolution
  - ODEs
  - MonteCarlo
  - Simulations
- Distribution
  - Single and Multiple Variable Histogram and Density
- Network

### Usage
Save the raw data file in the correct CSV format (`projectname.csv`) in the **data** folder. 
Run the appropiate script from the command line by typing:

```bash
./Path/To/Script.R projectname
```
Where `projectname` is the name of the project (without any extension).
An example is:

```bash
./ConfusionMatrixPlot.R example2
```
The created figures will be stored in the **figures** folder, in PDF format, as `projectname.pdf`.
Any created text result output will be stored in the **results** folder, in CSV format, as `projectname.csv`.

### Dependencies
- **R** version `3.0.2` or higher.
- Packages: 
  - `ggplot2`
  - `reshape2`
  - `plyr`
  - `mlearning`
  - `igraph`
