# Create Median MFI data from Xponent 
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
result_df <- do.call(rbind, data_between_medians)

# Print or use result_df as needed
print(result_df)
