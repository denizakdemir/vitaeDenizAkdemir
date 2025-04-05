#!/usr/bin/env Rscript

# Comprehensive script to:
# 1. Update bibliography from Google Scholar
# 2. Generate all CV variants
# 3. Update the last modified date in index.html

# Determine the project directory
script_dir <- dirname(normalizePath(commandArgs(trailingOnly = FALSE)[grep("--file=", commandArgs(trailingOnly = FALSE))][1], winslash = "/"))
project_dir <- dirname(script_dir)

# Set bibliography file path using the project directory
bib_file <- file.path(project_dir, "data", "DA_bibliography.bib")

# Set working directory to the project root
setwd(project_dir)

# Install required packages if not already installed
required_packages <- c("rmarkdown", "knitr", "vitae", "scholar", "bibtex")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    cat(sprintf("Installing package: %s\n", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

# Load additional required libraries
library(scholar)
library(bibtex)

# Get today's date for updating the index.html
today <- format(Sys.Date(), "%B %d, %Y")

# Set Google Scholar ID
google_scholar_id <- "O_xha20AAAAJ"

cat("Fetching publications from Google Scholar...\n")

# Get publications from Google Scholar
publications <- tryCatch({
  get_publications(google_scholar_id)
}, error = function(e) {
  cat(sprintf("Error fetching publications: %s\n", e$message))
  cat("Using existing bibliography file only\n")
  NULL
})

if (!is.null(publications)) {
  cat(sprintf("Found %d publications\n", nrow(publications)))
  
  # Read existing BibTeX file
  existing_bibtex <- list()
  if (file.exists(bib_file)) {
    cat("Reading existing BibTeX file...\n")
    tryCatch({
      existing_bibtex <- bibtex::read.bib(bib_file)
      cat(sprintf("Found %d existing entries\n", length(existing_bibtex)))
    }, error = function(e) {
      cat(sprintf("Error reading BibTeX file: %s\n", e$message))
      existing_bibtex <- list() # Initialize to empty list to avoid further errors
    })
  }
  
  # Create BibTeX entries for new publications
  new_entries <- list()
  for (i in 1:nrow(publications)) {
    # Check if publication already exists in BibTeX file
    pub_title <- publications$title[i]
    exists <- FALSE
    
    if (length(existing_bibtex) > 0) {
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
      details <- tryCatch({
        get_publication_data(google_scholar_id, pub_id)
      }, error = function(e) {
        cat(sprintf("Error getting details for publication %s: %s\n", pub_id, e$message))
        NULL
      })
      
      if (!is.null(details)) {
        # Print the details$year value to the console
        cat(sprintf("details$year: %s\n", details$year))
        
        # Create a sanitized key for the bibentry
        author_part <- strsplit(details$author, ",")[[1]][1]
        author_part <- gsub("[^a-zA-Z]", "", author_part)
        title_part <- tolower(strsplit(details$title, " ")[[1]][1])
        title_part <- gsub("[^a-zA-Z]", "", title_part)
        entry_key <- paste0(author_part, details$year, title_part)
        
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
          key = entry_key
        )
        
        new_entries <- c(new_entries, list(entry))
      }
    }
  }
  
  # Append new entries to existing BibTeX file
  if (length(new_entries) > 0) {
    cat(sprintf("Adding %d new entries to BibTeX file\n", length(new_entries)))
    
    # Convert to BibTeX format
    bibtex_entries <- lapply(new_entries, toBibtex)
    bibtex_text <- paste(unlist(bibtex_entries), collapse = "\n\n")
    
    # Append to existing file
    cat(bibtex_text, file = bib_file, append = TRUE)
    cat("Bibliography updated successfully\n")
  } else {
    cat("No new publications to add\n")
  }
}

# Define paths to CV templates
templates <- c(
  general = "templates/general/Vitae_General.Rmd",
  statistics = "templates/statistics/Vitae_Statistics.Rmd",
  genomics = "templates/genomics/Vitae_Genomics.Rmd",
  ai_ml = "templates/ai-ml/Vitae_AI_ML.Rmd",
  executive = "templates/executive/Vitae_Executive.Rmd"
)

# Define output directory
output_dir <- "outputs"

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Render each template
for (name in names(templates)) {
  cat(sprintf("Generating %s CV...\n", name))
  
  params <- list(bib_file = bib_file)
  
  # First try to generate PDF output
  tryCatch({
    rmarkdown::render(
      input = templates[[name]],
      output_dir = output_dir,
      output_format = "pdf_document",
      quiet = TRUE,
      params = params
    )
    cat(sprintf("%s PDF generated successfully\n", name))
  }, error = function(e) {
    cat(sprintf("Error generating %s PDF: %s\n", name, e$message))
  })
  
  # Then generate HTML output
  tryCatch({
    rmarkdown::render(
      input = templates[[name]],
      output_dir = output_dir,
      output_format = "html_document",
      quiet = TRUE,
      params = params
    )
    cat(sprintf("%s HTML generated successfully\n", name))
  }, error = function(e) {
    cat(sprintf("Error generating %s HTML: %s\n", name, e$message))
  })
}

# Update the last modified date in index.html
index_file <- file.path(project_dir, "index.html")
if (file.exists(index_file)) {
  index_content <- readLines(index_file)
  date_pattern <- "<div class=\"update-date\">Last Updated: .*?</div>"
  new_date_line <- paste0("<div class=\"update-date\">Last Updated: ", today, "</div>")
  index_content <- gsub(date_pattern, new_date_line, index_content)
  writeLines(index_content, index_file)
  cat("Updated last modified date in index.html\n")
}

cat("\nAll CVs have been generated in the outputs directory\n")