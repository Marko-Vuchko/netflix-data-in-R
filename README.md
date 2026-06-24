# Netflix Data Analysis in R

Exploratory analysis and statistical modeling of Netflix catalog data using R and the tidyverse. Joins multi-table datasets to study ratings, genres, countries, and release trends.

[![R](https://img.shields.io/badge/R-4.0%2B-276DC3?logo=r&logoColor=white)](https://www.r-project.org/)

---

## Overview

This project analyzes Netflix-style catalog data across five related CSV tables. It filters recent movies, joins ratings and metadata, and builds visualizations and logistic models to understand high-rated content patterns.

| Task | Business question | Method |
|------|-------------------|--------|
| **1** | What does the catalog structure look like? | Multi-table joins (titles, ratings, genres) |
| **2** | Which recent movies score above 7.5 on IMDb? | Threshold flag + density plots |
| **3** | How do runtime and ratings relate? | ggplot2 density & scatter views |
| **4** | Can we model high-rating probability? | Logistic regression (glm, binomial) |

---

## Dataset

| File | Description |
|------|-------------|
| `titles.csv` | Core title metadata (type, year, runtime, seasons) |
| `ratings.csv` | IMDb/TMDb scores linked by title ID |
| `genres.csv` | Genre assignments |
| `countries.csv` | Production countries |
| `certifications.csv` | Age certifications |

---

## Repository structure

```
.
├── analysis.R              # Main analysis script
├── titles.csv
├── ratings.csv
├── genres.csv
├── countries.csv
├── certifications.csv
├── LICENSE
└── README.md
```

---

## Quick start

```bash
git clone https://github.com/Marko-Vuchko/netflix-data-in-R.git
cd netflix-data-in-R
```

Install R packages (one-time):

```r
install.packages(c("readr", "tidyverse", "ggplot2"))
```

Run the analysis:

```bash
Rscript analysis.R
```

Or open the folder in RStudio and source `analysis.R`.

---

## Methodology

1. Load and inspect all CSV tables with `readr` and `glimpse()`.
2. Filter to movies from the last five catalog years.
3. Join titles with ratings; derive `high_rating` indicator (IMDb > 7.5).
4. Visualize rating patterns by runtime using ggplot2.
5. Fit logistic regression to explore drivers of high ratings.

---

## Tech stack

**R:** readr, tidyverse, dplyr, ggplot2

---

## Author

**Marko Vučković** — Data Analyst & Developer  
[GitHub](https://github.com/Marko-Vuchko) · [Email](mailto:markovucko12@gmail.com)

---

## License

This project is released under the [MIT License](LICENSE).
