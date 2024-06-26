# Load necessary libraries
library(rmarkdown)
library(tools)
library(pdftools)

# Specify the directory containing CSV files
csv_folder <- "data/raw/luminex/"

# Specify the output directory for rendered R Markdown files
qc_output_dir <- "data/qc/"

# List all CSV files in the directory
csv_files <- list.files(csv_folder, pattern = "\\.csv$", full.names = TRUE)

# List to store names of processed CSV files
processed_files <- c()

# Loop over each CSV file
for (csv_file in csv_files) {
  # Render the R Markdown file for the current CSV file
  render(
    input = "02_Luminex-Xponent-Plate-level-QC.Rmd",
    output_file = file.path(qc_output_dir, file_path_sans_ext(basename(csv_file))),
    params = list(input_file = csv_file)
  )
  
  # Record the name of the processed CSV file
  processed_files <- c(processed_files, basename(csv_file))
}

# Generate table of contents with hyperlinks
toc <- data.frame(File = processed_files)
toc$Page <- seq_len(nrow(toc))

# Generate links to each section
toc$File <- paste0("[", toc$File, "](#sec:", gsub("\\.csv", "", toc$File), ")")

# Write table of contents to a temporary markdown file
toc_md <- tempfile(fileext = ".md")
writeLines(c("# Table of Contents", "", paste0("* ", toc$File)), toc_md)

# Compile the temporary markdown file to a PDF
toc_pdf <- tempfile(fileext = ".pdf")
render(toc_md, output_file = toc_pdf, output_format = "pdf_document")

# List all PDF files generated by rendering R Markdown files
pdf_files <- list.files(qc_output_dir, pattern = "\\.pdf$", full.names = TRUE)

# Combine table of contents PDF with other PDFs
final_pdf <- "data/Qc_compiled_report.pdf"
pdf_combine(c(toc_pdf, pdf_files), output = final_pdf)

