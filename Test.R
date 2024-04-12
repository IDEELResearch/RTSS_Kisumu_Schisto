# Load the required libraries
library(tidyverse)


# Creation of standards dataframes ----
    #standards_df: all standards data from all paltes
        # Extract standards from all_plates_df
          standards_df <- all_plates_df[grep("Standard", all_plates_df$Sample), ]
        
        # Create Dilution factor column
          standards_df <- standards_df %>%
            mutate(Dilution_Factor = -as.numeric(str_extract(Sample, "\\d+")))
          
            # Move Dilution_Factor column to the second position
              standards_df <- standards_df %>%
                select(Sample, Dilution_Factor, everything())  
        
        # Categorize MFI columns
          standard_mfi_cols <- names(standards_df)[sapply(standards_df, is.numeric) & names(standards_df) != "Dilution_Factor"]
        
        # Extract the part of the column name after "_"
          mfi_names <- gsub(".*_", "", standard_mfi_cols)
        
        # Gather MFI columns into long format
          standard_mfi_df <- tidyr::gather(standards_df, key = "Ab_Ag", value = "MFI", all_of(standard_mfi_cols))
        
        # Create Antigen groups
          standard_mfi_df <- standard_mfi_df %>%
            mutate(Antigen = gsub(".*_", "", Ab_Ag))
          
        #Create Plate column
            # Function to get Plate value for each row
              get_plate_value <- function(row) {
                non_empty_values <- na.omit(row)
                if (length(non_empty_values) == 0) {
                  return(NA_character_)
                } else {
                  return(non_empty_values[1])
                }
              }
            # Identify columns containing "Plate_"
              plate_cols <- grep("Plate_", names(standards_df), value = TRUE)
            
            # Create Plate column in standard_mfi_df
              standard_mfi_df <- standard_mfi_df %>%
                mutate(Plate = apply(standard_mfi_df[plate_cols], 1, get_plate_value))

        # Create Antigen groups
        standard_mfi_df <- standard_mfi_df %>%
          mutate(Antigen = gsub(".*_", "", Ab_Ag))
        
        
# Generate plots ----
        # All plates- scatterplot based on Antigen
        ggplot(standard_mfi_df, aes(x = Dilution_Factor, y = MFI, color = Plate)) +
          geom_point() +
          labs(x = "Dilution Factor", y = "MFI Value", color = "Plate") +
          ggtitle("MFI Standard curve based on Plates")

        # Standard curves for each antigen
        plots <- standard_mfi_df %>%
          split(.$Antigen) %>%
          map(~ggplot(.x, aes(x = Dilution_Factor, y = log10(MFI), color = Plate)) +
                geom_point() +
                labs(x = "Dilution Factor", y = "MFI Value", color = "Plate") +
                ggtitle(paste("MFI Standard curve for Antigen:", unique(.x$Antigen))))
        
            # Print the plots
            plots




