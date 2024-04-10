# Author: Sahal Thahir
# Date: 2024-04-02
# Description: This script uses all_plates_df to create standard curves for median MFI across plates. 

library(tidyverse)
library(patchwork)

  # Standards dataframe ----
    standards_df <- all_plates_df[grep("Standard", all_plates_df$Sample), ]
    
        # Extract dilution factor from the Sample column and make it negative
        standards_df <- standards_df %>%
          mutate(Dilution_Factor = -as.numeric(str_extract(Sample, "\\d+")))
        
        # Move Dilution_Factor column to the second position
        standards_df <- standards_df %>%
          select(Sample, Dilution_Factor, everything())  

  # IgG1 ----
    
        # Filter out rows with NA values in the Plate_IgG1 column
        filtered_standards_df <- standards_df %>%
          drop_na(Plate_IgG1)
        
        # Extract the numerical columns containing "IgG1" in the column name
        igG1_columns <- names(filtered_standards_df)[grep("IgG1", names(filtered_standards_df))]
        
        # Create an empty list to store plots
        plots_list <- list()

    # Create plots for each "IgG1" column
    for (column in igG1_columns) {
      # Filter out non-numerical columns/values
      numeric_filtered_df <- filtered_standards_df %>%
        filter(!is.na(.data[[column]]) & is.numeric(.data[[column]]))
      
      # Create plot of numerical columns (MFIs)
      if (nrow(numeric_filtered_df) > 0) {
        plot <- ggplot(numeric_filtered_df, aes(x = Dilution_Factor, y = log10(.data[[column]]), color = factor(Plate_IgG1))) +
          geom_line() +
          labs(x = "Dilution Factor", y = paste("Log10 MFI"), color = "Plates", title = paste(column)) +
          theme_minimal()
        
        # Append plot to the list
        plots_list[[column]] <- plot
      }
    }

  # Combine plots using patchwork
  final_plot <- wrap_plots(plots = plots_list, nrow = 2)
  
  # Display the combined plot
  final_plot

  # Total IgG ----

          # Filter out rows with NA values in the Plate_TotalIgG column
          filtered_standards_df <- standards_df %>%
            drop_na(Plate_TotalIgG)
          
          # Extract the numerical columns containing "TotalIgG" in the column name
          totalIgG_columns <- names(filtered_standards_df)[grep("TotalIgG", names(filtered_standards_df))]
          
          # Create an empty list to store plots
          plots_list <- list()

    # Create plots for each "TotalIgG" column
    for (column in totalIgG_columns) {
      # Filter out non-numeric columns
      numeric_filtered_df <- filtered_standards_df %>%
        filter(!is.na(.data[[column]]) & is.numeric(.data[[column]]))
      
      # Create plot of numerical columns
      if (nrow(numeric_filtered_df) > 0) {
        plot <- ggplot(numeric_filtered_df, aes(x = Dilution_Factor, y = log10(.data[[column]]), color = factor(Plate_TotalIgG))) +
          geom_line() +
          labs(x = "Dilution Factor", y = paste("Log10 MFI"), color = "Plates", title = paste(column)) +
          theme_minimal()
        
        # Append plot to the list
        plots_list[[column]] <- plot
      }
    }
    
    # Combine plots using patchwork
    final_plot <- wrap_plots(plots = plots_list, nrow = 2)
    
    # Display the combined plot
    final_plot

  # IgG3 ----

        # Filter out rows with NA values in the Plate_IgG3 column
        filtered_standards_df <- standards_df %>%
          drop_na(Plate_IgG3)
        
        # Extract the numerical columns containing "IgG3" in the column name
        igG3_columns <- names(filtered_standards_df)[grep("IgG3", names(filtered_standards_df))]
        
        # Create an empty list to store plots
        plots_list <- list()
        
    # Create plots for each "IgG3" column
    for (column in igG3_columns) {
      # Filter out non-numeric columns
      numeric_filtered_df <- filtered_standards_df %>%
        filter(!is.na(.data[[column]]) & is.numeric(.data[[column]]))
      
      # Create plot of numerical columns
      if (nrow(numeric_filtered_df) > 0) {
        plot <- ggplot(numeric_filtered_df, aes(x = Dilution_Factor, y = log10(.data[[column]]), color = factor(Plate_IgG3))) +
          geom_line() +
          labs(x = "Dilution Factor", y = paste("Log10 MFI"), color = "Plates", title = paste(column)) +
          theme_minimal()
        
        # Append plot to the list
        plots_list[[column]] <- plot
      }
    }
    
    # Combine plots using patchwork
    final_plot <- wrap_plots(plots = plots_list, nrow = 2)
    
    # Display the combined plot
    final_plot





  # IgA1,2 ----
    
    # Filter out rows with NA values in the Plate_IgA1.2 column
    filtered_standards_df <- standards_df %>%
      drop_na(Plate_IgA1.2)
    
    # Extract the numerical columns containing "IgA1.2" in the column name
    IgA1.2_columns <- names(filtered_standards_df)[grep("IgA1.2", names(filtered_standards_df))]
    
    # Create an empty list to store plots
    plots_list <- list()
    
    # Create plots for each "IgA1.2" column
    for (column in IgA1.2_columns) {
      # Filter out non-numeric columns
      numeric_filtered_df <- filtered_standards_df %>%
        filter(!is.na(.data[[column]]) & is.numeric(.data[[column]]))
      
      # Create plot of numerical columns
      if (nrow(numeric_filtered_df) > 0) {
        plot <- ggplot(numeric_filtered_df, aes(x = Dilution_Factor, y = log10(.data[[column]]), color = factor(Plate_IgA1.2))) +
          geom_line() +
          labs(x = "Dilution Factor", y = paste("Log10 MFI"), color = "Plates", title = paste(column)) +
          theme_minimal()
        
        # Append plot to the list
        plots_list[[column]] <- plot
      }
    }
    
    # Combine plots using patchwork
    final_plot <- wrap_plots(plots = plots_list, nrow = 2)
    
    # Display the combined plot
    final_plot