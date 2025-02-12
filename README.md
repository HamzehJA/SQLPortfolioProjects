# COVID Data Analysis with SQL

## Overview

This project demonstrates SQL queries for analyzing and visualizing COVID-19 data. Using the `SQLPortfolio..CovidFatalities` and `SQLPortfolio..CovidVaccinations` datasets, the analysis explores several key metrics like infection rates, death rates, and vaccination progress. The queries focus on different geographical levels: from global and continental to country-specific insights.

---

## Key Metrics Analyzed:

- **Death Percentage:** Analyzing the likelihood of COVID-19 deaths based on total cases.
- **Infection Percentage:** Calculating the proportion of the population affected by COVID-19.
- **Vaccination Progress:** Tracking the percentage of the population vaccinated.

---

## Queries Overview:

### 1. **Basic Data Retrieval**
```sql
-- Fetching all columns from the CovidFatalities table, ordered by columns 3 and 4
SELECT * 
FROM SQLPortfolio..CovidFatalities
ORDER BY 3, 4;

 Case vs Death Analysis (Death Percentage)
sql
Copy
-- Looking at the likelihood of Covid-related deaths in China
SELECT Location, date, total_cases, total_deaths, 
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'China'
ORDER BY 1, 2;
