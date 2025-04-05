# Deniz Akdemir - CV/Resume Repository

This repository contains multiple versions of my CV/resume, each tailored to highlight different aspects of my expertise (Statistics, Statistical Genomics, AI/ML, Executive, and a general version). These are automatically generated from structured data and templates to maintain consistency across all versions.

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

### For quick updates

The simplest way to update all CVs and bibliography at once is to use the comprehensive update script:

```bash
Rscript scripts/update_and_generate.R
```

This will:
1. Update the bibliography from Google Scholar
2. Regenerate all CV variants (both PDF and HTML)
3. Update the last modified date in the index.html page

### For manual updates

If you prefer to update components individually:

1. **Update bibliography only**:
   ```bash
   Rscript scripts/update_bibliography.R
   ```

2. **Generate all CVs**:
   ```bash
   Rscript scripts/update_all_cvs.R
   ```

3. **Finding your Google Scholar ID**:
   ```bash
   Rscript scripts/scholar_profile_finder.R
   ```

4. **Generate a single CV**:
   Open a specific template in RStudio and click the "Knit" button, or use:
   ```bash
   Rscript -e "rmarkdown::render('templates/general/Vitae_General.Rmd', output_dir='outputs')"
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.