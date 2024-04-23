# List all CSV files in the data/raw/luminex folder
input_files <- list.files(path = "data/raw/luminex", pattern = "\\.csv$", full.names = TRUE)

# Output directory for individual PDF reports
output_dir <- "data/qc"

# Loop through each input file and render the R Markdown file
for (input_file in input_files) {
  # Extract the file name without extension
  output_file_name <- tools::file_path_sans_ext(basename(input_file))
  
  # Define the output PDF file path
  output_pdf_file <- file.path(output_dir, paste0(output_file_name, ".pdf"))
  
  # Render the R Markdown file for each input file
  rmarkdown::render("02_Luminex-Xponent-Plate-level-QC.Rmd",
                    params = list(input_file = input_file),
                    output_file = output_pdf_file)
}

# List all generated PDF files
pdf_files <- list.files(path = output_dir, pattern = "\\.pdf$", full.names = TRUE)

# Combine all PDF files into a single PDF
pdf_merged <- pdftools::pdf_combine(pdf_files, output = "plate_qc_compiled.pdf")

# Remove the individual PDF files
file.remove(pdf_files)

# Move the merged PDF to the desired location
file.rename(pdf_merged, "plate_qc_compiled.pdf")
