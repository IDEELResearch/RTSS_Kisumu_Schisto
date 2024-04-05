# Author: Sahal Thahir
# Date: 2024-03-24
# Description: This script extracts well-level data.

#directory

input_file <- "/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/raw/luminex/Ahero_IgG1_Test.csv"
    # QC ----
        # Bead count >50----
            # Create bead_qc dataframe   
                  # Find Bead count data 
                      # Start row: 1 below "DataType: Count" row but not "Per Bead Count"
                          start_row <- grep("DataType", lines) # Find rows with "DataType"
                          start_row <- start_row[grepl("Count", lines[start_row])] # Filter rows with "Count"
                          start_row <- start_row[!grepl("Per Bead", lines[start_row])]  # Filter out rows with "Per Bead"
                          start_row <- max(start_row) + 1 
                          
                      # End row: 2 above "Avg Net MFI" row
                          end_row <- grep("Avg Net MFI", lines) - 2
                  
                  # Extract beadqc_df
                      if (length(start_row) > 0 & length(end_row) > 0) {
                        beadqc_df <- read.csv(text = paste(lines[start_row:end_row], collapse = "\n"))
                      } else {
                        beadqc_df <- NULL
                      }
                  
                  # Check each numerical value in beadqc_df and replace values that do not meet the criteria with "Low"
                      for (col in names(beadqc_df)[sapply(beadqc_df, is.numeric)]) {
                        beadqc_df[[col]][beadqc_df[[col]] < 50] <- "Low"
                      }
                      
               # Export beadqc to qc folder
                  filename <- tools::file_path_sans_ext(basename(input_file))
                  
                  # Export filepath + Plate name in csv
                  output_file <- file.path("/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/qc", paste0(filename, "_beadqc.csv"))
                  
                  # Export the beadqc_df dataframe as a CSV file
                  write.csv(beadqc_df, file = output_file, row.names = FALSE)
               
            # Low bead list
                  # Create an empty list to store the report
                  low_values_report <- list()
                  
                  # Iterate through each row of the dataframe
                  for (i in 1:nrow(beadqc_df)) {
                    # Check for "Low" values in each cell of the row
                    low_values <- which(beadqc_df[i, ] == "Low")
                    
                    # If "Low" values are found in the row, create a report entry
                    if (length(low_values) > 0) {
                      location <- beadqc_df$Location[i]
                      sample <- beadqc_df$Sample[i]
                      
                      # Get the names of columns containing "Low"
                      low_columns <- names(beadqc_df)[low_values]
                      
                      # Append the report entry to the list
                      low_values_report <- c(low_values_report, list(data.frame(Location = location, Sample = sample, Low_Columns = toString(low_columns))))
                    }
                  }
                  
                # Combine all report entries into a single dataframe
                low_values_report <- do.call(rbind, low_values_report)
                  
                # Export low_values_report to qc folder
                  filename <- tools::file_path_sans_ext(basename(input_file))
                  
                    # Export filepath with "beadqc_report" in csv
                    output_file <- file.path("/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/qc", paste0(filename, "_beadqc_report.csv"))
                    
                    # Export the low_values_report dataframe as a CSV file
                    write.csv(low_values_report, file = output_file, row.names = FALSE)
                  
                  # Print a message indicating the export was successful
                  cat("The report has been exported to", output_file, "\n")
                  
                    
              
              