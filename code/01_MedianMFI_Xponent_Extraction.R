# Create Median MFI data from Xponent 

#Extraction of Median MFI data (create median_df)----

  # Read the CSV file line by line
  lines <- readLines("/Users/sahal/Documents/R Projects/RTSS_Kisumu_Schisto/data/Chul.(SET2)_RTSS_25_Mar_2024_TotalIgG_AM.csv")
  
  # Remove null lines
  lines <- lines[lines != ""]
  
  # Find indices of rows containing "Median" and blank rows
  median_indices <- grep("Median", lines)
  blank_indices <- grep("^$", lines)
  
  # Find the index of the first blank row after each "Median" row
  median_blank_indices <- sapply(median_indices, function(median_index) {
    next_blank_index <- which(blank_indices > median_index)[1]
    if (!is.na(next_blank_index)) {
      blank_indices[next_blank_index]
    } else {
      length(lines) + 1
    }
  })
  
  # Extract data between "Median" and blank rows
  data_between_medians <- lapply(seq_along(median_indices), function(i) {
    start_index <- median_indices[i] + 1
    end_index <- median_blank_indices[i] - 1
    if (end_index >= start_index) {
      data <- lines[start_index:end_index]
      data <- read.csv(text = paste(data, collapse = "\n"), stringsAsFactors = FALSE)
      
      # Check if the Location column contains a blank value
      if ("" %in% data$Location) {
        end_index <- which(data$Location == "")[1] - 1
        if (is.na(end_index)) {
          end_index <- nrow(data)
        }
        data <- data[1:end_index, ]
      }
      
      data
    } else {
      NULL
    }
  })
  
  # Remove NULL entries
  data_between_medians <- Filter(Negate(is.null), data_between_medians)
  
  # Combine all dataframes into a single dataframe
  median_df <- do.call(rbind, data_between_medians)
  
  # Print or use result_df as needed
  print(median_df)

# Data extraction (create results_df, subtraction of BSA MFI) ---- 
  # dataframe of interest (Samples + Antigens)
      # Find the indices of "Location" and "Total.Events" columns
      location_index <- which(colnames(median_df) == "Location")
      total_events_index <- which(colnames(median_df) == "Total.Events")
      
      # Extract the desired columns from result_df
      results_df <- median_df[, (location_index + 1):(total_events_index - 1)]
      
      # Print or use desired_columns as needed
      print(results_df)

  # BSA subtraction
      # Find the index of the "BSA" column
      bsa_index <- which(colnames(results_df) == "BSA")
      
      # Subtract the "BSA" column from all numerical columns
      results_df[, -bsa_index] <- results_df[, -bsa_index] - results_df[, bsa_index]
      
      # Print or use the modified result_df as needed
      print(results_df)
      





