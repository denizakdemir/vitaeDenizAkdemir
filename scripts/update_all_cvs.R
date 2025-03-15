#!/usr/bin/env Rscript

# Script to generate all CV variants
# Requires the 'rmarkdown' package

# Install required packages if not already installed
if (!require("rmarkdown")) {
  install.packages("rmarkdown", repos = "https://cloud.r-project.org")
}
if (!require("knitr")) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}
if (!require("vitae")) {
  install.packages("vitae", repos = "https://cloud.r-project.org")
}

# Define paths to CV templates
templates <- c(
  general = "../templates/general/Vitae_General.Rmd",
  statistics = "../templates/statistics/Vitae_Statistics.Rmd",
  genomics = "../templates/genomics/Vitae_Genomics.Rmd",
  ai_ml = "../templates/ai-ml/Vitae_AI_ML.Rmd",
  executive = "../templates/executive/Vitae_Executive.Rmd"
)

# Define output directory
output_dir <- "../outputs"

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Render each template
for (name in names(templates)) {
  cat(sprintf("Generating %s CV...\n", name))
  
  # Render the Rmd file
  rmarkdown::render(
    input = templates[[name]],
    output_dir = output_dir,
    quiet = TRUE
  )
  
  cat(sprintf("%s CV generated successfully\n", name))
}

cat("\nAll CVs have been generated in the outputs directory\n")