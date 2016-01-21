# Science-Graphics
Collection of R scripts to generate common science figures.

### Goal
The purpose of this repository is to provide nicely formatted figures by DEFAULT directly from raw data files. Note that each script (which generates a single figure) is very specific for a type of analysis or application.

### Examples
Some of the supported scientific applications are:
- Evolution
  - ODEs
  - MonteCarlo
  - Simulations
- Distributions
  - Histograms and Densities
- Benchmarking
  - ![Multi-Label Classification](figures/example2.pdf)
  - ROC Curves
  - ![Precision-Recall Curves](figures/example3.pdf)

### Usage
Save the raw data file in the correct CSV format (`projectname.csv`) in the **data** folder. 
Run the script from the command line by typing:

```bash
./Path/To/Script.R projectname
```
Where `projectname` is the name of the project without the extension. 
An example is:

```bash
./MultiLabelClassification.R example2
```
Any created figures will be stored in the **figures** folder, in PDF format, as `projectname.pdf`.
Any created table results will be stored in the **results** folder, in CSV format, as `projectname.csv`.

### Dependencies
- **R** version 3.0.2 or higher.
- Packages: 
  - `ggplot2`
  - `reshape`
