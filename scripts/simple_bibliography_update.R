#!/usr/bin/env Rscript

# Simple script to demonstrate updating bibliography
# Just reports number of publications from Google Scholar

# Set working directory to the project root
script_dir <- dirname(normalizePath(commandArgs(trailingOnly = FALSE)[grep("--file=", commandArgs(trailingOnly = FALSE))][1], winslash = "/"))
project_dir <- dirname(script_dir)
setwd(project_dir)

# Load required libraries
library(scholar)

# Set Google Scholar ID (Geoffrey Hinton's ID for demonstration)
google_scholar_id <- "JicYPdAAAAAJ"

cat("Fetching publications from Google Scholar...\n")

# Get publications from Google Scholar
publications <- get_publications(google_scholar_id)
cat(sprintf("Found %d publications by %s\n", 
            nrow(publications),
            get_profile(google_scholar_id)$name))

# Print the 5 most recent publications
cat("\nMost recent 5 publications:\n")
recent_pubs <- head(publications[order(publications$year, decreasing = TRUE),], 5)
for (i in 1:nrow(recent_pubs)) {
  cat(sprintf("%d. %s (%s)\n", 
              i,
              recent_pubs$title[i],
              recent_pubs$year[i]))
}

cat("\nTo update your CV with these publications:\n")
cat("1. Get your Google Scholar ID from your profile URL\n")
cat("2. Update the ID in the bibliography update script\n")
cat("3. Run the script to add new publications to your BibTeX file\n")