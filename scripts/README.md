# CV Scripts

This directory contains scripts for managing and generating CV templates.

## Scripts

- **update_and_generate.R**: Comprehensive script to update bibliography and generate all CVs
  ```bash
  Rscript update_and_generate.R
  ```
  This is the recommended script for regular maintenance as it:
  - Updates your bibliography from Google Scholar
  - Generates all CV variants (both PDF and HTML)
  - Updates the last modified date in the index.html

- **update_bibliography.R**: Script to update bibliography from Google Scholar only
  ```bash
  Rscript update_bibliography.R
  ```

- **simple_bibliography_update.R**: Simplified script for bibliography updates
  ```bash
  Rscript simple_bibliography_update.R
  ```

- **scholar_profile_finder.R**: Interactive tool to find your Google Scholar ID
  ```bash
  Rscript scholar_profile_finder.R
  ```

- **update_all_cvs.R**: Script to generate all CV variants at once
  ```bash
  Rscript update_all_cvs.R
  ```

## Requirements

These scripts require R with the following packages:
- vitae (for CV generation)
- rmarkdown (for rendering Rmd files)
- knitr (for document generation)
- scholar (for Google Scholar integration)
- bibtex (for bibliography handling)
- igraph and visNetwork (for collaboration network visualization)

The `update_and_generate.R` script will automatically install any missing packages.