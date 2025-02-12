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
``` sql
-- Fetching all columns from the CovidFatalities table, ordered by columns 3 and 4
SELECT * 
FROM SQLPortfolio..CovidFatalities
ORDER BY 3, 4;
```

--
Case vs Death Analysis (Death Percentage)

### 2. **Case vs Death Analysis (Death Percentage)**
``` sql
-- Looking at the likelihood of Covid-related deaths in China
SELECT Location, date, total_cases, total_deaths, 
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'China'
ORDER BY 1, 2;
```

### 3. U.S. Data Analysis (Infection and Death Percentages)
``` sql
-- Analyzing infection and death rates in the United States
SELECT Location, date, population, total_cases, 
       (total_cases/population)*100 AS InfectionPercentage, 
       total_deaths, 
       (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'United States'
ORDER BY 1, 2;
```

### 4. Global COVID Breakdown
``` sql
-- Global cases, deaths, and death percentages by date
SELECT date, SUM(new_cases) AS GlobalCases, SUM(cast(new_deaths AS INT)) AS GlobalDeaths, 
       SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 AS GlobalDeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;
```

## Data visualized 


# Running the Queries:

## Requirements: 
SQL Server or compatible SQL environment. Access to the SQLPortfolio..CovidFatalities and SQLPortfolio..CovidVaccinations datasets.

## How to Run:
Clone the repository to your local machine. Open your SQL environment. Execute the queries one by one to see the results and insights.

