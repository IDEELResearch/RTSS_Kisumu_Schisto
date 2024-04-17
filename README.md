# RTSS_Kisumu_Schisto

This repository is for the RTS,S AS,01 MVIE subproject evaluating S. mansoni exposure on the function vaccine reponse in the Kisumu cohort. This project is a collaboration between U Mass, UNC, MIT, Harvard, and Brown University.

Sahal Thahir [sahal\@ad.unc.edu](mailto:sahal@ad.unc.edu) (703)344-6153

## Directory Set up

This repository is set up to allow for the extraction of Median MFI data from raw Luminex Xponent .csv files. It is set-up so that if this full repository is downloaded, the system can be used for any luminex study for plate-level quality control, median MFI aggregation, and MFI standardization across multiple plates.

### Repository Folders

#### code

This can be used for study specific R coding. Currently it holds some early code I'll be integrating into the markdown documents

#### data

This is where *data files* (raw and clean) are to be stored. There are three folders are required within this folder for the code to work well. - **data/raw:** This is where raw files should go. data/raw/luminex was placed so other raw files (ex: qPCR) could also be placed in separate folders. *data/raw/luminex* is where the Rmarkdown code will extract csv files. These files will not be changed when running the code - **data/clean:** median MFI extracted from each raw file will be within the *data/clean/luminex*. The compiled dataframe is within the main folder after the code is run. - **data/qc**: Quality control outputs from [Luminex Xponent_Plate level QC.Rmd]()

#### results

This is for general storage of plots, analysis, for results presentation.

## R Markdown code explanation

### [Luminex Xponent_Plate level QC.Rmd]()

### [Luminex standardization across multiple plates.Rmd]()

These code chunks collectively aim to standardize MFI values across multiple plates in Luminex experiments.

**Library loads:** This chunk loads necessary R libraries, including tidyverse, here, and ggpubr.

1.  **Generation of standards dataframe**: This chunk extracts standards data from all plates, creates a standards dataframe, calculates dilution factors, categorizes MFI columns, creates an Antigen column, calculates log10(MFI), and selects specific columns. It also prints the unique Plates.

2.  **Standard curves for all antigens:** This chunk plots standard curves for each antigen, calculates correlation and R-squared values for each subclass, and displays the plots.

3.  **Define standard antigen:** This chunk defines the standard antigen of interest.

4.  **Standard Ag plots:** This chunk filters data for the standard antigen, filters out rows with zero dilution factor or NA MFI, calculates correlation and R-squared for each subset, and creates scatterplots with filtered data, facetted by subclass.

5.  **Line of best fit for each plate:** This chunk calculates Pearson correlation coefficient, line of best fit equation, and R-squared values for each plate, and plots with correlation text annotations. It also creates a dataframe to store plate statistics.

6.  **Average line of best fit for each Subclass:** This chunk creates average fit lines for each subclass based on the calculated plate statistics.

7.  **Determine scaling factor:** This chunk joins the average slope and intercept with the plate statistics, calculates the scaling factor using a selected dilution factor, and displays plate statistics with scaling factor.

8.  **Testing scaling on standard antigen:** This chunk tests the scaling factor on the log10 data of the standard antigen, plots corrected and uncorrected log10(MFI) vs. Dilution Factor, and displays the plots.
