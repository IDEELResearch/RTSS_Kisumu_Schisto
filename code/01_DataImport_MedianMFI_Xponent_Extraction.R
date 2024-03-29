# Pulling Median MFI from Xponent csv file. Please see datakey for GoogleDrive/R filename conversion. 
    # Required libraries
    library(tidyverse)

# Keep raw data files within the Luminex/raw data folder. 
  # Directory (raw Xponent data) and Loop initiation ----
directory <- "/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/raw/luminex/"

    # Get list of CSV files in the directory
    csv_files <- list.files(directory, pattern = "\\.csv$", full.names = TRUE)
    
    # Loop through each CSV file
    for (file_path in csv_files) {

  # File Extraction, initial triming, BSA subtraction for MFI data ---- 
      lines <- readLines(file_path)
      
      # Median MFI trimming by rows: Below "Median" and two above "Net MFI"    
            # Find the row index containing the word "Median"
            median_row_index <- grep("Median", lines)
            
            # Find the row index containing the word "Net MFI"
            net_mfi_row_index <- grep("Net MFI", lines)
            
            # Find the row index of two rows above "Net MFI"
            net_mfi_row_index <- net_mfi_row_index - 2
      
            # Extract data between "Median" and two rows above "Net MFI"
            data_lines <- lines[(median_row_index + 1):net_mfi_row_index]
      
        # Create a data frame
        results_df <- read.csv(text = paste(data_lines, collapse = "\n"), na.strings = "")
                
  #Trimming results_data , adding columns (Plate, Site), editing serology names  ----
     # Creation of results_df: Filter out columns between "Location" and "Total.Events"
        location_index <- grep("Location", colnames(results_df))
        total_events_index <- grep("Total.Events", colnames(results_df))
        columns_to_keep <- (location_index + 1):(total_events_index - 1)
        
        results_df <- results_df[, columns_to_keep]
        
     # BSA Subtraction
        # Assuming BSA column index is known
        bsa_index <- grep("BSA", colnames(results_df))
        
              # Store the BSA column separately
              bsa_values <- results_df[, bsa_index]
        
        # Identify numerical columns excluding BSA
        nonBSA_numerical_columns <- sapply(results_df[, -bsa_index], is.numeric)
        
        # Subtract BSA from numerical columns
        results_df[, nonBSA_numerical_columns] <- results_df[, nonBSA_numerical_columns] - bsa_values
        
          # Reinsert the BSA column
          results_df[, bsa_index] <- bsa_values

     # Adding serology type to numerical column names, Plate column (Plate_Serology)
          # CSV file name without the extension
              file_name <- basename(file_path)
              file_name_without_ext <- tools::file_path_sans_ext(file_name)
          
          
          # Split Plate column by "_"
              plate_split <- strsplit(as.character(file_name_without_ext), "_")
          
          # Extract the second part ("serology")
              serology <- sapply(plate_split, function(x) x[2])
          
          # Add serology type to the numerical column names
              numerical_columns <- sapply(results_df, is.numeric)
              numerical_column_names <- names(results_df)[numerical_columns]
              
              new_numerical_column_names <- paste0(serology, "_", numerical_column_names)
              
              # Rename the numerical columns
              names(results_df)[numerical_columns] <- new_numerical_column_names
          
          # Add Plate_serology type column
              results_df[[paste0("Plate_", serology)]] <- file_name_without_ext
          

  # File Export w/ Plate names in data/clean/luminex----
    
      # Extract filename without extension
            file_name <- basename(file_path)
            file_name_without_ext <- tools::file_path_sans_ext(file_name)
    
      # Rename the data frame with the filename included
          assign(paste0(file_name_without_ext, "_results_df"), results_df)
          
      # Export the final data frame to clean data/luminex
          export_path <- "/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/clean/luminex/"
          export_file <- paste0(export_path, file_name_without_ext, "_results_df.csv")
          write.csv(results_df, file = export_file, row.names = FALSE)

} #ending loop
