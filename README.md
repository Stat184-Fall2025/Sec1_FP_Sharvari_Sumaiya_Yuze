# Project Title

Do missing persons cases in Pennsylvania and Ohio from 1969 to 2024 exhibit overrepresentation across specific demographic groups, timespans and spatial contexts?

## Overview

This project explores missing persons data from the National Missing and Unidentified Persons System (NamUS) to identify demographic, temporal, and geographic patterns in reported cases from Pennsylvania and Ohio.

Specifically, we examine how missing-person counts differ by age group, biological sex, and race/ethnicity, and how these patterns evolve over time. By comparing two geographically close states, the analysis aims to determine whether observed differences are state-specific or reflect broader regional trends.

The primary deliverable of this project is a reproducible Quarto (QMD) report rendered as a PDF.

# Interesting Insights

One notable finding from this analysis is that both Pennsylvania and Ohio exhibit very similar demographic patterns across age, biological sex, and race/ethnicity, even though Pennsylvania consistently reports slightly higher overall counts.

Across all demographic combinations examined, the single group with the highest number of missing-person cases was:

Race/Ethnicity: White / Caucasian

Biological Sex: Female

Age Group: 20–40

This group accounted for the largest concentration of missing-person reports in the dataset, highlighting young adult White/Caucasian females as the most represented demographic category among reported cases. This pattern aligns with the broader age-based trends observed in both states, where the 20–40 age range consistently shows the highest missing-person counts.

A supporting visualization illustrating these demographic patterns is included in the repository as a static image exported from ggplot2.

## Data Sources and Acknowledgements

Dataset: National Missing and Unidentified Persons System (NamUS)
https://www.namus.gov/dashboard

NamUS is maintained by the U.S. Department of Justice and the National Institute of Justice (NIJ). Data are contributed by law enforcement agencies, medical examiners, and authorized forensic professionals. We acknowledge NamUS as the authoritative source for all missing-person records used in this project.

## Current Plan

The current phase of the project focuses on exploratory data analysis, including:

- Cleaning and wrangling raw NamUS data

- Creating derived variables (e.g., age groups, yearly counts)

- Producing demographic, temporal, and spatial visualizations

- Interpreting observed patterns descriptively (without causal claims)

Future extensions may include:

- Normalizing missing-person counts by state population

- Comparing PA and OH trends to national-level data

- Exploring city-level or seasonal patterns

## Repo Structure

├── MissingPersons.csv          # Raw NamUS data used in the analysis <br>
├── MissingPersonsAnalysis.qmd  # Main Quarto document (PDF output) <br>
├── figures/                    # Exported figures (PNG/JPG) used in README/report <br>
├── references.bib              # Bibliography file for citations <br>
├── apa7.csl                    # Citation style file <br> 
├── README.md                   # Project overview (this file) <br>

## Authors

- Sharvari Purighalla (spp6039@psu.edu)
- Sumaiya Azad (sva6303@psu.edu)
- Yuze Wang (ybw5512@psu.edu)

This project was completed as part of STAT 184.
For questions or comments, please contact any of the authors through the course repository or associated academic email.
