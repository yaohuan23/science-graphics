# Science-Graphics
Collection of R scripts to generate common science figures.

### Goal
The purpose of this repository is to provide nicely formatted figures by DEFAULT directly from raw data files. Note that each script (which generates a single figure) is very specific for a type of analysis or application.

### Examples
Some of the supported scientific applications are:
- Variable Evolution
  - ODEs
  - MonteCarlo Simulations
- Variable Distributions
  - Histograms and Densities
  - Multiple-Set Distribution
- Benchmarking
  - ![Multi-Label Classification](figures/example2.pdf)
  - ROC Curves
  - ![Precision-Recall Curves](figures/example3.pdf)

### Usage
Save the raw data file in the correct CSV format in the **data** folder. Run the script from the command line by typing:

```bash
./Path/To/Script.R filename
```
Where `filename` is the name of the file without the extension. An example is:

```bash
./MultipleLabelClassification.R example2
```

The generated figure will be stored in the **figures** folder in PDF format, with the same name as the file.

### Dependencies

- ggplot2
- R3.1
