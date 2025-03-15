#!/usr/bin/env Rscript

# Helper script to find a Google Scholar profile and ID
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

# Get command line arguments (if any)
args <- commandArgs(trailingOnly = TRUE)

# Function to search for a scholar
search_scholar <- function(name) {
  cat(sprintf("Searching for Google Scholar profiles matching '%s'...\n", name))
  
  # Search for scholar profiles
  profiles <- scholar::get_scholar_id(name)
  
  # Check if any profiles were found
  if (nrow(profiles) == 0) {
    cat("No profiles found. Try a different name or search term.\n")
    return(invisible(NULL))
  }
  
  # Display the profiles
  cat("Found the following profiles:\n")
  for (i in 1:nrow(profiles)) {
    cat(sprintf("%d. %s (ID: %s, Affiliation: %s)\n", 
                i, profiles$name[i], profiles$id[i], profiles$affiliation[i]))
  }
  
  # Return the profiles data frame
  return(profiles)
}

# Function to get profile details
get_profile_details <- function(scholar_id) {
  cat(sprintf("Getting profile details for Scholar ID: %s\n", scholar_id))
  
  # Get profile information
  profile <- scholar::get_profile(scholar_id)
  
  cat("Profile details:\n")
  cat(sprintf("Name: %s\n", profile$name))
  cat(sprintf("Affiliation: %s\n", profile$affiliation))
  cat(sprintf("Homepage: %s\n", profile$homepage))
  cat(sprintf("Total citations: %s\n", profile$total_cites))
  cat(sprintf("h-index: %s\n", profile$h_index))
  cat(sprintf("i10-index: %s\n", profile$i10_index))
  
  # Get publication count
  pubs <- scholar::get_publications(scholar_id)
  cat(sprintf("Number of publications: %d\n", nrow(pubs)))
  
  # Return the profile information
  return(profile)
}

# Main execution
if (length(args) == 0) {
  # Interactive mode
  cat("Google Scholar Profile Finder\n")
  cat("===========================\n\n")
  
  cat("This script helps you find Google Scholar profiles and IDs.\n")
  cat("You can use these IDs to update your bibliography automatically.\n\n")
  
  # Ask for a name to search
  name <- readline(prompt = "Enter a name to search for (e.g., 'John Smith'): ")
  
  if (name != "") {
    profiles <- search_scholar(name)
    
    if (!is.null(profiles) && nrow(profiles) > 0) {
      # Ask which profile to view in detail
      choice <- as.numeric(readline(prompt = "Enter the number of the profile to view details (or 0 to exit): "))
      
      if (!is.na(choice) && choice > 0 && choice <= nrow(profiles)) {
        scholar_id <- profiles$id[choice]
        profile <- get_profile_details(scholar_id)
        
        cat("\nTo use this Google Scholar ID in your update_bibliography.R script:\n")
        cat(sprintf("1. Open update_bibliography.R\n"))
        cat(sprintf("2. Set google_scholar_id <- \"%s\"\n", scholar_id))
        cat(sprintf("3. Run the script to update your bibliography\n"))
      }
    }
  }
  
} else {
  # Command line mode
  name <- args[1]
  profiles <- search_scholar(name)
  
  if (!is.null(profiles) && nrow(profiles) > 0 && length(args) > 1) {
    scholar_id <- args[2]
    get_profile_details(scholar_id)
  }
}

cat("\nThank you for using the Google Scholar Profile Finder!\n")