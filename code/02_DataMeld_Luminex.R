# Author: Sahal Thahir
# Date: 2024-03-28
# Description: This script compiles all cleaned data from RTSS luminex studies 

library(tidyverse)

# Directory
directory <- "/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/clean/luminex"

      # Read each CSV file into a list of data frames
      list_of_dfs <- lapply(list.files(path = directory, pattern = "\\.csv$", full.names = TRUE), 
                            function(file) read.csv(file, na.strings = c("NA", "NaN")))
      
      # Combine data frames by binding rows
      all_plates_df <- bind_rows(list_of_dfs)

            # Remove commas and convert to numeric for numerical columns
            all_plates_df <- all_plates_df %>%
              mutate(across(where(is.numeric), ~as.numeric(gsub(",", "", .))))
            
            # Replace remaining NAs with blanks
            all_plates_df <- all_plates_df %>%
              replace_na(replace = list(. = ""))

      # Move Plate_ columns to the end of df
        plate_columns <- grep("^Plate_", colnames(all_plates_df))
        all_plates_df_reordered <- cbind(all_plates_df[, -plate_columns], all_plates_df[, plate_columns])
        all_plates_df <- all_plates_df_reordered

# Summarize serology columns. If multiple values, use mean
      summary_function <- function(x) {
        if(is.numeric(x)) {
          mean(x, na.rm = TRUE)  # Add na.rm = TRUE here
        } else {
          toString(unique(x))
        }
      }

# Create rtss_df: All study participant samples with Sample value starting with "R"
      # Create rtss_df: All study participant samples with Sample value starting with "R"
      rtss_df <- all_plates_df %>%
        filter(grepl("^R", Sample)) %>%
        group_by(Sample) %>%
        mutate(across(everything(), ~ if (is.numeric(.)) replace(., . == "NaN", NA) else .))
      
      # Convert any non-numeric columns to their original class
      rtss_df <- mutate(rtss_df, across(where(function(x) !is.numeric(x)), as.character))
      

  # Study participant RID 
          # Sample RX(C/M)-### should become RID RX-###
                extract_rid <- function(sample) {
                  # Use regular expression to extract the RID
                  rid <- sub("([A-Z]{2})[C|M]-([0-9]+).*", "\\1-\\2", sample)
                  return(rid)
                }
          
          # Apply the function to the Sample column and create a new column called "RID"
          rtss_df <- rtss_df %>%
            mutate(RID = extract_rid(Sample))
          
          # Reorder the columns with RID at the front
          rtss_df <- rtss_df %>%
            select(RID, everything())
          
  # Timepoint
          # Add "-M01" to maternal sample IDs
          rtss_df <- rtss_df %>%
            mutate(Sample = ifelse(grepl("M", Sample) & !grepl("-M01", Sample), paste(Sample, "-M01", sep = ""), Sample))
          
          # Create Timepoint from Sample 
          rtss_df$Timepoint <- sapply(strsplit(rtss_df$Sample, "-"), function(x) x[3])
          
       
              # Move Timepoint to after RID
                  rtss_df <- rtss_df %>%
                    select(RID, Timepoint, everything())

# rtss_df export
       # File path for export
          file_path <- "/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/clean/RTSS_Luminex_comp.csv"
                  
      # Dataframe export
            write.csv(rtss_df, file = file_path, row.names = FALSE)
