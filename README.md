# Deniz Akdemir - CV/Resume Repository

This repository contains multiple versions of my CV/resume, each tailored to highlight different aspects of my expertise (Statistics, Statistical Genomics, AI/ML, and a general version).

## Repository Structure

- **index.html**: Main portfolio page with links to all CV versions
- **templates/**: Contains different CV/resume templates
  - **general/**: General purpose CV template
  - **statistics/**: CV focused on Statistics expertise
  - **genomics/**: CV focused on Statistical Genomics expertise
  - **ai-ml/**: CV focused on AI and Machine Learning expertise
  - **executive/**: CV focused on leadership and management expertise
  
- **data/**: Contains data files
  - **DA_bibliography.bib**: BibTeX file with all publications
  
- **scripts/**: Scripts for automating CV generation and updates
  - **update_bibliography.R**: Script to update bibliography from Google Scholar
  - **simple_bibliography_update.R**: Simplified script for bibliography updates
  - **scholar_profile_finder.R**: Interactive tool to find your Google Scholar ID
  - **update_all_cvs.R**: Script to generate all CV variants at once

- **styles/**: Contains style files for the CV templates
  - **moderncv/**: ModernCV LaTeX style files
  - **awesome-cv/**: Awesome-CV LaTeX style files
  - **header_include.tex**: Common header includes for all templates

- **fonts/**: Contains font files required for CV templates
- **csl/**: Contains citation style files
- **outputs/**: Generated CV PDF files

## Requirements

- R with the following packages:
  - vitae
  - knitr
  - rmarkdown
  - scholar (for Google Scholar updates)

## Usage

1. Clone this repository
2. Install required R packages
3. Choose a template from the templates directory
4. Run the R Markdown file to generate your CV
5. To update your publications from Google Scholar, run the script in scripts/update_bibliography.R

## License

This project is licensed under the MIT License - see the LICENSE file for details.