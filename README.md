# RTSS_Kisumu_Schisto

This repository is for the RTS,S AS,01 MVIE subproject evaluating S. mansoni exposure on the function vaccine reponse in the Kisumu cohort. This project is a collaboration between U Mass, UNC, MIT, Harvard, and Brown University.

Sahal Thahir [sahal\@ad.unc.edu](mailto:sahal@ad.unc.edu){.email} (703)344-6153

## Code

#### 01_DataImport_MedianMFI_Xponent_Extraction

-   Data extraction on Luminex Xponent csv outputs for Median MFI data.
-   Performs BSA subtraction
-   Adds Serology type to antigen names in columns as long as csv titles are "study_Serology\_##" (serology type needs to be between two "\_"s)
-   Requires raw/clean data folders

#### 02_DataMeld_Luminex

-   Study specific: compiles all samples from "clean" luminex data folder based on sample type (all_plates_df)
-   Links maternal/infant samples by creating a shared "RID"
-   Extracts Timepoint from name (Maternal samples termed "M01")
-   Maintains Plate names for each sample run (\$Plates_Serologytype)

## Results

-   Nothing yet

## Data
Data is not included in the github folder though available on request. 

#### Luminex
-   Raw: contains renamed csvs from Angela's google drive folder. Currently just MagPix data from Kisumu
-   Clean: outputs from initial extraction, melded RTSS sample data
