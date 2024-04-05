# Do Not Edit
lines <- readLines(input_file)
# Bead count >50
# create bead_qc dataframe   
# Find Bead count data----
#start row: 1 below "DataType: Count" row but not "Per Bead Count"
start_row <- grep("DataType", lines) # Find rows with "DataType"
start_row <- start_row[grepl("Count", lines[start_row])] # Filter rows with "Count"
start_row <- start_row[!grepl("Per Bead", lines[start_row])]  # Filter out rows with "Per Bead"

start_row <- max(start_row) + 1 

#end row: 2 above "Avg Net MFI" row
end_row <- grep("Avg Net MFI", lines) - 2

# Extract beadqc_df
if (length(start_row) > 0 & length(end_row) > 0) {
  beadqc_df <- read.csv(text = paste(lines[start_row:end_row], collapse = "\n"))
  
  # Trim beadqc_df to include only columns between "Location" and "Total.Events"
  total_events_index <- grep("Total.Events", colnames(beadqc_df))
  beadqc_df <- beadqc_df[, -((total_events_index + 1):ncol(beadqc_df))]
} else {
  beadqc_df <- NULL
}


# Convert the dataframe to long format
beadqc_long <- pivot_longer(beadqc_df, cols = -c(Location, Sample), names_to = "Numeric_Column", values_to = "Value")

# Convert the "Value" column to numeric
beadqc_long$Value <- as.numeric(beadqc_long$Value)

# Create the heatmap
ggplot(beadqc_long, aes(x = Numeric_Column, y = Location, fill = Value)) +
  geom_tile(color = "black") +
  scale_fill_gradient(low = "red", high = "blue") +  # Adjust color gradient as needed
  labs(x = "Numeric Columns", y = "Location") +  # Add axis labels
  theme_minimal()  # Customize plot theme if necessary




# Replace <50 bead as "Low"----
for (col in names(beadqc_df)[sapply(beadqc_df, is.numeric)]) {
  beadqc_df[[col]][beadqc_df[[col]] < min_beadcount] <- "Low"
}
# Export filepath + Plate name in csv
output_file <- file.path(file_path, paste0(tools::file_path_sans_ext(basename(input_file)), "_beadqc.csv"))

# Export the beadqc_df dataframe as a CSV file
write.csv(beadqc_df, file = output_file, row.names = FALSE)

# Print a message indicating the export was successful
cat("The bead QC report has been exported to", output_file, "\n")
