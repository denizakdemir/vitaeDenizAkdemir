#!/usr/bin/env Rscript

# Script to update bibliography from Google Scholar
# Requires the 'scholar' package

# Set working directory to the project root
script_dir <- dirname(normalizePath(commandArgs(trailingOnly = FALSE)[grep("--file=", commandArgs(trailingOnly = FALSE))][1], winslash = "/"))
project_dir <- dirname(script_dir)
setwd(project_dir)

# Install required packages if not already installed
if (!require("scholar")) {
  install.packages("scholar", repos = "https://cloud.r-project.org")
}

# Load required libraries
library(scholar)
library(bibtex)

# Set Google Scholar ID
# You need to replace 'YOUR_GOOGLE_SCHOLAR_ID' with your actual Google Scholar ID
# To find your Google Scholar ID, go to your Google Scholar profile and look at the URL
# It will look something like: https://scholar.google.com/citations?user=XXXXXXXXXXXX
# The ID is the value after 'user='
# NOTE: Replace this with your actual Google Scholar ID
# Use Deniz Akdemir's Google Scholar ID
google_scholar_id <- "O_xha20AAAAJ"

cat("Fetching publications from Google Scholar...\n")

# Get publications from Google Scholar
publications <- get_publications(google_scholar_id)
cat(sprintf("Found %d publications\n", nrow(publications)))

# Read existing BibTeX file
existing_bibtex_file <- "data/DA_bibliography.bib"
existing_bibtex <- NA
tryCatch({
  if (file.exists(existing_bibtex_file)) {
    cat("Reading existing BibTeX file...\n")
    tryCatch({
      existing_bibtex <- bibtex::read.bib(existing_bibtex_file)
      cat(sprintf("Found %d existing entries\n", length(existing_bibtex)))
    }, error = function(e) {
      cat(sprintf("Error reading BibTeX file: %s\n", e$message))
      existing_bibtex <- list() # Initialize to empty list to avoid further errors
    })
  }
}, error = function(e) {
  cat(sprintf("Error reading BibTeX file: %s\n", e$message))
})


# Create BibTeX entries for new publications
new_entries <- list()
for (i in 1:nrow(publications)) {
  # Check if publication already exists in BibTeX file
  pub_title <- publications$title[i]
  exists <- FALSE
  
  if (!is.na(existing_bibtex)[1]) {
    for (j in 1:length(existing_bibtex)) {
      if (tolower(existing_bibtex[[j]]$title) == tolower(pub_title)) {
        exists <- TRUE
        break
      }
    }
  }
  
  if (!exists) {
    cat(sprintf("Adding new publication: %s\n", pub_title))
    
    # Get details for the publication
    pub_id <- publications$pubid[i]
    details <- get_publication_data(google_scholar_id, pub_id)

    # Print the details$year value to the console
    cat(sprintf("details$year: %s\n", details$year))

    # Create BibTeX entry
    entry <- bibentry(
      bibtype = ifelse(grepl("conference|proceedings", tolower(details$journal)), "InProceedings", "Article"),
      title = details$title,
      author = details$author,
      journal = details$journal,
      year = details$year,
      volume = details$volume,
      number = details$number,
      pages = details$pages,
      doi = details$doi,
      key = paste0(strsplit(details$author, ",")[[1]][1], details$year, tolower(strsplit(details$title, " ")[[1]][1]))
    )
    
    new_entries <- c(new_entries, list(entry))
  }
}

# Append new entries to existing BibTeX file
if (length(new_entries) > 0) {
  cat(sprintf("Adding %d new entries to BibTeX file\n", length(new_entries)))
  
  # Convert to BibTeX format
  bibtex_entries <- lapply(new_entries, toBibtex)
  bibtex_text <- paste(unlist(bibtex_entries), collapse = "\n\n")
  
  # Append to existing file
  cat(bibtex_text, file = existing_bibtex_file, append = TRUE)
  cat("Bibliography updated successfully\n")
} else {
  cat("No new publications to add\n")
}
